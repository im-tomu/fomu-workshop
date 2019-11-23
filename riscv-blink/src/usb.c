#include <stdint.h>
#include <generated/csr.h>
#include <usb.h>

struct usb_setup_request;

void epfifo_usb_isr(void);
void epfifo_usb_init(void);
void epfifo_usb_connect(void);
void epfifo_usb_idle(void);
void epfifo_usb_disconnect(void);
void epfifo_usb_set_address(uint8_t address);
void epfifo_usb_ack_in(uint8_t epno);
void epfifo_usb_ack_out(uint8_t epno);
void epfifo_usb_err_in(uint8_t epno);
void epfifo_usb_err_out(uint8_t epno);
void epfifo_usb_send(const void *data, int total_count);

void eptri_usb_isr(void);
void eptri_usb_init(void);
void eptri_usb_connect(void);
void eptri_usb_idle(void);
void eptri_usb_disconnect(void);
void eptri_usb_set_address(uint8_t address);
void eptri_usb_ack_in(uint8_t epno);
void eptri_usb_ack_out(uint8_t epno);
void eptri_usb_err_in(uint8_t epno);
void eptri_usb_err_out(uint8_t epno);
void eptri_usb_send(const void *data, int total_count);

void usb_isr(void) {
    if (version_major_read() == 2)
        eptri_usb_isr();
    else
        epfifo_usb_isr();
}

void usb_init(void) {
    if (version_major_read() == 2)
        eptri_usb_init();
    else
        epfifo_usb_init();
}

void usb_connect(void) {
    if (version_major_read() == 2)
        eptri_usb_connect();
    else
        epfifo_usb_connect();
}

void usb_idle(void) {
    if (version_major_read() == 2)
        eptri_usb_idle();
    else
        epfifo_usb_idle();
}

void usb_disconnect(void) {
    if (version_major_read() == 2)
        eptri_usb_disconnect();
    else
        epfifo_usb_disconnect();
}

void usb_set_address(uint8_t address) {
    if (version_major_read() == 2)
        eptri_usb_set_address(address);
    else
        epfifo_usb_set_address(address);
}

void usb_ack_in(uint8_t epno) {
    if (version_major_read() == 2)
        eptri_usb_ack_in(epno);
    else
        epfifo_usb_ack_in(epno);
}

void usb_ack_out(uint8_t epno) {
    if (version_major_read() == 2)
        eptri_usb_ack_out(epno);
    else
        epfifo_usb_ack_out(epno);
}

void usb_err_in(uint8_t epno) {
    if (version_major_read() == 2)
        eptri_usb_err_in(epno);
    else
        epfifo_usb_err_in(epno);
}

void usb_err_out(uint8_t epno) {
    if (version_major_read() == 2)
        eptri_usb_err_out(epno);
    else
        epfifo_usb_err_out(epno);
}

void usb_send(const void *data, int total_count) {
    if (version_major_read() == 2)
        eptri_usb_send(data, total_count);
    else
        epfifo_usb_send(data, total_count);
}
