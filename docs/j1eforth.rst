Verilog-Playground
==================

My Verilog Coding Experimental Area

j1eforth-verilog for FOMU
-------------------------

Translation of the j1eforth interactive Forth environment for FOMU
(https://www.crowdsupply.com/sutajio-kosagi/fomu with documentation at
https://workshop.fomu.im/en/latest/) translated from Silice to Verilog.

The original J1 CPU (https://www.excamera.com/sphinx/fpga-j1.html with a
very clear explanatory paper at https://www.excamera.com/files/j1.pdf)
along with the j1eforth interactive Forth environment
(https://github.com/samawati/j1eforth) was written for an FPGA with
access to 16384 x 16bit (256kbit) dual port single cycle block ram,
whereas the FOMU has 120kbit of block ram. It does however have 1024kbit
of single port ram (65536 x 16bit), which is more than sufficient for
j1eforth, but it has 2 cycle latency.

j1eforth for FOMU was originally coded in Silice
(https://github.com/sylefeb/Silice) due to my limited (i.e. NO) FPGA
programming experience. Silice provides a nice introduction to FPGA
programming for those coming from more tradition software coding. Once
this design was working, especially the timings to access the single
port ram, I translated it back to verilog, as an educational experience
for myself.

I’ve, in my opinion, tidied up the code, to make the variables more
explanatory, and to aid my coding.

For communicating via a terminal the tinyfpga_bx_usbserial
(https://github.com/stef/nb-fomu-hw) was implemented to provide a 115200
baud UART. A 32 character input and output buffer was added.

Using j1eforth-verilog on the FOMU
----------------------------------

Download the source code from this repository. Ensure that you have the
required toolchain installed. Compile (on Linux) with
``./fomu_hacker_USB_SPRAM.sh`` within the source directory.

Or download the precompiled ``j1eforth-verilog-FOMU.dfu`` file from this repository.

Upload the compiled, or downloaded bitstream to your FOMU with
``dfu-util -D build.dfu`` or ``dfu-util -D j1eforth-verilog-FOMU.dfu`` and connect via your chosen terminal, for
minicom ``minicom -D /dev/ttyACM0`` (ACM0 may need replacing with an
appropriate number on your machine).

Resources on the FOMU
---------------------

Resource usage:

::

   Info: Device utilisation:
   Info:            ICESTORM_LC:  2612/ 5280    49%
   Info:           ICESTORM_RAM:    19/   30    63%
   Info:                  SB_IO:    12/   96    12%
   Info:                  SB_GB:     8/    8   100%
   Info:           ICESTORM_PLL:     0/    1     0%
   Info:            SB_WARMBOOT:     0/    1     0%
   Info:           ICESTORM_DSP:     0/    8     0%
   Info:         ICESTORM_HFOSC:     0/    1     0%
   Info:         ICESTORM_LFOSC:     0/    1     0%
   Info:                 SB_I2C:     0/    2     0%
   Info:                 SB_SPI:     0/    2     0%
   Info:                 IO_I3C:     0/    2     0%
   Info:            SB_LEDDA_IP:     0/    1     0%
   Info:            SB_RGBA_DRV:     1/    1   100%
   Info:         ICESTORM_SPRAM:     4/    4   100%

   // Timing estimate: 36.89 ns (27.11 MHz)

The original J1 CPU has this instruction encoding:

::

   +---------------------------------------------------------------+
   | F | E | D | C | B | A | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
   +---------------------------------------------------------------+
   | 1 |                    LITERAL VALUE                          |
   +---------------------------------------------------------------+
   | 0 | 0 | 0 |            BRANCH TARGET ADDRESS                  |
   +---------------------------------------------------------------+
   | 0 | 0 | 1 |            CONDITIONAL BRANCH TARGET ADDRESS      |
   +---------------------------------------------------------------+
   | 0 | 1 | 0 |            CALL TARGET ADDRESS                    |
   +---------------------------------------------------------------+
   | 0 | 1 | 1 |R2P| ALU OPERATION |T2N|T2R|N2A|   | RSTACK| DSTACK|
   +---------------------------------------------------------------+
   | F | E | D | C | B | A | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
   +---------------------------------------------------------------+

   T   : Top of data stack
   N   : Next on data stack
   PC  : Program Counter
    
   LITERAL VALUES : push a value onto the data stack
   CONDITIONAL    : BRANCHS pop and test the T
   CALLS          : PC+1 onto the return stack

   T2N : Move T to N
   T2R : Move T to top of return stack
   N2A : STORE T to memory location addressed by N
   R2P : Move top of return stack to PC

   RSTACK and DSTACK are signed values (twos compliment) that are
   the stack delta (the amount to increment or decrement the stack
   by for their respective stacks: return and data)

The J1+ CPU adds up to 16 new alu operations, by assigning new alu
operations by using ALU bit 4 to determine if J1 or J1+ alu operations,
with the ALU instruction encoding:

::

   +---------------------------------------------------------------+
   | 0 | 1 | 1 |R2P| ALU OPERATION |T2N|T2R|N2A|J1+| RSTACK| DSTACK|
   +---------------------------------------------------------------+
   | F | E | D | C | B | A | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
   +---------------------------------------------------------------+

+-----------+-----------+-----------+-----------+-----------+-----------+
| Binary    | J1 CPU    | J1+ CPU   | J1 CPU    | J1+ CPU   | J1+       |
| ALU       |           |           | Forth     | Forth     | Im        |
| Operation |           |           | Word      | Word      | plemented |
| Code      |           |           | (notes)   |           | in        |
|           |           |           |           |           | j1eforth  |
+===========+===========+===========+===========+===========+===========+
| 0000      | T         | T==0      | (top of   | 0=        | X         |
|           |           |           | stack)    |           |           |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 0001      | N         | T<>0      | (next on  | 0<>       | X         |
|           |           |           | stack)    |           |           |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 0010      | T+N       | N<>T      | +         | <>        | X         |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 0011      | T&N       | T+1       | and       | 1+        | X         |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 0100      | T|N       | T<<1      | or        | 2\*       | X         |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 0101      | T^N       | T>>1      | xor       | 2/        | (stops    |
|           |           |           |           |           | ROM       |
|           |           |           |           |           | working)  |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 0110      | ~T        | N>T       | invert    | >         | X         |
|           |           |           |           | (signed)  |           |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 0111      | N==T      | NU>T      | =         | >         | X         |
|           |           |           |           | (         |           |
|           |           |           |           | unsigned) |           |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 1000      | N<T       | T<0       | <         | 0<        | X         |
|           |           |           | (signed)  |           |           |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 1001      | N>>T      | T>0       | rshift    | 0>        | X         |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 1010      | T-1       | ABST      | 1-        | abs       | X         |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 1011      | rt        | MXNT      | (push top | max       | X         |
|           |           |           | of return |           |           |
|           |           |           | stack to  |           |           |
|           |           |           | data      |           |           |
|           |           |           | stack)    |           |           |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 1100      | [T]       | MNNT      | @ (read   | min       | X         |
|           |           |           | from      |           |           |
|           |           |           | memory)   |           |           |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 1101      | N<<T      | -T        | lshift    | negate    | X         |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 1110      | dsp       | N-T       | (depth of | -         | (stops    |
|           |           |           | stacks)   |           | ROM       |
|           |           |           |           |           | working)  |
+-----------+-----------+-----------+-----------+-----------+-----------+
| 1111      | NU<T      | N>=T      | <         | >=        | X         |
|           |           |           | (         | (signed)  |           |
|           |           |           | unsigned) |           |           |
+-----------+-----------+-----------+-----------+-----------+-----------+

*I am presently unable to add the 2/ or - to the j1eforth ROM, as the
compiled ROM is no longer functional. Some assistance to add these
instructions would be appreciated.*

Memory Map
~~~~~~~~~~

+-----------------------------------+-----------------------------------+
| Hexadecimal Address               | Usage                             |
+===================================+===================================+
| 0000 - 3fff                       | Program code and data             |
+-----------------------------------+-----------------------------------+
| 4000 - 7fff                       | RAM (written to with              |
|                                   | ``value addr !``, read by         |
|                                   | ``addr @``                        |
+-----------------------------------+-----------------------------------+
| f000                              | UART input/output (best to leave  |
|                                   | to j1eforth to operate via IN/OUT |
|                                   | buffers)                          |
+-----------------------------------+-----------------------------------+
| f001                              | UART Status (bit 1 = TX buffer    |
|                                   | full, bit 0 = RX character        |
|                                   | available, best to leave to       |
|                                   | j1eforth to operate via IN/OUT    |
|                                   | buffers)                          |
+-----------------------------------+-----------------------------------+
| f002                              | RGB LED input/output bitfield {   |
|                                   | 13b0, red, green, blue }          |
+-----------------------------------+-----------------------------------+
| f003                              | BUTTONS input bitfield { 12b0,    |
|                                   | button 4, button 3, button 2,     |
|                                   | button 1 }                        |
+-----------------------------------+-----------------------------------+

INIT stages
~~~~~~~~~~~

Due to the size of the block ram on the FOMU (120kbit or 7680 x 16bit)
and the J1+ CPU requiring 256kbit (16384 x 16bit) of RAM, the J1+ CPU on
the FOMU copies the j1eforth code from an initialised block ram to
SPRAM, and uses the SPRAM for the J1+ CPU.

+-----------------------------------+-----------------------------------+
| INIT                              | Action                            |
+===================================+===================================+
| 0                                 | 0 the SPRAM. Due to the latency,  |
|                                   | this is controlled by CYCLE       |
|                                   | (pipeline).                       |
+-----------------------------------+-----------------------------------+
| 1                                 | COPY the j1eforth ROM to SPRAM.   |
|                                   | Due to latency, this is           |
|                                   | controoled by CYCLE (pipeline).   |
|                                   | The block ram at address          |
|                                   | [copaddress] is read in a         |
|                                   | separate always block. This       |
|                                   | allows the block ram to inferred  |
|                                   | by yosys.                         |
+-----------------------------------+-----------------------------------+
| 2                                 | SPARE (not used in the J1+ CPU).  |
+-----------------------------------+-----------------------------------+
| 3                                 | Start the J1+ CPU at pc==0 from   |
|                                   | SPRAM.                            |
+-----------------------------------+-----------------------------------+

Pipeline / CYCLE logic
~~~~~~~~~~~~~~~~~~~~~~

Due to blockram and SPRAM latency, there needs to be a pipeline for the
J1+ CPU on the FOMU, which is set to 0 to 12 stages. These are used as
follows:

+-----------------------------------+-----------------------------------+
| CYCLE                             | Action                            |
+===================================+===================================+
| ALL (at entry to INIT==3 loop)    | Check for input from the UART,    |
|                                   | put into buffer. Check if output  |
|                                   | in the UART buffer and send to    |
|                                   | UART. **NOTE:** To stop a race    |
|                                   | condition, uartOutBufferTop =     |
|                                   | newuartOutBufferTop is updated    |
|                                   | after output.                     |
+-----------------------------------+-----------------------------------+
| 0                                 | blockram: Read data stackNext and |
|                                   | rstackTop, started in CYCLE==9.   |
|                                   | SPRAM: Start the read of memory   |
|                                   | position [stackTop] by setting    |
|                                   | the SPRAM sram_address and        |
|                                   | sram_readwrite flag. This is done |
|                                   | speculatively in case the ALU     |
|                                   | needs this memory later in the    |
|                                   | pipeline.                         |
+-----------------------------------+-----------------------------------+
| 3                                 | Complete read of memory position  |
|                                   | [stackTop] from SPRAM by reading  |
|                                   | sram_data_read.                   |
+-----------------------------------+-----------------------------------+
| 4                                 | Start read of the instruction at  |
|                                   | memory position [pc] by setting   |
|                                   | sram_address and sram_readwrite   |
|                                   | flag.                             |
+-----------------------------------+-----------------------------------+
| 7                                 | Complete read of the instruction  |
|                                   | at memory position [pc] by        |
|                                   | reading sram_data_read. *The      |
|                                   | instruction is decoded            |
|                                   | automatically by the continuos    |
|                                   | assigns := block at the top of    |
|                                   | the code.*                        |
+-----------------------------------+-----------------------------------+
| 8                                 | Instruction Execution Determine   |
|                                   | if LITERAL, BRANCH, BRANCH, CALL  |
|                                   | or ALU. In the ALU (J1 CPU block) |
|                                   | the UART input buffer, UART       |
|                                   | status register, RGB LED status,  |
|                                   | input buttons or memory is        |
|                                   | selected as appropriate. The UART |
|                                   | buffers and the speculative       |
|                                   | memory read of [stackTop] are     |
|                                   | used to allow **ALL** ALU         |
|                                   | operations to execute in one      |
|                                   | cycle. At the end of the ALU if a |
|                                   | write to memory is required, this |
|                                   | is initiated by setting the       |
|                                   | sram_address, sram_data_write and |
|                                   | sram_readwrite flag. This will be |
|                                   | completed by CYCLE==12. Output to |
|                                   | UART output buffer or the RGB LED |
|                                   | is performed here if a write to   |
|                                   | an I/O address, not memory, is    |
|                                   | requested.                        |
+-----------------------------------+-----------------------------------+
| 9                                 | Start the writing to the block    |
|                                   | ram for the data and return       |
|                                   | stacks. This will be completed by |
|                                   | CYCLE==10.                        |
+-----------------------------------+-----------------------------------+
| 10                                | Update all of the J1+ CPU         |
|                                   | pointers for the data and return  |
|                                   | stacks, the program counter, and  |
|                                   | stackTop. Start the reading of    |
|                                   | the data and return stacks. This  |
|                                   | will be completed by CYCLE==11,   |
|                                   | but not actually read until the   |
|                                   | return to CYCLE==0.               |
+-----------------------------------+-----------------------------------+
| 12                                | Reset the sram_readwrite flag, to |
|                                   | complete any memory write started |
|                                   | in CYCLE==8 in the ALU.           |
+-----------------------------------+-----------------------------------+
| ALL (at end of INIT==3 loop)      | Reset the UART output if any      |
|                                   | character was transmitted. Move   |
|                                   | to the next CYCLE.                |
+-----------------------------------+-----------------------------------+

Forth Words to try
~~~~~~~~~~~~~~~~~~

-  ``cold`` reset
-  ``words`` list known Forth words
-  ``cr`` output a carriage return
-  ``2a emit`` output a \* (character 2a (hex) 42 (decimal)
-  ``decimal`` use decimal notation
-  ``hex`` use hexadecimal notation

.. figure:: j1eforth-verilog.png
   :alt: j1eforth on FOMU

   j1eforth on FOMU
