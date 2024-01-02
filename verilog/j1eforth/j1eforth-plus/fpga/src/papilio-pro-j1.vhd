library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity papilio_pro_j1 is
	port (
		clk_in:	in		std_logic;
		rx:		in		std_logic;
		tx:		out	std_logic;
		wing:		out	std_logic_vector(15 downto 0));
end papilio_pro_j1;

architecture Behavioral of papilio_pro_j1 is

	component clock is
   port (
		clk_in:				in  std_logic;
		clk:					out std_logic;
		clk180:				out std_logic);
	end component;

	component j1 is
	port (
		sys_clk_i:			in  std_logic;
		sys_rst_i:			in  std_logic;
		io_rd:				out std_logic;
		io_wr:				out std_logic;
		io_addr:				out std_logic_vector (15 downto 0);
		io_din:				in  std_logic_vector (15 downto 0);
		io_dout:				out std_logic_vector (15 downto 0));
	end component;
	
	component miniuart2 is
	port (
		clk:		in  STD_LOGIC;
		rst:        in  STD_LOGIC;
		rx:		    in  STD_LOGIC;
		tx:		    out STD_LOGIC;
		io_rd:	    in  STD_LOGIC;
		io_wr:	    in  STD_LOGIC;
		io_addr:	in  STD_LOGIC;
		io_din: 	in  STD_LOGIC_VECTOR (15 downto 0);
		io_dout:	out STD_LOGIC_VECTOR (15 downto 0));
	end component;

	
	signal clk:			std_logic;
	signal clk180:		std_logic;
	
	signal rst_counter:	integer range 0 to 15 := 15;
	signal sys_rst:		std_logic := '1';
	
	signal io_rd:		std_logic;
	signal io_wr:		std_logic;
	signal io_addr:		std_logic_vector (15 downto 0);
	signal io_din:		std_logic_vector (15 downto 0);
	signal io_dout:		std_logic_vector (15 downto 0);

	signal uart_en:		std_logic;
	signal uart_rd:		std_logic;
	signal uart_wr:		std_logic;
	signal uart_dout:	std_logic_vector (15 downto 0);
begin

	clock_inst: clock
	port map (
		clk_in		=> clk_in,
		clk			=> clk,
		clk180		=> clk180);

	j1_inst: j1
	port map (
		sys_clk_i	=> clk,
		sys_rst_i	=> sys_rst,
		io_rd			=> io_rd,
		io_wr			=> io_wr,
		io_addr		=> io_addr,
		io_din		=> io_din,
		io_dout		=> io_dout);
		
	uart_inst: miniuart2
	port map(
		clk		=> clk180,
		rst     => sys_rst,
		rx		=> rx,
		tx		=> tx,
		io_rd	=> uart_rd,
		io_wr	=> uart_wr,
		io_addr	=> io_addr(0),
		io_din	=> io_dout,
		io_dout	=> uart_dout);
					
	process (clk, rst_counter)
	begin
		if rising_edge(clk) and rst_counter>0 then
			rst_counter <= rst_counter-1;
		end if;
	end process;
	sys_rst <= '1' when rst_counter>0 else '0';
	
	uart_en <= '1' when io_addr(15 downto 1)="111100000000000" else '0';
	uart_rd <= io_rd and uart_en;
	uart_wr <= io_wr and uart_en;
	
	process (io_addr, uart_dout)
	begin
		case io_addr(15 downto 1) is
		when "111100000000000" =>
			io_din <= uart_dout;
		when others =>
			io_din <= (others=>'0');
		end case;
	end process;
	
	wing <= (others=>'0');
	
end Behavioral;