LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU IS
    PORT (
        ABUS : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        BBUS : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALUsel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        ALUOUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ALU;

ARCHITECTURE Behavioral OF ALU IS
BEGIN
    PROCESS (ABUS, BBUS, ALUsel)
    BEGIN
        CASE ALUsel IS

            WHEN "0000" =>
                ALUOUT <= STD_LOGIC_VECTOR(unsigned(ABUS) + unsigned(BBUS));

            WHEN "0001" =>
                ALUOUT <= STD_LOGIC_VECTOR(unsigned(ABUS) - unsigned(BBUS));

            WHEN "0010" =>
                ALUOUT <= ABUS AND BBUS;

            WHEN "0011" =>
                ALUOUT <= ABUS OR BBUS;

            WHEN "0100" =>
                ALUOUT <= ABUS XOR BBUS;

            WHEN "0101" =>
                ALUOUT <= NOT ABUS;

            WHEN "0110" =>
                ALUOUT <= ABUS;

            WHEN "0111" =>
                ALUOUT <= (OTHERS => '0');

            WHEN OTHERS =>
                ALUOUT <= (OTHERS => '0');

        END CASE;
    END PROCESS;
END Behavioral;

