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
  signal counter: unsigned(27 downto 0) := (others=>'0');

begin

  -- Assign USB pins to "0" so as to disconnect Fomu from
  -- the host system.  Otherwise it would try to talk to
  -- us over USB, which wouldn't work since we have no stack.
  usb_dp    <= '0';
  usb_dn    <= '0';
  usb_dp_pu <= '0';

  -- Connect to system clock (with buffering)
  clk_gb: SB_GB
  port map (
    USER_SIGNAL_TO_GLOBAL_BUFFER => clki,
    GLOBAL_BUFFER_OUTPUT => clk
  );

  -- Use counter logic to divide system clock.  The clock is 48 MHz,
  -- so we divide it down by 2^28.
  process(clk)
  begin
    if rising_edge(clk) then
      counter <= counter + 1;
    end if;
  end process;

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
    RGB0PWM  => counter(counter'left),
    RGB1PWM  => counter(counter'left-1),
    RGB2PWM  => counter(counter'left-2),
    RGB0     => rgb0,
    RGB1     => rgb1,
    RGB2     => rgb2
  );

end;
