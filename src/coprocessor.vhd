library ieee;
use ieee.std_logic_1164.all;

entity coprocessor is
  port (
    clock  : in  std_logic;
    reset  : in  std_logic;
    CTRL   : in  std_logic_vector(3 downto 0);
    Ra     : in  std_logic_vector(3 downto 0);
    Rb     : in  std_logic_vector(3 downto 0);
    Rd     : in  std_logic_vector(3 downto 0);
    RESULT : out std_logic_vector(15 downto 0)
  );
end coprocessor;

architecture rtl of coprocessor is
  signal Ra_reg   : std_logic_vector(3 downto 0);
  signal Rb_reg   : std_logic_vector(3 downto 0);
  signal Rd_reg   : std_logic_vector(3 downto 0);
  signal CTRL_reg : std_logic_vector(3 downto 0);
  signal A_BUS    : std_logic_vector(15 downto 0);
  signal B_BUS    : std_logic_vector(15 downto 0);
  signal result_s : std_logic_vector(15 downto 0);
begin

  RESULT <= result_s;

  -- Clocked input register with asynchronous reset
  input_reg: process(clock, reset)
  begin
    if reset = '1' then
      Ra_reg   <= (others => '0');
      Rb_reg   <= (others => '0');
      Rd_reg   <= (others => '0');
      CTRL_reg <= (others => '0');
    elsif rising_edge(clock) then
      Ra_reg   <= Ra;
      Rb_reg   <= Rb;
      Rd_reg   <= Rd;
      CTRL_reg <= CTRL;
    end if;
  end process;

  -- 16x16 register file: combinational reads, synchronous write of result to Rd
  reg_file: entity work.register_file
    port map(
      clk   => clock,
      rst   => reset,
      RdWEn => '1',
      Ra    => Ra_reg,
      Rb    => Rb_reg,
      Rd    => Rd_reg,
      Res   => result_s,
      SRCa  => A_BUS,
      SRCb  => B_BUS
    );

  -- Combinational logic: A_BUS/B_BUS → LUT / ALU / Shifter selected by CTRL_reg
  comb_logic: entity work.combinational_circuit
    port map(
      ABUS   => A_BUS,
      BBUS   => B_BUS,
      CTRL   => CTRL_reg,
      Result => result_s
    );

end architecture;
