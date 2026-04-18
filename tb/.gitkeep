library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_tb is
end alu_tb;

architecture test of alu_tb is

    signal ABUS    : std_logic_vector(15 downto 0);
    signal BBUS    : std_logic_vector(15 downto 0);
    signal ALUOUT  : std_logic_vector(15 downto 0);
    signal ALUsel : std_logic_vector(3 downto 0);

begin

    uut: entity work.ALU
        port map (
            ABUS => ABUS,
            BBUS => BBUS,
            ALUOUT => ALUOUT,
            ALUsel => ALUsel
        );

    process
begin

    -- ADD
    ALUsel <= "0000";
    ABUS <= x"0005";
    BBUS <= x"0003";
    wait for 10 ns;

    -- SUB
    ALUsel <= "0001";
    ABUS <= x"000A";
    BBUS <= x"0003";
    wait for 10 ns;

    -- AND
    ALUsel <= "0010";
    ABUS <= x"0005";
    BBUS <= x"0003";
    wait for 10 ns;

    -- OR
    ALUsel <= "0011";
    ABUS <= x"0005";
    BBUS <= x"0003";
    wait for 10 ns;

    -- XOR
    ALUsel <= "0100";
    ABUS <= x"0005";
    BBUS <= x"0003";
    wait for 10 ns;

    -- NOT
    ALUsel <= "0101";
    ABUS <= x"0005";
    wait for 10 ns;

    -- MOV
    ALUsel <= "0110";
    ABUS <= x"0009";
    wait for 10 ns;

    -- NOP
    ALUsel <= "0111";
    ABUS <= x"0009";
    wait for 10 ns;

    wait;
end process;

end test;
