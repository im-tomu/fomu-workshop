# riscv-zig-blink

Written against zig 0.8.0

You can obtain the zig compiler via https://ziglang.org/download/
e.g. a linux user might run:
```
curl -L https://ziglang.org/download/0.8.0/zig-linux-x86_64-0.8.0.tar.xz | tar -xJf -
alias zig=./zig-linux-x86_64-0.8.0/zig
```

Run `zig build --help` from this directory for usage and options.

`zig build run -Drelease` will compile the demo and and run it on your connected FOMU.
