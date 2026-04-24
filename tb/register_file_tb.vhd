library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_register_file is
end entity;

architecture test of tb_register_file is
  signal clk        : std_logic                     := '0';
  signal rst        : std_logic                     := '0';
  signal RdWEn      : std_logic                     := '0';
  signal Ra, Rb, Rd : std_logic_vector(3 downto 0)  := (others => '0');
  signal Res        : std_logic_vector(15 downto 0) := (others => '0');
  signal SRCa, SRCb : std_logic_vector(15 downto 0);

  constant clk_period : time := 10 ns;
  constant sim_period : time := 200 ns;

  signal sim_done : boolean := false;

begin
  UUT : entity work.register_file
    port map
    (
      clk   => clk,
      rst   => rst,
      RdWEn => RdWEn,
      Ra    => Ra,
      Rb    => Rb,
      Rd    => Rd,
      Res   => Res,
      SRCa  => SRCa,
      SRCb  => SRCb
    );

  clk_process : process
  begin
    while not sim_done loop
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
    end loop;
  end process;
  sim_proc : process
  begin
    rst <= '1';
    wait for clk_period;
    rst <= '0';
    wait for clk_period;

    Ra <= "0100";
    Rb <= "1011";

    wait for 2 ns;
    assert(SRCa = x"0000" and SRCb = x"0000")
    report"Error" severity error;

    RdWEn <= '1';
    Rd    <= "1011";
    Res   <= x"AAAA";
    wait for clk_period;
    RdWEn <= '0';
    Rd    <= "0001";
    Res   <= x"A111";
    wait for clk_period;

    Ra <= "1011";
    Rb <= "0001";
    wait for 2 ns;
    assert(SRCa = x"AAAA" and SRCb = x"0000")
    report"Error" severity error;
    rst <= '1';
    wait for clk_period;

    rst <= '0';
    wait for clk_period;

    assert(SRCa = x"0000")
    report"Error" severity error;
    sim_done <= true;
    wait;
  end process;
end architecture;