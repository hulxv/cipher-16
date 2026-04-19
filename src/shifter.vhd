library	ieee;
use ieee.std_logic_1164.all;

entity shifter is
	port (
		B_BUS: in std_logic_vector(15 downto 0);
		CTRL: in std_logic_vector(3 downto 0);
		SHIFT_OUT: out std_logic_vector(15 downto 0)
		);
		
end entity;

architecture rtl of shifter is
begin
	with CTRL select SHIFT_OUT <=
	B_BUS(7 downto 0) & B_BUS(15 downto 8) when "1000",
	B_BUS(3 downto 0) & B_BUS(15 downto 4) when "1001",
	B_BUS(7 downto 0) & x"00" when "1010",
	x"0000" when others;
end architecture;
