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

end components;
