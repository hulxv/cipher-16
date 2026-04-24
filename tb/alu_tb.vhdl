LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY alu_tb IS
END alu_tb;

ARCHITECTURE test OF alu_tb IS

    CONSTANT VECTOR_STEP : TIME := 10 ns;

    SIGNAL ABUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL BBUS : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ALUOUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ALUsel : STD_LOGIC_VECTOR(3 DOWNTO 0);

    PROCEDURE check_case (
        SIGNAL sel_sig : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        SIGNAL a_sig : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        SIGNAL b_sig : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        SIGNAL out_sig : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        CONSTANT sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        CONSTANT a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        CONSTANT b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        CONSTANT expected : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        CONSTANT name : IN STRING
    ) IS
    BEGIN
        sel_sig <= sel;
        a_sig <= a;
        b_sig <= b;
        WAIT FOR VECTOR_STEP;

        ASSERT out_sig = expected
        REPORT "FAIL " & name
            SEVERITY error;
    END PROCEDURE;

BEGIN

    uut : ENTITY work.ALU
        PORT MAP(
            ABUS => ABUS,
            BBUS => BBUS,
            ALUOUT => ALUOUT,
            ALUsel => ALUsel
        );

    PROCESS
        VARIABLE a_u : unsigned(15 DOWNTO 0);
        VARIABLE b_u : unsigned(15 DOWNTO 0);
    BEGIN

        -- Clean initialization to avoid U/X at time 0 in waveforms
        ALUsel <= (OTHERS => '0');
        ABUS <= (OTHERS => '0');
        BBUS <= (OTHERS => '0');
        WAIT FOR VECTOR_STEP;

        -- Directed tests for each opcode
        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0000", x"0005", x"0003", x"0008", "ADD: 5 + 3");
        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0000", x"FFFF", x"0001", x"0000", "ADD wrap-around");
        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0000", x"8000", x"8000", x"0000", "ADD high-bit overflow");

        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0001", x"000A", x"0003", x"0007", "SUB: 10 - 3");
        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0001", x"0000", x"0001", x"FFFF", "SUB underflow");
        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0001", x"1234", x"1234", x"0000", "SUB equal operands");

        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0010", x"F0F0", x"0FF0", x"00F0", "AND mixed pattern");
        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0011", x"F0F0", x"0FF0", x"FFF0", "OR mixed pattern");
        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0100", x"AAAA", x"0F0F", x"A5A5", "XOR mixed pattern");

        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0101", x"0005", x"0000", x"FFFA", "NOT low value");
        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0101", x"FFFF", x"0000", x"0000", "NOT all ones");

        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0110", x"0009", x"DEAD", x"0009", "MOV low value");
        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0110", x"ABCD", x"0000", x"ABCD", "MOV high pattern");

        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0111", x"0009", x"1234", x"0000", "NOP with data");
        check_case(ALUsel, ABUS, BBUS, ALUOUT, "0111", x"FFFF", x"FFFF", x"0000", "NOP all ones");

        check_case(ALUsel, ABUS, BBUS, ALUOUT, "1000", x"1357", x"2468", x"0000", "OTHERS opcode 1000");
        check_case(ALUsel, ABUS, BBUS, ALUOUT, "1111", x"ABCD", x"EF01", x"0000", "OTHERS opcode 1111");

        -- Small arithmetic sweep for stronger coverage
        FOR i IN 0 TO 31 LOOP
            a_u := to_unsigned(i * 977, 16);
            b_u := to_unsigned(i * 613 + 7, 16);

            check_case(
            ALUsel,
            ABUS,
            BBUS,
            ALUOUT,
            "0000",
            STD_LOGIC_VECTOR(a_u),
            STD_LOGIC_VECTOR(b_u),
            STD_LOGIC_VECTOR(a_u + b_u),
            "ADD sweep index " & INTEGER'image(i)
            );

            check_case(
            ALUsel,
            ABUS,
            BBUS,
            ALUOUT,
            "0001",
            STD_LOGIC_VECTOR(a_u),
            STD_LOGIC_VECTOR(b_u),
            STD_LOGIC_VECTOR(a_u - b_u),
            "SUB sweep index " & INTEGER'image(i)
            );
        END LOOP;

        ASSERT FALSE REPORT "ALU TB PASSED" SEVERITY note;
        WAIT;
    END PROCESS;

END test;