library	ieee;
use ieee.std_logic_1164.all;

entity shifterTB is
end entity;

architecture sim of shifterTB is
signal input, output: std_logic_vector(15 downto 0);
signal ctrl: std_logic_vector(3 downto 0);

begin
	DUT: entity shifter
		port map(B_BUS => input, SHIFT_OUT => output, CTRL => ctrl);
		
		process is
		begin			   
			input <= x"1011";
			ctrl <= "1000";
			wait for 10 ns;
			
			ctrl <= "1001";
			wait for 10 ns;
			
			ctrl <= "1010";
			wait for 10 ns;
		end process;
end architecture;
	