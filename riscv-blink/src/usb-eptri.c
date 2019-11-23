#include <usb.h>
#include <irq.h>
#include <string.h>
#include <usb.h>
#include <usb-eptri.h>

__attribute__((aligned(4)))

//__attribute__((used, aligned(4)))
//static uint8_t volatile previous_setup_packet[10];
//__attribute__((used))
//volatile uint32_t previous_setup_length;

static uint8_t volatile out_buffer_length;
static uint8_t volatile out_buffer[128];
static uint8_t volatile out_ep;
static uint8_t volatile out_have;
static const int max_byte_length = 64;

static const uint8_t * volatile current_data;
static volatile int current_length;
static volatile uint8_t current_epno;
static volatile int data_offset;
static volatile int data_to_send;
static int next_packet_is_empty;

__attribute__((used))
const uint8_t * last_data;
__attribute__((used))
int last_length;
__attribute__((used))
int last_epno;
__attribute__((used))
int last_data_offset;
__attribute__((used))
int last_data_to_send;
__attribute__((used))
int last_packet_was_empty;

static uint8_t next_address = 0;

#define USB_EV_ERROR 1
#define USB_EV_PACKET 2

void eptri_usb_idle(void) {
    irq_setmask(irq_getmask() & ~(1 << USB_INTERRUPT));
}

void eptri_usb_disconnect(void) {
    irq_setmask(irq_getmask() & ~(1 << USB_INTERRUPT));
    usb_pullup_out_write(0);
}

void eptri_usb_connect(void) {
    usb_setup_ev_pending_write(usb_setup_ev_pending_read());
    usb_in_ev_pending_write(usb_in_ev_pending_read());
    usb_out_ev_pending_write(usb_out_ev_pending_read());
    usb_setup_ev_enable_write(3);
    usb_in_ev_enable_write(1);
    usb_out_ev_enable_write(1);

    // Reset the IN handler
    usb_in_ctrl_write(1 << CSR_USB_IN_CTRL_RESET_OFFSET);

    // Reset the SETUP handler
    usb_setup_ctrl_write(1 << CSR_USB_SETUP_CTRL_RESET_OFFSET);

    // Reset the OUT handler
    usb_out_ctrl_write(1 << CSR_USB_OUT_CTRL_RESET_OFFSET);

    // Accept incoming data by default.
    usb_out_ctrl_write(1 << CSR_USB_OUT_CTRL_ENABLE_OFFSET);

    usb_address_write(0);

    // Turn on the external pullup
    usb_pullup_out_write(1);

    // Unmask the interrupt so we can respond to interrupts
    irq_setmask(irq_getmask() | (1 << USB_INTERRUPT));
}

void eptri_usb_init(void) {
    out_buffer_length = 0;
    usb_pullup_out_write(0);
    usb_address_write(0);
    usb_out_ctrl_write(0);

    usb_setup_ev_enable_write(0);
    usb_in_ev_enable_write(0);
    usb_out_ev_enable_write(0);

    // Reset the IN handler
    usb_in_ctrl_write(1 << CSR_USB_IN_CTRL_RESET_OFFSET);

    // Reset the SETUP handler
    usb_setup_ctrl_write(1 << CSR_USB_SETUP_CTRL_RESET_OFFSET);

    // Reset the OUT handler
    usb_out_ctrl_write(1 << CSR_USB_OUT_CTRL_RESET_OFFSET);

    return;
}

static void process_tx(void) {

    // Don't allow requeueing -- only queue more data if the system is idle.
    if (!(usb_in_status_read() & (1 << CSR_USB_IN_STATUS_IDLE_OFFSET))) {
        return;
    }

    // Don't send empty data
    if (!current_data || !current_length) {
        return;
    }

    last_data_offset = data_offset;
    data_offset += data_to_send;

    last_data_to_send = data_to_send;
    data_to_send = current_length - data_offset;

    // Clamp the data to the maximum packet length
    if (data_to_send > max_byte_length) {
        last_data_to_send = data_to_send;
        data_to_send = max_byte_length;
        last_packet_was_empty = next_packet_is_empty;
        next_packet_is_empty = 0;
    }
    else if (data_to_send == max_byte_length) {
        last_packet_was_empty = next_packet_is_empty;
        next_packet_is_empty = 1;
    }
    else if (next_packet_is_empty) {
        last_packet_was_empty = next_packet_is_empty;
        next_packet_is_empty = 0;

        last_data_to_send = data_to_send;
        data_to_send = 0;
    }
    else if (current_data == NULL || data_to_send <= 0) {
        last_packet_was_empty = next_packet_is_empty;
        next_packet_is_empty = 0;

        last_data = current_data;
        last_length = current_length;
        last_data_offset = data_offset;
        last_data_to_send = data_to_send;

        current_data = NULL;
        current_length = 0;
        data_offset = 0;
        data_to_send = 0;
        return;
    }

    // We have more data to send, so fill the buffer
    int this_offset;
    for (this_offset = data_offset; this_offset < (data_offset + data_to_send); this_offset++) {
        usb_in_data_write(current_data[this_offset]);
    }

    // Updating the epno queues the data
    usb_in_ctrl_write(current_epno & 0xf);
    return;
}

static void process_rx(void) {
    // If we already have data in our buffer, don't do anything.
    if (out_have)
        return;

    // If there isn't any data in the FIFO, don't do anything.
    if (!(usb_out_status_read() & (1 << CSR_USB_OUT_STATUS_HAVE_OFFSET)))
        return;

    out_have = 1;
    out_ep = (usb_out_status_read() >> CSR_USB_OUT_STATUS_EPNO_OFFSET) & 0xf;
    out_buffer_length = 0;
    while (usb_out_status_read() & (1 << CSR_USB_OUT_STATUS_HAVE_OFFSET)) {
        out_buffer[out_buffer_length++] = usb_out_data_read();
    }

    // Strip off the CRC16 that's at the end of the buffer
    if (out_buffer_length >= 2)
        out_buffer_length -= 2;
}

void eptri_usb_send(const void *data, int total_count) {
    uint8_t epno = 0;
    while ((current_length || current_data) && !(usb_in_status_read() & 2))
        process_tx();
    last_epno = current_epno;

    current_data = (uint8_t *)data;
    current_length = total_count;
    current_epno = epno;
    data_offset = 0;
    data_to_send = 0;
    process_tx();
}

void eptri_usb_wait_for_send_done(void) {
    while (current_data && current_length)
        ;
    while (usb_in_status_read() & (1 << CSR_USB_IN_STATUS_HAVE_OFFSET))
        ;
}

void eptri_usb_isr(void) {
    uint8_t setup_packet[10];
    uint32_t setup_length;
    uint8_t setup_pending   = usb_setup_ev_pending_read();
    uint8_t in_pending      = usb_in_ev_pending_read();
    uint8_t out_pending     = usb_out_ev_pending_read();

    // Clear all interrupts before we handle them
    usb_setup_ev_pending_write(setup_pending);
    usb_in_ev_pending_write(in_pending);
    usb_out_ev_pending_write(out_pending);

    // USB reset event
    if (setup_pending & 2) {
        out_buffer_length = 0;
        out_have = 0;
        current_data = NULL;
        current_length = 0;
        usb_connect();
        return;
    }

    // We got a SETUP packet.  Copy it to the setup buffer and clear
    // the "pending" bit.
    if (setup_pending & 1) {
//        previous_setup_length = setup_length;
//        memcpy((void *)previous_setup_packet, (void *)setup_packet, sizeof(setup_packet));

        setup_length = 0;
        memset((void *)setup_packet, 0, sizeof(setup_packet));
        while (usb_setup_status_read() & (1 << CSR_USB_SETUP_STATUS_HAVE_OFFSET)) {
            setup_packet[setup_length++] = usb_setup_data_read();
        }

        // If we have 8 bytes, that's a full SETUP packet.
        // Otherwise, it was an RX error.
        if (setup_length == 10) {
            usb_setup((const struct usb_setup_request *)setup_packet, 8);
        }
    }

    // An "IN" transaction just completed.
    if (in_pending) {
        // Process more data to send, if we have any.
        process_tx();

        // If next_address is nonzero, then this is the completion of
        // the IN packet that follows as the final ACK.  This means
        // we're free to set our address now.
        if (next_address) {
            usb_address_write(next_address);
            next_address = 0;
        }
    } 

    // An "OUT" transaction just completed so we have new data.
    // (But only if we can accept the data)
    if (out_pending) {
        process_rx();
    }

    return;
}

void eptri_usb_ack_in(uint8_t ep) {
    (void)ep;
    // Writing to this register queues a transfer
    usb_in_ctrl_write(0);
}

void eptri_usb_ack_out(uint8_t ep) {
    (void)ep;
    out_have = 0;
    usb_out_ctrl_write(1 << CSR_USB_OUT_CTRL_ENABLE_OFFSET);
}

void eptri_usb_err_in(uint8_t ep) {
    (void)ep;
    usb_in_ctrl_write(1 << CSR_USB_IN_CTRL_STALL_OFFSET);
}

void eptri_usb_err_out(uint8_t ep) {
    (void)ep;
    usb_out_ctrl_write(1 << CSR_USB_OUT_CTRL_STALL_OFFSET);
}

int eptri_usb_recv(void *buffer, int buffer_len) {
    // Set the OUT response to ACK, since we are in a position to receive data now.
    if (out_have) {
        usb_ack_out(0);
    }
    while (1) {
        if (out_have) {
            if (buffer_len > out_buffer_length)
                buffer_len = out_buffer_length;
            memcpy(buffer, (void *)out_buffer, buffer_len);
            usb_ack_out(0);
            return buffer_len;
        }
    }
}

void eptri_usb_set_address(uint8_t new_address) {
    next_address = new_address;
}
