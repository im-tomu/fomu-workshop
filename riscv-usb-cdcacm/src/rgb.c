#include <rgb.h>
#include <generated/csr.h>

enum led_registers {
    LEDDCR0 = 8,
    LEDDBR = 9,
    LEDDONR = 10,
    LEDDOFR = 11,
    LEDDBCRR = 5,
    LEDDBCFR = 6,
    LEDDPWRR = 1,
    LEDDPWRG = 2,
    LEDDPWRB = 3,
};

#define BREATHE_ENABLE (1 << 7)
#define BREATHE_EDGE_ON (0 << 6)
#define BREATHE_EDGE_BOTH (1 << 6)
#define BREATHE_MODE_MODULATE (1 << 5)
#define BREATHE_RATE(x) ((x & 7) << 0)

#define RGB_SWITCH_MODE(x) do { \
    if (rgb_mode == x) \
        return; \
    rgb_mode = x; \
    /* Toggle LEDD_EXE to force the mode to switch */ \
    rgb_ctrl_write(           (1 << 1) | (1 << 2)); \
    rgb_ctrl_write((1 << 0) | (1 << 1) | (1 << 2)); \
} while(0)

static enum {
    INVALID = 0,
    IDLE,
    WRITING,
    ERROR,
    DONE,
} rgb_mode;

static void rgb_write(uint8_t value, uint8_t addr) {
    rgb_addr_write(addr);
    rgb_dat_write(value);
}

void rgb_init(void) {
    // Turn on the RGB block and current enable, as well as enabling led control
    rgb_ctrl_write((1 << 0) | (1 << 1) | (1 << 2));

    // Enable the LED driver, and set 250 Hz mode.
    // Also set quick stop, which we'll use to switch patterns quickly.
    rgb_write((1 << 7) | (1 << 6) | (1 << 3), LEDDCR0);

    // Set clock register to 12 MHz / 64 kHz - 1
    rgb_write((12000000/64000)-1, LEDDBR);

    rgb_mode_idle();
}

void rgb_mode_idle(void) {
    RGB_SWITCH_MODE(IDLE);
    // rgb_mode_writing(); return;
    rgb_write(12, LEDDONR);
    rgb_write(24, LEDDOFR);

    rgb_write(BREATHE_ENABLE | BREATHE_EDGE_BOTH
            | BREATHE_MODE_MODULATE | BREATHE_RATE(2), LEDDBCRR);
    rgb_write(BREATHE_ENABLE | BREATHE_MODE_MODULATE | BREATHE_RATE(3), LEDDBCFR);

    rgb_write(0x00/4, LEDDPWRG); // Red
    rgb_write(0x4a/4, LEDDPWRB); // Green
    rgb_write(0xe1/4, LEDDPWRR); // Blue
}

void rgb_mode_writing(void) {
    RGB_SWITCH_MODE(WRITING);
    rgb_write(1, LEDDONR);
    rgb_write(2, LEDDOFR);

    rgb_write(BREATHE_ENABLE | 0
            | BREATHE_MODE_MODULATE | BREATHE_RATE(1), LEDDBCRR);
    rgb_write(BREATHE_ENABLE | BREATHE_MODE_MODULATE | BREATHE_RATE(3), LEDDBCFR);

    rgb_write(0x00/4, LEDDPWRG); // Red
    rgb_write(0x7a/4, LEDDPWRB); // Green
    rgb_write(0x51/4, LEDDPWRR); // Blue
}

void rgb_mode_error(void) {
    RGB_SWITCH_MODE(ERROR);
    rgb_write(3, LEDDONR);
    rgb_write(3, LEDDOFR);

    rgb_write(BREATHE_ENABLE | BREATHE_EDGE_BOTH
            | BREATHE_MODE_MODULATE | BREATHE_RATE(2), LEDDBCRR);
    rgb_write(BREATHE_ENABLE | BREATHE_MODE_MODULATE | BREATHE_RATE(3), LEDDBCFR);

    rgb_write(0xf0/4, LEDDPWRG); // Red
    rgb_write(0x0a/4, LEDDPWRB); // Green
    rgb_write(0x01/4, LEDDPWRR); // Blue
}

void rgb_mode_done(void) {
    RGB_SWITCH_MODE(DONE);
    rgb_write(8, LEDDONR);
    rgb_write(8, LEDDOFR);

    rgb_write(BREATHE_ENABLE | BREATHE_EDGE_BOTH
            | BREATHE_MODE_MODULATE | BREATHE_RATE(2), LEDDBCRR);
    rgb_write(BREATHE_ENABLE | BREATHE_MODE_MODULATE | BREATHE_RATE(3), LEDDBCFR);

    rgb_write(0x14/4, LEDDPWRG); // Red
    rgb_write(0xff/4, LEDDPWRB); // Green
    rgb_write(0x44/4, LEDDPWRR); // Blue
}