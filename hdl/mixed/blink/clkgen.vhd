library ieee;
context ieee.ieee_std_context;

use work.components.all;

entity clkgen is
  port (
    clk : in  std_logic;
    cnt : out std_logic_vector(2 downto 0)
  );
end;

architecture arch of clkgen is

  signal clko: std_logic;
  signal counter: unsigned(27 downto 0) := (others=>'0');

begin

  -- Connect to system clock (with buffering)
  clk_gb: SB_GB
  port map (
    USER_SIGNAL_TO_GLOBAL_BUFFER => clk,
    GLOBAL_BUFFER_OUTPUT => clko
  );

  -- Use counter logic to divide system clock.  The clock is 48 MHz,
  -- so we divide it down by 2^28.
  process(clko)
  begin
    if rising_edge(clko) then
      counter <= counter + 1;
    end if;
  end process;

  cnt <= std_logic_vector(counter(counter'left downto counter'left-cnt'length+1));

end;
