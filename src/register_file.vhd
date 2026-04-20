library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
  port (
    clk   : in std_logic;
    rst   : in std_logic;
    RdWEn : in std_logic;
    Ra    : in std_logic_vector(3 downto 0);
    Rb    : in std_logic_vector(3 downto 0);
    Rd    : in std_logic_vector(3 downto 0);
    Res   : in std_logic_vector(15 downto 0);
    SRCa  : out std_logic_vector(15 downto 0);
    SRCb  : out std_logic_vector(15 downto 0)
  );
end entity;

architecture behave of register_file is
  type reg_array is array(0 to 15) of std_logic_vector(15 downto 0);
  signal registers : reg_array := (others => (others => '0'));

begin
  process (clk, rst)
  begin
    if rst = '1' then
      registers <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if RdWEn = '1' then
        registers(to_integer(unsigned(Rd))) <= RES;
      end if;
    end if;
  end process;

  SRCa <= registers(to_integer(unsigned(Ra)));
  SRCb <= registers(to_integer(unsigned(Rb)));
end behave;