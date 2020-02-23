# riscv-zig-blink

Written against zig 0.5.0+0cd89e917

You can obtain the zig compiler via https://ziglang.org/download/
e.g. a linux user might run:
```
curl -L https://ziglang.org/builds/zig-linux-x86_64-0.5.0+0cd89e917.tar.xz | tar -xJf -
alias zig=./zig-linux-x86_64-0.5.0+0cd89e917/zig
```

Run `zig build --help` from this directory for usage and options.

`zig build run -Drelease` will compile the demo and and run it on your connected FOMU.
