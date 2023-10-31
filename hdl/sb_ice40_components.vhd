library ieee ;
use ieee.std_logic_1164.all;

package components is

component SB_GB
  port(
    GLOBAL_BUFFER_OUTPUT         : out std_logic;
    USER_SIGNAL_TO_GLOBAL_BUFFER : in  std_logic
  );
end component;

component  SB_RGBA_DRV
  generic (
    CURRENT_MODE : string := "0b0";
    RGB0_CURRENT : string := "0b000000";
    RGB1_CURRENT : string := "0b000000";
    RGB2_CURRENT : string := "0b000000"
  );
  port (
    RGB0PWM  : in  std_logic;
    RGB1PWM  : in  std_logic;
    RGB2PWM  : in  std_logic;
    CURREN   : in  std_logic;
    RGBLEDEN : in  std_logic;
    RGB0     : out std_logic;
    RGB1     : out std_logic;
    RGB2     : out std_logic
  );
end component;

-- SB_MAC16 DSP. Default values according to datasheet
component SB_MAC16
	generic (
	NEG_TRIGGER : integer := 0;

	A_REG : integer := 0;
	B_REG : integer := 0;
	C_REG : integer := 0;
	D_REG : integer := 0;

	TOP_8x8_MULT_REG : integer := 0;
	BOT_8x8_MULT_REG : integer := 0;
	PIPELINE_16x16_MULT_REG1 : integer := 0;
	PIPELINE_16x16_MULT_REG2 : integer := 0;

	TOPOUTPUT_SELECT : integer := 0;
	TOPADDSUB_LOWERINPUT : integer := 0;
	TOPADDSUB_UPPERINPUT : integer:= 0;
	TOPADDSUB_CARRYSELECT : integer := 0;
	BOTOUTPUT_SELECT : integer := 0;
	BOTADDSUB_LOWERINPUT : integer := 0;
	BOTADDSUB_UPPERINPUT : integer := 0;
	BOTADDSUB_CARRYSELECT : integer := 0;
	MODE_8x8 : integer := 0;
	A_SIGNED : integer := 0;
	B_SIGNED : integer := 0
		);
	port (
	CLK: in std_logic;
	CE: in std_logic := '1';

	A: in std_logic_vector(15 downto 0) := (others => '0');
	B: in std_logic_vector(15 downto 0) := (others => '0');
	C: in std_logic_vector(15 downto 0) := (others => '0');
	D: in std_logic_vector(15 downto 0) := (others => '0');

	AHOLD : in std_logic := '0';
	BHOLD : in std_logic := '0';
	CHOLD : in std_logic := '0';
	DHOLD : in std_logic := '0';

	IRSTTOP : in std_logic := '0';
	ORSTTOP : in std_logic := '0';

	OLOADTOP : in std_logic := '0';
	ADDSUBTOP : in std_logic := '0';
	OHOLDTOP : in std_logic := '0';
	IRSTBOT : in std_logic := '0';
	ORSTBOT : in std_logic := '0';
	OLOADBOT : in std_logic := '0';
	ADDSUBBOT : in std_logic := '0';
	OHOLDBOT : in std_logic := '0';

	O: out std_logic_vector(31 downto 0);
	CI : in std_logic := '0';
	CO : out std_logic

);
end component;

end components;
