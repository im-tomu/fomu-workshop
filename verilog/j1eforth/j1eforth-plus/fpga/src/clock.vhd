library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity clock is
   port ( clk_in :	in    std_logic;
          clk :		out   std_logic;
          clk180 :	out   std_logic);
end clock;

architecture BEHAVIORAL of clock is

   signal CLKFB_IN        : std_logic;
   signal CLKFX_BUF       : std_logic;
   signal CLKFX180_BUF    : std_logic;
   signal CLKIN_IBUFG     : std_logic;
   signal CLK2X_BUF       : std_logic;

begin

   CLKFX_BUFG_INST : BUFG
      port map (I=>CLKFX_BUF,
                O=>clk);
   
   CLKFX180_BUFG_INST : BUFG
      port map (I=>CLKFX180_BUF,
                O=>clk180);
   
   CLKIN_IBUFG_INST : IBUFG
      port map (I=>clk_in,
                O=>CLKIN_IBUFG);
   
   CLK2X_BUFG_INST : BUFG
      port map (I=>CLK2X_BUF,
                O=>CLKFB_IN);
   
   DCM_SP_INST : DCM_SP
   generic map(
		CLK_FEEDBACK			=> "2X",
		CLKDV_DIVIDE			=> 4.0,
		CLKFX_DIVIDE			=> 1,
		CLKFX_MULTIPLY			=> 2,
		CLKIN_DIVIDE_BY_2		=> FALSE,
		CLKIN_PERIOD			=> 31.250,
		CLKOUT_PHASE_SHIFT	=> "NONE",
		DESKEW_ADJUST			=> "SYSTEM_SYNCHRONOUS",
		DFS_FREQUENCY_MODE	=> "LOW",
		DLL_FREQUENCY_MODE	=> "LOW",
		DUTY_CYCLE_CORRECTION=> TRUE,
		FACTORY_JF				=> x"C080",
		PHASE_SHIFT				=> 0,
		STARTUP_WAIT			=> TRUE)
	port map (
		CLKIN		=>	CLKIN_IBUFG,
		CLKFB		=>	CLKFB_IN,
		DSSEN		=>	'0',
		PSCLK		=>	'0',
		PSEN		=>	'0',
		PSINCDEC	=>	'0',
		RST		=>	'0',
		CLKDV		=>	open,
		CLKFX		=>	CLKFX_BUF,
		CLKFX180	=>	CLKFX180_BUF,
		CLK2X		=>	CLK2X_BUF,
		CLK2X180	=>	open,
		CLK0		=>	open,
		CLK90		=>	open,
		CLK180	=>	open,
		CLK270	=>	open,
		LOCKED	=>	open,
		PSDONE	=>	open,
		STATUS	=>	open);
   
end BEHAVIORAL;


