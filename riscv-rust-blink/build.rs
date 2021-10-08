use cc;

// Build the USB-Support from the riscv-blink c-code
fn main() {
    cc::Build::new()
        .file("../riscv-blink/src/usb-dev.c")
        .file("../riscv-blink/src/usb-epfifo.c")
        .file("../riscv-blink/src/usb-eptri.c")
        .file("../riscv-blink/src/usb.c")
        .file("../riscv-blink/src/rgb.c")
        .file("src/c/irq.c")
        .include("../riscv-blink/include")
        
        .define("__vexriscv__", None)
        .compile("fomu-usb");
}
