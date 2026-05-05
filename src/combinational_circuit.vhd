library	ieee;
use ieee.std_logic_1164.all;

entity combinational_circuit is 
	port(
	ABUS, BBUS : in std_logic_vector(15 downto 0);
	CTRL : in std_logic_vector(3 downto 0);
	Result : out std_logic_vector(15 downto 0)
	);
end entity;

architecture rtl of combinational_circuit is 
signal tmp_out1,tmp_out2,tmp_out3: std_logic_vector(15 downto 0);
signal lut_out: std_logic_vector(7 downto 0);
begin
	
	-- Non-linear Lookup Operation Unit--
	Non_LUT :entity work.non_linear_lookup 
	port map( LUTIN => ABUS(7 downto 0) , LUTOUT => lut_out);  
	tmp_out1 <= ABUS(15 downto 8) & lut_out;	 
	
	-- ALU Unit--
	ALU : entity work.alu
	port map ( ABUS =>  ABUS , BBUS => BBUS , ALUsel => CTRL , ALUOUT => tmp_out2);
	
	-- Shifter Unit--
	Shifter : entity work.shifter
	port map(B_BUS => BBUS , CTRL => CTRL , SHIFT_OUT => tmp_out3);
	
	-- Control Logic Unit--
	control_logic: process(CTRL,tmp_out1,tmp_out3,tmp_out2) 
	begin
		case(CTRL(3 downto 3)) is
		when "0" => 
    		RESULT <= tmp_out1;	  -- Triggered whenever the most significant bit CTRL(3) is '0'
		when others => 	
			case(CTRL(1 downto 0)) is
			when "11" =>
     			RESULT <= tmp_out3;	  --Triggered when CTRL(3) is '1' AND the last two bits are "11"
    		when others =>	
			RESULT <= tmp_out2;		  --Triggered for everything else where CTRL(3) is '1'
     	end case;
  	end case;
 end process control_logic;
end architecture; 
	
	
	
	