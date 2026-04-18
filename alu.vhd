library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    port (
        ABUS    : in  std_logic_vector(15 downto 0);
        BBUS    : in  std_logic_vector(15 downto 0);
        ALUsel  : in  std_logic_vector(3 downto 0);  
        ALUOUT  : out std_logic_vector(15 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
begin

    process(ABUS, BBUS, ALUsel)
begin
    case ALUsel is

        when "0000" =>
            ALUOUT <= std_logic_vector(unsigned(ABUS) + unsigned(BBUS));

        when "0001" =>
            ALUOUT <= std_logic_vector(unsigned(ABUS) - unsigned(BBUS));

        when "0010" =>
            ALUOUT <= ABUS and BBUS;

        when "0011" =>
            ALUOUT <= ABUS or BBUS;

        when "0100" =>
            ALUOUT <= ABUS xor BBUS;

        when "0101" =>
            ALUOUT <= not ABUS;

        when "0110" =>  -- MOV
            ALUOUT <= ABUS;

        when "0111" =>  -- NOP
            ALUOUT <= (others => '0');

        when others =>
            ALUOUT <= (others => '0');

    end case;
end process;
end Behavioral;