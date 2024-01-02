-------------------------------------------------------------------------------
-- Title      : MINIUART2 -- this is a modified version without Wishbone interface
-- Project    : MINIUART2
-------------------------------------------------------------------------------
-- File        : MiniUart.vhd
-- Author      : Philippe CARTON 
--               (philippe.carton2@libertysurf.fr)
-- Organization:
-- Created     : 15/12/2001
-- Last update : 8/1/2003
-- Platform    : Foundation 3.1i
-- Simulators  : ModelSim 5.5b
-- Synthesizers: Xilinx Synthesis
-- Targets     : Xilinx Spartan
-- Dependency  : IEEE std_logic_1164, Rxunit.vhd, Txunit.vhd, utils.vhd
-------------------------------------------------------------------------------
-- Description: Uart (Universal Asynchronous Receiver Transmitter) for SoC.
--    Wishbone compatable.
-------------------------------------------------------------------------------
-- Copyright (c) notice
--    This core adheres to the GNU public license 
--
-------------------------------------------------------------------------------
-- Revisions       :
-- Revision Number :
-- Version         :
-- Date    :
-- Modifier        : name <email>
-- Description     :
--
-------------------------------------------------------------------------------
-- Revision History:
--   2014-12-19: removed wishbone interface (uh@xlerb.de)


library ieee;
   use ieee.std_logic_1164.all;

entity MINIUART2 is
  generic(BRDIVISOR: INTEGER range 0 to 65535 := 143); -- Baud rate divisor  143 = 115200 at 66 Mhz
  port (
		clk:		in  STD_LOGIC;
		rst:        in  STD_LOGIC;
		rx:			in  STD_LOGIC;
		tx:			out STD_LOGIC;
		io_rd:		in  STD_LOGIC;
		io_wr:		in  STD_LOGIC;
		io_addr:	in  STD_LOGIC;
		io_din: 	in  STD_LOGIC_VECTOR (15 downto 0);
		io_dout:	out STD_LOGIC_VECTOR (15 downto 0));
end MINIUART2;

-- Architecture for UART for synthesis
architecture Behaviour of MINIUART2 is

  component Counter
  generic(COUNT: INTEGER range 0 to 65535); -- Count revolution
  port (
     Clk      : in  std_logic;  -- Clock
     Reset    : in  std_logic;  -- Reset input
     CE       : in  std_logic;  -- Chip Enable
     O        : out std_logic); -- Output  
  end component;

  component RxUnit
  port (
     Clk    : in  std_logic;  -- system clock signal
     Reset  : in  std_logic;  -- Reset input
     Enable : in  std_logic;  -- Enable input
     ReadA  : in  Std_logic;  -- Async Read Received Byte
     RxD    : in  std_logic;  -- RS-232 data input
     RxAv   : out std_logic;  -- Byte available
     DataO  : out std_logic_vector(7 downto 0)); -- Byte received
  end component;

  component TxUnit
  port (
     Clk    : in  std_logic;  -- Clock signal
     Reset  : in  std_logic;  -- Reset input
     Enable : in  std_logic;  -- Enable input
     LoadA  : in  std_logic;  -- Asynchronous Load
     TxD    : out std_logic;  -- RS-232 data output
     Busy   : out std_logic;  -- Tx Busy
     DataI  : in  std_logic_vector(7 downto 0)); -- Byte to transmit
  end component;

  signal RxData : std_logic_vector(7 downto 0); -- Last Byte received
  signal TxData : std_logic_vector(7 downto 0); -- Last bytes transmitted
  signal SReg   : std_logic_vector(7 downto 0); -- Status register
  signal EnabRx : std_logic;  -- Enable RX unit
  signal EnabTx : std_logic;  -- Enable TX unit
  signal RxAv   : std_logic;  -- Data Received
  signal TxBusy : std_logic;  -- Transmiter Busy
  signal ReadA  : std_logic;  -- Async Read receive buffer
  signal LoadA  : std_logic;  -- Async Load transmit buffer
  signal Sig0   : std_logic;  -- gnd signal
  signal Sig1   : std_logic;  -- vcc signal  

 
  begin
      sig0 <= '0';
      sig1 <= '1';
      Uart_Rxrate : Counter -- Baud Rate adjust
        generic map (COUNT => BRDIVISOR) 
        port map (clk, rst, sig1, EnabRx); 
      Uart_Txrate : Counter -- 4 Divider for Tx
        generic map (COUNT => 4)  
        port map (clk, rst, EnabRx, EnabTx);
     Uart_TxUnit : TxUnit port map (clk, rst, EnabTX, LoadA, tx, TxBusy, TxData);
     Uart_RxUnit : RxUnit port map (clk, rst, EnabRX, ReadA, rx, RxAv, RxData);
	 
	 -- status register
	 SReg(0) <= RxAv; 
	 SReg(1) <= TxBusy;
	 SReg(7 downto 2) <= (others => '0'); -- the rest is silence
  
     process (clk, rst, io_addr, io_wr, io_din)
	 begin
		 if Rising_Edge(clk) then
            if rst='1' then
			    LoadA <= '0';
		    elsif io_wr='1' and io_addr='0' then -- write byte to tx
			   TxData <= io_din(7 downto 0);
		       LoadA <= '1';
		    else
			   LoadA <= '0';	 
		    end if;
		end if;
	 end process;
  
     process (clk, rst, io_addr, io_rd, RxData, TxBusy, RxAv)
       begin
		   if Rising_Edge(clk) then
			   if rst='1' then
				   ReadA <= '0';
			   elsif io_rd='1' and io_addr='0' then
				   ReadA <= '1';
			   else
				   ReadA <= '0';
			   end if;
		   end if;
      end process;
      io_dout(7 downto 0) <= RxData when io_addr='0' else SReg;
	  io_dout(15 downto 8) <= (others => '0');
 
end Behaviour;
