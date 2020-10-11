library ieee;
context ieee.ieee_std_context;

use work.components.all;

entity Fomu_Blink is
  port (
    -- 48MHz Clock input
    clki: in std_logic;

    -- LED outputs
    rgb0: out std_logic;
    rgb1: out std_logic;
    rgb2: out std_logic;

    -- USB Pins (which should be statically driven if not being used)
    usb_dp: out std_logic;
    usb_dn: out std_logic;
    usb_dp_pu: out std_logic
  );
end;

architecture arch of Fomu_Blink is

  signal clk: std_logic;
  signal color: std_logic_vector(2 downto 0) := (others=>'0');

  component clkgen
    port (
      clk: in std_logic;
      cnt: out std_logic_vector(2 downto 0)
    );
  end component;

begin

  -- Assign USB pins to "0" so as to disconnect Fomu from
  -- the host system.  Otherwise it would try to talk to
  -- us over USB, which wouldn't work since we have no stack.
  usb_dp    <= '0';
  usb_dn    <= '0';
  usb_dp_pu <= '0';

  -- Instantiate clkgen for reducing the system clock
  clk_generator: component clkgen
  port map (
      clk => clki,
      cnt => color
  );

  -- Instantiate iCE40 LED driver hard logic, connecting up
  -- counter state and LEDs.
  --
  -- Note that it's possible to drive the LEDs directly,
  -- however that is not current-limited and results in
  -- overvolting the red LED.
  --
  -- See also:
  -- https://www.latticesemi.com/-/media/LatticeSemi/Documents/ApplicationNotes/IK/ICE40LEDDriverUsageGuide.ashx?document_id=50668
  rgba_driver: SB_RGBA_DRV
  generic map (
    CURRENT_MODE => "0b1",      -- half current
    RGB0_CURRENT => "0b000011", -- 4 mA
    RGB1_CURRENT => "0b000011", -- 4 mA
    RGB2_CURRENT => "0b000011"  -- 4 mA
  )
  port map (
    CURREN   => '1',
    RGBLEDEN => '1',
    RGB0PWM  => color(2),
    RGB1PWM  => color(1),
    RGB2PWM  => color(0),
    RGB0     => rgb0,
    RGB1     => rgb1,
    RGB2     => rgb2
  );

end;
