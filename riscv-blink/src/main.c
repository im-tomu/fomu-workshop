#include <irq.h>
#include <time.h>
#include <rgb.h>
#include <generated/csr.h>

// Input a value 0 to 255 to get a color value.
// The colours are a transition r - g - b - back to r.
static void color_wheel(uint8_t WheelPos) {
    WheelPos = 255 - WheelPos;
    uint8_t r, g, b;
    if(WheelPos < 85) {
        r = 255 - WheelPos * 3;
        g = 0;
        b = WheelPos * 3;
    }
    else if(WheelPos < 170) {
        WheelPos -= 85;
        r = 0;
        g = WheelPos * 3;
        b = 255 - WheelPos * 3;
    }
    else {
        WheelPos -= 170;
        r =WheelPos * 3;
        g = 255 - WheelPos * 3;
        b = 0;
    }

    rgb_set(r, g, b);
}

void isr(void) {
    irq_setie(0);
    return;
}


int main(void) {
    rgb_init();
    irq_setie(0);
    int i = 0;
    while (1) {
        i++;
        color_wheel(i++);
        msleep(80);
    }
}