eForth for the J1 Simulator and actual J1 FPGAs
-------------

J1 eForth is an interactive work-in-progress Forth designed to run on the [James Bowman's J1 FPGA soft core][j1] 
(see also [J1 on Github][J1github]). There is a Forth cross compiler written in Forth to
generate the interactice J1 eForth system, and a J1 simulator written in C to run J1 eForth simulated
on a PC.

J1 eForth also runs on actual J1 FPGAs. It has been ported to the [Papilio Pro][pappro] FPGA board,
where it executes Forth program at 66 MHz. It communicates with a host system using a serial line at a 
default speed of 115200 Bits/s.

### Prerequisites

   - [GNU make][gmake] (optional) for job control
   - [gforth][gforth] for cross compiling / generating the J1 eForth image
   - [WpdPack][pcap] for network simulation

If you want to run J1 eForth simulated on a PC:

   - [gcc][gcc] to compile the J1 simulator
   
If you want to run J1 eForth on a J1 in an FPGA:

   - [Xilinx ISE][xilinxise] to generate the FPGA bit stream (ISE 14.7)
   - [Papilio-Loader][paploader] to download the bitstream to the FPGA

### Directry Structure

    j1eforth
    ├── README.MD
    ├── j1.4th      cross compiler with J1 eForth
    ├── j1.c        J1 simulator
    └── fpga  
        ├── src     Verilog projects for J1 and UART (miniuart2) for Papilio Pro 
        └── test    testbenches

### Building and running the j1 Simulator
#### Compiling using gcc Mingw (Windows)

    gcc j1.c -o -lwpcap j1.exe

#### Creating flash image j1.bin (and j1.hex)

    gforth j1.4th
#### Running the Simulator

    j1.exe [optional argument]
    
    The argument to the simulator is an optional forth file that can be used to extend the dictionary
    and is passed to the simulator as the first argument during startup
    
    Words to test in the simulator : 
    
    [ see , ' , compile , [compile] , ?branch , branch , call, .. and many more ]
    
    Have fun , modify and pass on

### Running on Real Hardware

J1 eForth can run on an actual j1 FPGA. It has been ported to the [Papilio Pro][pappro] FPGA board.

#### Create the J1 bit stream:
   
Start Xilinx ise on project `vhdl/papiolo-pro-j1.xise`
choose `Generate Programming File` on the `papilio_pro_j1` component. This generates `papilio_pro_j1.bit`
including the Forth image (`j1.hex`) as initial memory (built before when generating the flash image).

#### Load the complete bit stream (J1 and memory) into the FPGA:
   
         sudo papilio-prog -v -f papilio_pro_j1.bit
 
   You might want to use the pre-built `pipilio_pro_j1.bit` for a quick start.

#### Connect to J1 eForth:
   
        screen /dev/tty.usbserial 115200

  or similar. J1 eForth should show the prompt
	  
	    eForth j1 v1.04
	    ok
	    
   If you only see the **`ok`** prompts issue a **`cold`** and press the enter key to reboot the system.


###  May the Forth be with you.

[pappro]: http://papilio.cc/index.php?n=Papilio.PapilioPro
[paploader]: http://papilio.cc/index.php?n=Papilio.PapilioLoaderV2
[pcap]: http://www.winpcap.org/archive/4.1.1-WpdPack.zip
[j1]: http://www.excamera.com/sphinx/fpga-j1.html
[j1github]: https://github.com/jamesbowman/j1

[gmake]: https://www.gnu.org/software/make/
[gcc]: https://gcc.gnu.org/
[gforth]: https://www.gnu.org/software/gforth/

[xilinxise]: http://www.xilinx.com/products/design-tools/ise-design-suite/ise-webpack.html
