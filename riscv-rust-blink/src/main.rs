#![no_std]
#![no_main]

extern crate panic_halt;

use fomu_pac;
use fomu_rt::entry;

mod rgb;
mod timer;

use rgb::RgbControl;
use timer::Timer;

const SYSTEM_CLOCK_FREQUENCY: u32 = 12_000_000;


// USB-support using the c-code from riscv-blink
#[link(name = "fomu-usb", kind = "static")]
extern "C" {
    fn usb_init();
    fn usb_connect();
    fn irq_init();
    fn isr();
    fn _start_trap_rust();
}

// set irq handler and call c-implementation
#[doc(hidden)]
#[link_section = ".trap.rust"]
#[no_mangle]
fn trap_handler() {
    unsafe {isr();}
}

// This is the entry point for the application.
// It is not allowed to return.
#[entry]
fn main() -> ! {

    // Call riscv-blink c-usb-initialization code
    unsafe {
        irq_init();
        usb_init();
        usb_connect();
    }

    let peripherals = fomu_pac::Peripherals::take().unwrap();

    let mut rgb_control = rgb::RgbControl::new(peripherals.RGB);
    let mut timer = Timer::new(peripherals.TIMER0);

    let mut i = 0;

    loop {
        color_wheel(&mut rgb_control, i);
        i = i.wrapping_add(1);

        msleep(&mut timer, 80);
    }
}

fn color_wheel(rgb: &mut RgbControl, position: u8) {
    let mut position = 255 - position;

    let (r, g, b) = if position < 85 {
        let r = 255 - position * 3;
        let g = 0;
        let b = position * 3;
        (r, g, b)
    } else if position < 170 {
        position -= 85;
        let r = 0;
        let g = position * 3;
        let b = 255 - position * 3;
        (r, g, b)
    } else {
        position -= 170;
        let r = position * 3;
        let g = 255 - position * 3;
        let b = 0;
        (r, g, b)
    };

    rgb.set(r, g, b);
}

fn msleep(timer: &mut Timer, ms: u32) {
    timer.disable();

    timer.reload(0);
    timer.load(SYSTEM_CLOCK_FREQUENCY / 1_000 * ms);

    timer.enable();

    // Wait until the time has elapsed
    while timer.value() > 0 {}
}
