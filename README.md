<p align="center">
  <a title="FPGA Tomu (Fomu) Workshop" href="https://workshop.fomu.im/"><img width="600px" src="docs/_static/logo.png"/></a>
</p>

<p align="center">
  <a title="Nightly build" href="https://workshop.fomu.im/"><img src="https://img.shields.io/website.svg?label=workshop.fomu.im&longCache=true&style=flat-square&url=http%3A%2F%2Fworkshop.fomu.im%2Findex.html&logo=Read%20the%20Docs&logoColor=fff"></a><!--
  -->
  <a title="Nightly build" href="https://im-tomu.github.io/fomu-workshop"><img src="https://img.shields.io/website.svg?label=im-tomu.github.io%2Ffomu-workshop&longCache=true&style=flat-square&url=http%3A%2F%2Fim-tomu.github.io%2Ffomu-workshop%2Findex.html&logo=GitHub&logoColor=fff"></a><!--
  -->
  <a title="'test' workflow status" href="https://github.com/im-tomu/fomu-workshop/actions?query=workflow%3Atest"><img alt="'test' workflow status" src="https://img.shields.io/github/workflow/status/im-tomu/fomu-workshop/test?longCache=true&style=flat-square&label=test&logo=Github%20Actions&logoColor=fff"></a><!--
  -->
  <a title="'doc' workflow status" href="https://github.com/im-tomu/fomu-workshop/actions?query=workflow%3Adoc"><img alt="'doc' workflow status" src="https://img.shields.io/github/workflow/status/im-tomu/fomu-workshop/doc?longCache=true&style=flat-square&label=doc&logo=Github%20Actions&logoColor=fff"></a><!--
  -->
</p>

Hi, I'm Fomu!  [This workshop](https://workshop.fomu.im/) covers the basics of
Fomu in a top-down approach.  We'll start out by learning **what** Fomu is, **how to
load software** into Fomu, **how to write software** for Fomu and finally **how to
write hardware** for Fomu.

<p align="center">
  <a title="FPGA Tomu (Fomu) Workshop" href="https://workshop.fomu.im/"><img src="docs/_static/hw-pvt-back-bare-small.jpg"/></a>
  <a title="FPGA Tomu (Fomu) Workshop" href="https://workshop.fomu.im/"><img src="docs/_static/hw-pvt-front-bare-small.jpg"/></a>
</p>

FPGAs are complex, weird things, so we'll take a gentle approach and start out
by treating it like a Python interpreter first, and gradually peel away layers
until we're writing our own hardware registers.  You can take a break at any
time and explore!  Stop when you feel the concepts are too unfamiliar, or
plough on and dig deep into the world of hardware.

The contents of this workshop is published at [workshop.fomu.im](https://workshop.fomu.im).

## Repository Contents

- [docs](./docs) - The actual workshop directions and content.
- [litex](./litex) - The files required for [the Migen / LiteX section of the
  workshop](https://workshop.fomu.im/en/latest/migen.html).
- [reference](./reference) - Extra reference documentation such as schematics
  and part datasheets.
- [riscv-blink](./riscv-blink) - The files required for the [Fomu as a RISC-V
  CPU section of the workshop](https://workshop.fomu.im/en/latest/riscv.html).
- [verilog](./verilog) - The files required for the [Verilog on Fomu section
  of the workshop](https://workshop.fomu.im/en/latest/verilog.html).

# Development

For guidelines about how to develop the workshop or how to build the workshop
locally, see [DEVELOPMENT](DEVELOPMENT.md).
