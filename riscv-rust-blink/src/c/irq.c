#include <generated/csr.h>
#include <irq.h>
#include <usb.h>
#include <system.h>


void isr(void) {
    unsigned int irqs;

    irqs = irq_pending() & irq_getmask();

    if (irqs & (1 << USB_INTERRUPT)) {
        usb_isr();
    }

}

void irq_init() {
    irq_setmask(0);
    irq_setie(1);
    csrw(mie, 0x880);
}