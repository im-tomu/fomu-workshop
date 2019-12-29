#!/usr/bin/sh


# Create bin file
riscv64-unknown-elf-objcopy target/riscv32i-unknown-none-elf/release/riscv-rust-blink -O binary fomu-rust.bin

# Add DFU suffix
cp fomu-rust.bin fomu-rust.dfu
dfu-suffix -v 1209 -p 70b1 -a fomu-rust.dfu

# Program FOMU
dfu-util -D fomu-rust.dfu
