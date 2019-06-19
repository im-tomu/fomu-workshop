#include <stdio.h>
#include <irq.h>
#include <printf.h>
#include <uart.h>
#include <usb.h>
#include <time.h>
#include <rgb.h>
#include <spi.h>
#include <generated/csr.h>

struct ff_spi *spi;

__attribute__((section(".ramtext")))
void isr(void)
{
    unsigned int irqs;

    irqs = irq_pending() & irq_getmask();

    if (irqs & (1 << USB_INTERRUPT))
        usb_isr();
}

__attribute__((section(".ramtext")))
static void init(void)
{
    irq_setmask(0);
    irq_setie(1);
    usb_init();
    time_init();
    rgb_init();
}

__attribute__((section(".ramtext")))
int main(int argc, char **argv)
{
    (void)argc;
    (void)argv;

    init();

    usb_connect();
    while (1)
    {
        usb_poll();
    }
    return 0;
}