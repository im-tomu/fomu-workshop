`define FOMU 1
`default_nettype none
// Correctly map pins for the iCE40UP5K SB_RGBA_DRV hard macro.
// The variables EVT, PVT and HACKER are set from the yosys commandline e.g. yosys -D HACKER=1
`ifdef EVT
`define BLUEPWM  RGB0PWM
`define REDPWM   RGB1PWM
`define GREENPWM RGB2PWM
`elsif HACKER
`define BLUEPWM  RGB0PWM
`define GREENPWM RGB2PWM
`define REDPWM   RGB1PWM
`elsif PVT
`define GREENPWM RGB0PWM
`define REDPWM   RGB1PWM
`define BLUEPWM  RGB2PWM
`else
`error_board_not_supported
`endif

module top(
  // 48MHz Clock Input
  input   clki,
  // LED outputs
  output rgb0,          // blue
  output rgb1,          // green
  output rgb2,          // red
  // USB Pins
  output usb_dp,
  output usb_dn,
  output usb_dp_pu,
  // SPI
  output spi_mosi,
  input  spi_miso,
  output spi_clk,
  output spi_cs,
  // USER pads
  input user_1,
  input user_2,
  input user_3,
  input user_4
);

    // Connect to system clk_48mhz (with buffering)
    wire clk, clk_48mhz;
    SB_GB clk_gb (
        .USER_SIGNAL_TO_GLOBAL_BUFFER(clki),
        .GLOBAL_BUFFER_OUTPUT(clk)
    );
    assign clk_48mhz = clk;

    // RGB LED Driver
    reg [2:0] setRGB;
    SB_RGBA_DRV #(
        .CURRENT_MODE("0b1"),       // half current
        .RGB0_CURRENT("0b000011"),  // 4 mA
        .RGB1_CURRENT("0b000011"),  // 4 mA
        .RGB2_CURRENT("0b000011")   // 4 mA
    ) RGBA_DRIVER (
        .CURREN(1'b1),
        .RGBLEDEN(1'b1),
        .`BLUEPWM(setRGB[0]),     // Blue
        .`REDPWM(setRGB[1]),      // Red
        .`GREENPWM(setRGB[2]),    // Green
        .RGB0(rgb0),
        .RGB1(rgb1),
        .RGB2(rgb2)
    );

    // user buttons
    wire [3:0] buttons;
    assign buttons = { user_4, user_3, user_2, user_1 };
    
    // SPRAM driver
    // https://github.com/damdoy/ice40_ultraplus_examples/blob/master/spram/top.v
    // 4 x 16384 x 16bit
    reg [15:0] sram_address;            // 16bit 0-65535 address
    reg [15:0] sram_data_read;          // data read from SPRAM after bank switching
    reg [15:0] sram_data_write;         // data to write to SPRAM
    assign sram_data_in = sram_data_write;
    wire [15:0] sram_data_in;           // to SB_SPRAM256KA
    wire [15:0] sram_data_out00;        // from SB_SPRAM256KA bank 00
    wire [15:0] sram_data_out01;        // from SB_SPRAM256KA bank 01
    wire [15:0] sram_data_out10;        // from SB_SPRAM256KA bank 10
    wire [15:0] sram_data_out11;        // from SB_SPRAM256KA bank 11
    wire sram_wren;
    reg sram_readwrite;
    assign sram_wren = sram_readwrite;

    always @(posedge clk_48mhz) begin
        // SPRAM automatic bank switching for reading data from SB_SPRAM256KA banks
        case( sram_address[15:14])
            2'b00: sram_data_read = sram_data_out00;
            2'b01: sram_data_read = sram_data_out01;
            2'b10: sram_data_read = sram_data_out10;
            2'b11: sram_data_read = sram_data_out11;
        endcase
    end

    SB_SPRAM256KA spram00 (
        .ADDRESS(sram_address),
        .DATAIN(sram_data_in),
        .MASKWREN(4'b1111),
        .WREN(sram_wren),
        .CHIPSELECT(sram_address[15:14]==2'b00),
        .CLOCK(clk_48mhz),
        .STANDBY(1'b0),
        .SLEEP(1'b0),
        .POWEROFF(1'b1),
        .DATAOUT(sram_data_out00)
    );
    SB_SPRAM256KA spram01 (
        .ADDRESS(sram_address),
        .DATAIN(sram_data_in),
        .MASKWREN(4'b1111),
        .WREN(sram_wren),
        .CHIPSELECT(sram_address[15:14]==2'b01),
        .CLOCK(clk_48mhz),
        .STANDBY(1'b0),
        .SLEEP(1'b0),
        .POWEROFF(1'b1),
        .DATAOUT(sram_data_out01)
    );
    SB_SPRAM256KA spram10 (
        .ADDRESS(sram_address),
        .DATAIN(sram_data_in),
        .MASKWREN(4'b1111),
        .WREN(sram_wren),
        .CHIPSELECT(sram_address[15:14]==2'b10),
        .CLOCK(clk_48mhz),
        .STANDBY(1'b0),
        .SLEEP(1'b0),
        .POWEROFF(1'b1),
        .DATAOUT(sram_data_out10)
    );
    SB_SPRAM256KA spram11 (
        .ADDRESS(sram_address),
        .DATAIN(sram_data_in),
        .MASKWREN(4'b1111),
        .WREN(sram_wren),
        .CHIPSELECT(sram_address[15:14]==2'b11),
        .CLOCK(clk_48mhz),
        .STANDBY(1'b0),
        .SLEEP(1'b0),
        .POWEROFF(1'b1),
        .DATAOUT(sram_data_out11)
    );

    // Generate RESET
    reg [31:0] RST_d;
    reg [31:0] RST_q;

    reg ready = 0;

    always @* begin
        RST_d = RST_q >> 1;
    end

    always @(posedge clk_48mhz) begin
    if (ready) begin
        RST_q <= RST_d;
    end else begin
        ready <= 1;
        RST_q <= 32'b111111111111111111111111111111;
    end
    end

    wire reset_main;
    assign reset_main = RST_q[0];
    wire run_main;
    assign run_main = 1'b1;

    
    // USB_ACM UART CODE
    // Generate reset signal
    reg [5:0] reset_cnt = 0;
    wire reset = ~reset_cnt[5];
    always @(posedge clk_48mhz)
            reset_cnt <= reset_cnt + reset;

    // uart pipeline in
    reg  [7:0] uart_in_data;
    reg  uart_in_valid;
    wire uart_in_ready;
    wire [7:0] uart_out_data;
    wire uart_out_valid;
    wire uart_out_ready;

    // usb uart - this instanciates the entire USB device.
    usb_uart uart (
        .clk_48mhz  (clk_48mhz),
        .reset      (reset),

        // pins
        .pin_usb_p( usb_dp ),
        .pin_usb_n( usb_dn ),

        // uart pipeline in
        .uart_in_data( uart_in_data ),
        .uart_in_valid( uart_in_valid ),
        .uart_in_ready( uart_in_ready ),

        .uart_out_data( uart_out_data ),
        .uart_out_valid( uart_out_valid ),
        .uart_out_ready( uart_out_ready  )
    );

    // USB Host Detect Pull Up
    assign usb_dp_pu = 1'b1;
    
    // j1eforth ROM
    reg [15:0]  rom[0:3336]; initial $readmemh("j1eforth-plus/j1.hex", rom);
    
    // CYCLE to control each stage
    // CYCLE allows 1 clk_48mhz cycle for BRAM access and 3 clk_48mhz cycles for SPRAM access
    // INIT to determine if copying rom to ram or executing
    // INIT 0 SPRAM, INIT 1 ROM to SPRAM, INIT 2 J1 CPU
    reg [3:0]   CYCLE = 0;
    reg [1:0]   INIT = 0;
    
    // Address for 0 to SPRAM, copying ROM, plus storage
    reg [15:0]  copyaddress = 0;
    reg [15:0]  bramREAD;
    reg         bramENABLE = 0;

    // instruction being executed with decoding information
    // +---------------------------------------------------------------+
    // | F | E | D | C | B | A | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
    // +---------------------------------------------------------------+
    // | 1 |                    LITERAL VALUE                          |
    // +---------------------------------------------------------------+
    // | 0 | 0 | 0 |            BRANCH TARGET ADDRESS                  |
    // +---------------------------------------------------------------+
    // | 0 | 0 | 1 |            CONDITIONAL BRANCH TARGET ADDRESS      |
    // +---------------------------------------------------------------+
    // | 0 | 1 | 0 |            CALL TARGET ADDRESS                    |
    // +---------------------------------------------------------------+
    // | 0 | 1 | 1 |R2P| ALU OPERATION |T2N|T2R|N2A|J1+| RSTACK| DSTACK|
    // +---------------------------------------------------------------+
    // | F | E | D | C | B | A | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
    // +---------------------------------------------------------------+
    reg [15:0]  instruction;
    wire [15:0] immediate = { 1'b0, instruction[14:0] };
    wire        is_lit = instruction[15];
    wire        is_alu = ( instruction[15:13] == 3'b011 );
    wire        is_call = ( instruction[15:13] == 3'b010 );
    wire        dstackWrite = (is_lit | ( is_alu & instruction[7] ) );
    wire        rstackWrite = (is_call | ( is_alu & instruction[6] ) );
    wire [4:0]  ddelta = { instruction[1], instruction[1], instruction[1], instruction[1:0] };
    wire [4:0]  rdelta = { instruction[3], instruction[3], instruction[3], instruction[3:2] };
    
    // data and return stacks with pointers
    reg [15:0]  dstack[0:31];
    reg [15:0]  rstack[0:31];
    reg [15:0]  stackTop = 0;
    reg [15:0]  newStackTop;
    reg [4:0]   dsp = 0;
    reg [4:0]   newDSP;
    reg [15:0]  stackNext;
    reg [15:0]  rstackTop;
    reg [4:0]   rsp = 0;
    reg [4:0]   newRSP;
    reg [15:0]  rStackTop;
    reg [15:0]  rstackWData;
    
    // program counter
    reg [12:0]  pc = 0;
    reg [12:0]  newPC;
    wire [12:0] pcPlusOne;
    assign pcPlusOne = pc + 1;
    
    // value read from SPRAM
    reg [15:0]  memoryInput;

    // UART input and output buffers
    reg [7:0]   uartInBuffer [0:31];
    reg [4:0]   uartInBufferNext = 0;
    reg [4:0]   uartInBufferTop = 0;
    reg [7:0]   uartOutBuffer [0:31];
    reg [4:0]   uartOutBufferNext = 0;
    reg [4:0]   uartOutBufferTop = 0;
    reg [4:0]   newUartOutBufferTop = 0;
    
    // READ from BRAM ROM
    always @(posedge clk_48mhz) begin
        if( bramENABLE )
            bramREAD <= rom[copyaddress];
    end

    // UART
    always @(posedge clk_48mhz) begin
    end 
    
    // MAIN LOOP
    always @(posedge clk_48mhz) begin
    
        if( reset == 1 ) begin
            pc <= 0;
            dsp <= 0;
            stackTop <= 0;
            rsp <= 0;
            
            CYCLE <= 0;
            INIT <= 0;
            copyaddress <= 0;

            uartInBufferNext <= 0;
            uartInBufferTop <= 0;
            uartOutBufferNext <= 0;
            uartOutBufferTop <= 0;
            newUartOutBufferTop <= 0;
        end else begin
        
            case( INIT )
                0: begin // 0 to SPRAM
                    case( CYCLE )
                        0: begin
                            // SETUP WRITE of 0 to SPRAM[copyaddress]
                            sram_address <= copyaddress;
                            sram_data_write <= 0;
                            sram_readwrite <= 1;
                        end 
                        11: begin
                            sram_readwrite <= 0;
                            copyaddress = copyaddress + 1;
                        end
                        12: begin
                            if( copyaddress == 16384 ) begin
                                INIT <= 1;
                                copyaddress <= 0;
                            end 
                        end 
                        default: begin
                        end
                    endcase
                end // 0 to SPRAM
                    
                1: begin // COPY ROM to SPRAM
                    bramENABLE = 1;
                    case( CYCLE )
                        2: begin
                            // SETUP WRITE of 0 to SPRAM[copyaddress]
                            sram_address <= copyaddress;
                            sram_data_write <= bramREAD;
                            sram_readwrite <= 1;
                        end 
                        11: begin
                            sram_readwrite <= 0;
                            copyaddress = copyaddress + 1;
                        end
                        12: begin
                            if( copyaddress == 4096 ) begin
                                INIT <= 2;
                                copyaddress <= 0;
                                bramENABLE = 0;
                            end 
                        end 
                        default: begin
                        end
                    endcase
                end // COPY ROM to SPRAM

                2: begin // SPARE INIT 
                    bramENABLE = 1;
                    case( CYCLE )
                        12: begin
                                INIT <= 3;
                        end 
                        default: begin
                        end
                    endcase
                end // SPARE INIT

                3: begin // MAIN J1 CPU LOOP
                    // READ from UART if character available and store
                    if( uart_out_valid ) begin
                        uartInBuffer[uartInBufferTop] <= uart_out_data;
                        uart_out_ready <= 1;
                        uartInBufferTop <= uartInBufferTop + 1;
                    end 
                    
                    // WRITE to UART if characters in buffer and UART is ready
                    if( ~(uartOutBufferNext == uartOutBufferTop) & ~( uart_in_valid ) ) begin
                        uart_in_data <= uartOutBuffer[uartOutBufferNext];
                        uart_in_valid <= 1;
                        uartOutBufferNext <= uartOutBufferNext + 1;
                    end 
                    uartOutBufferTop = newUartOutBufferTop;
                    
                    case( CYCLE )
                        0: begin
                            // Read stackNext and rStackTop
                            stackNext <= dstack[dsp];
                            rStackTop <= rstack[rsp];
            
                            // start READ memoryInput = [stackTop] result ready in 2 cycles
                            sram_address <= stackTop >> 1;
                            sram_readwrite <= 0;
                        end 
                        
                        3: begin
                            // wait then read the data from SPRAM
                            memoryInput <= sram_data_read;
                        end 
                        
                        4: begin
                            // start READ instruction = [pc] result ready in 2 cycles
                            sram_address <= pc;
                            sram_readwrite <= 0;
                        end 
                        
                        7: begin
                            // wait then read the instruction from SPRAM
                            instruction = sram_data_read;
                        end 
                        
                        8: begin
                            // J1 CPU instruction execute
                            if( is_lit ) begin 
                                // LITERAL Push value onto stack
                                newStackTop <= immediate;
                                newPC <= pcPlusOne;
                                newDSP <= dsp + 1;
                                newRSP <= rsp;
                            end else begin
                                case( instruction[14:13] )
                                    2'b00: begin
                                        // BRANCH
                                        newStackTop <= stackTop;
                                        newPC <= instruction[12:0];
                                        newDSP <= dsp;
                                        newRSP <= rsp;
                                    end 
                                    
                                    2'b01: begin
                                        // 0BRANCH
                                        newStackTop <= stackNext;
                                        newPC <= ( stackTop == 0 ) ? instruction[12:0] : pcPlusOne;
                                        newDSP <= dsp - 1;
                                        newRSP <= rsp;
                                    end 
                                    
                                    2'b10: begin
                                        // CALL
                                        newStackTop <= stackTop;
                                        newPC <= instruction[12:0];
                                        newDSP <= dsp;
                                        newRSP <= rsp + 1;
                                        rstackWData <= pcPlusOne << 1;
                                    end 
                                    
                                    2'b11: begin
                                        case( instruction[4] )
                                            // ALU
                                            1'b0: begin
                                                // J1 ALUOP
                                                case( instruction[11:8] )
                                                    4'b0000: newStackTop = stackTop;
                                                    4'b0001: newStackTop = stackNext;
                                                    4'b0010: newStackTop = stackTop + stackNext;
                                                    4'b0011: newStackTop = stackTop & stackNext;
                                                    4'b0100: newStackTop = stackTop | stackNext;
                                                    4'b0101: newStackTop = stackTop ^ stackNext;
                                                    4'b0110: newStackTop = ~stackTop;
                                                    4'b0111: newStackTop = {16{(stackNext == stackTop)}};
                                                    4'b1000: newStackTop = {16{($signed(stackNext) < $signed(stackTop))}};
                                                    4'b1001: newStackTop = stackNext >> stackTop[3:0];
                                                    4'b1010: newStackTop = stackTop - 1;
                                                    4'b1011: newStackTop = rStackTop;
                                                    4'b1100: begin
                                                        case( stackTop)
                                                            16'hf000: begin
                                                                newStackTop = { 8'b0, uartInBuffer[uartInBufferNext] };
                                                                uartInBufferNext = uartInBufferNext + 1;
                                                            end 
                                                            16'hf001: newStackTop = {14'b0, ( uartOutBufferTop + 1 == uartOutBufferNext ), ~(uartInBufferNext == uartInBufferTop)}; // Read UART status
                                                            16'hf002: newStackTop = setRGB; // Read to rgbLED status
                                                            16'hf003: newStackTop = {12'b0, buttons}; // Read buttons status
                                                            default: newStackTop = memoryInput; // memoryInput
                                                        endcase
                                                    end 
                                                    4'b1101: newStackTop = stackNext << stackTop[3:0];
                                                    4'b1110: newStackTop = {rsp, 3'b000, dsp};
                                                    4'b1111: newStackTop = {16{($unsigned(stackNext) < $unsigned(stackTop))}};
                                                endcase
                                            end 
                                            
                                            1'b1: begin
                                                // J1+ ALUOP
                                               case( instruction[11:8] )
                                                    4'b0000: newStackTop = {16{(stackTop == 0)}};
                                                    4'b0001: newStackTop = ~{16{(stackTop == 0)}};
                                                    4'b0010: newStackTop = ~{16{(stackNext == stackTop)}};
                                                    4'b0011: newStackTop = stackTop + 1;
                                                    4'b0100: newStackTop = stackTop << 1;
                                                    4'b0101: newStackTop = stackTop >> 1;
                                                    4'b0110: newStackTop = {16{($signed(stackNext) > $signed(stackTop))}};
                                                    4'b0111: newStackTop = {16{($unsigned(stackNext) > $unsigned(stackTop))}};
                                                    4'b1000: newStackTop = {16{($signed(stackTop) < 0)}};
                                                    4'b1001: newStackTop = {16{($signed(stackTop) > 0)}};
                                                    4'b1010: newStackTop = ( $signed(stackTop) < 0 ) ?  - stackTop : stackTop;
                                                    4'b1011: newStackTop = ( $signed(stackNext) > $signed(stackTop) ) ? stackNext : stackTop;
                                                    4'b1100: newStackTop = ( $signed(stackNext) < $signed(stackTop) ) ? stackNext : stackTop;
                                                    4'b1101: newStackTop = -stackTop;
                                                    4'b1110: newStackTop = stackNext - stackTop;
                                                    4'b1111: newStackTop = {16{($signed(stackNext) >= $signed(stackTop))}};
                                                endcase
                                            end 
                                        endcase // J1 / J1+
                                        
                                        // UPDATE newDSP newRSP
                                        newDSP <= dsp + ddelta;
                                        newRSP <= rsp + rdelta;
                                        rstackWData <= stackTop;
                                        
                                        // r2pc - return from call or next instruction
                                        newPC <= ( instruction[12] ) ? rStackTop >> 1 : pcPlusOne;
                                        
                                        // n2memt mem[t] = n WRITE to SPRAM or UART/LED
                                        if( instruction[5] ) begin
                                            case( stackTop )  
                                                16'hf000: begin
                                                    // OUTPUT to UART via buffer
                                                    uartOutBuffer[uartOutBufferTop] <= stackNext[7:0];
                                                    newUartOutBufferTop <= uartOutBufferTop + 1;
                                                end 
                                                
                                                16'hf002: setRGB <= stackNext; // OUTPUT to rgbLED

                                                default: begin
                                                    // WRITE to SPRAM
                                                    sram_address <= stackTop >> 1;
                                                    sram_data_write <= stackNext;
                                                    sram_readwrite <= 1;
                                                end 
                                            endcase
                                        end
                                    end // ALU 
                                    
                                endcase // branch 0branch call alu
                            end // not is_lit
                        end  // J1 CPU Instruction execute
                        
                        9: begin
                            // Write to dstack and rstack
                            if( dstackWrite ) 
                                dstack[newDSP] <= stackTop;
                            if( rstackWrite ) 
                                rstack[newRSP] <= rstackWData;
                        end 
                        
                        10: begin
                            // Update dsp, rsp, pc, stackTop
                            dsp <= newDSP;
                            pc <= newPC;
                            stackTop <= newStackTop;
                            rsp <= newRSP;
                        end 
                        
                        
                        12: begin
                            // reset sram_readwrite
                            sram_readwrite <= 0; 
                        end
                        
                        default: begin
                        end 
                        
                    endcase
                end // MAIN J1 CPU LOOP
                
                default: begin
                end

            endcase // INIT

            // Reset UART Output
            if(uart_in_ready & uart_in_valid)
                uart_in_valid <= 0;
            
            // Move to next CYCLE ( 0 to 12 , then back to 0 )
            CYCLE = ( CYCLE == 12 ) ? 0 : CYCLE + 1;
                        
        
        end // NOT RESET
    end // MAIN LOOP
    
endmodule
