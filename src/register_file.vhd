library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port (
        clk : in std_logic;
        rst : in std_logic;
        RdWEn : in std_logic;
        Ra : in std_logic_vector(3 downto 0);
        Rb : in std_logic_vector(3 downto 0);
        Rd : in std_logic_vector(3 downto 0);
        Res : in std_logic_vector(15 downto 0);
        SRCa : out std_logic_vector(15 downto 0);
        SRCb : out std_logic_vector(15 downto 0)
    );
    end entity;

