library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CombinationalCircuitTB is

end entity;

architecture sim of CombinationalCircuitTB is

    signal s_ABUS   : std_logic_vector(15 downto 0) := (others => '0');
    signal s_BBUS   : std_logic_vector(15 downto 0) := (others => '0');
    signal s_CTRL   : std_logic_vector(3 downto 0)  := (others => '0');
    signal s_Result : std_logic_vector(15 downto 0);

begin

    UUT: entity CombinationalCircuit
        port map (
            ABUS   => s_ABUS,
            BBUS   => s_BBUS,
            CTRL   => s_CTRL,
            Result => s_Result
        );

    stim_proc: process
    begin
        wait for 20 ns;
		
        s_ABUS <= x"AA55"; -- High byte AA, Low byte 55 (input to LUT)
        s_BBUS <= x"0000";
        s_CTRL <= "0101";  -- CTRL(3) is '0'
        wait for 20 ns;
        -- Result should be: x"AA" & (LUT output for x"55")

        -----------------------------------------------------------
        -- Test Case 2: Select tmp_out3 (Shifter path)
        -- Logic: CTRL(3) must be '1' AND CTRL(1 downto 0) must be "11"
        -----------------------------------------------------------
        report "Testing Shifter path (CTRL = 1x11)";
        s_ABUS <= x"1234";
        s_BBUS <= x"F0F0"; -- Input to Shifter
        s_CTRL <= "1011";  -- CTRL(3)='1' and CTRL(1:0)="11"
        wait for 20 ns;
        -- Result should be: Shifter output for s_BBUS

        -----------------------------------------------------------
        -- Test Case 3: Select tmp_out2 (ALU path)
        -- Logic: CTRL(3) must be '1' AND CTRL(1 downto 0) NOT "11"
        -----------------------------------------------------------
        report "Testing ALU path (CTRL = 1x00)";
        s_ABUS <= x"000A";
        s_BBUS <= x"0005";
        s_CTRL <= "1000";  -- CTRL(3)='1' but CTRL(1:0)="00"
        wait for 20 ns;
        -- Result should be: ALU output for s_ABUS and s_BBUS

        -----------------------------------------------------------
        -- Test Case 4: Edge Case (All Zeros)
        -----------------------------------------------------------
        s_ABUS <= (others => '0');
        s_BBUS <= (others => '0');
        s_CTRL <= "0000";
        wait for 20 ns;

        -- End simulation
        wait;
    end process;

end architecture;