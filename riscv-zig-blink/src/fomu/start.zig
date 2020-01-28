const root = @import("root");
const std = @import("std");

extern var _ftext: u8;
extern var _etext: u8;
extern var _frodata: u8 align(4);
extern var _erodata: u8 align(4);
extern var _fdata: u8 align(4);
extern var _gp: u8 align(16);
extern var _edata: u8 align(16);
extern var _fbss: u8 align(4);
extern var _ebss: u8 align(4);
extern var _end: u8;
extern var _fstack: u8;

export fn _start() linksection(".text.start") callconv(.Naked) noreturn {
    asm volatile (
        \\  j over_magic
        \\  .word 0xb469075a // Magic value for config flags
        \\  .word 0x00000020 // USB_NO_RESET flag so we can attach the debugger
        \\over_magic:
    );

    // set the stack pointer to `&_fstack`
    asm volatile (
        \\  la sp, _fstack + 4
    );

    // zero out bss
    asm (
        \\  la a0, %[fbss]
        \\  la a1, %[ebss]
        \\bss_loop:
        \\  beq  a0, a1, bss_done
        \\  sw   zero, 0(a0)
        \\  add  a0, a0,4
        \\  j    bss_loop
        \\bss_done:
        : [ret] "=" (-> void)
        : [fbss] "m" (&_fbss),
          [ebss] "m" (&_ebss)
    );

    // copy data from data rom (which is after rodata) to data
    asm (
        \\  la t0, %[erodata]
        \\  la t1, %[fdata]
        \\  la t2, %[edata]
        \\data_loop:
        \\  lw t3, 0(t0)
        \\  sw t3, 0(t1)
        \\  addi t0, t0, 4
        \\  addi t1, t1, 4
        \\  bltu t1, t2, data_loop
        : [ret] "=" (-> void)
        : [erodata] "m" (&_erodata),
          [fdata] "m" (&_fdata),
          [edata] "m" (&_edata)
    );

    // call user's main
    root.main();
}
