-- $Id: $
-- File name:   sram_tb_encoder_one.vhd
-- Created:     11/22/2012
-- Author:      Xiao Zuguang
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity sram_tb_encoder_one is
      generic (Period: Time:= 10 ns);
end sram_tb_encoder_one;

architecture TEST of sram_tb_encoder_one is

  function UINT_TO_STDV( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector(to_unsigned(X, NumBits));
  end;

  function STDV_TO_UINT( X: std_logic_vector)
     return integer is
  begin
    return to_integer(unsigned(x));
  end;

  component sram_encoder_one
    PORT(
         clk : in std_logic;
         encode_en : in std_logic;
         rst_n : in std_logic;
         d : in std_logic_vector(7 downto 0);
         q_o : out std_logic_vector(9 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal encode_en : std_logic;
  signal rst_n : std_logic;
  signal d : std_logic_vector(7 downto 0);
  signal q_o : std_logic_vector(9 downto 0);

-- signal <name> : <type>;

begin
  DUT: sram_encoder_one port map(
                clk => clk,
                encode_en => encode_en,
                rst_n => rst_n,
                d => d,
                q_o => q_o
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);
  CLKGEN:process
  variable clk_tmp: std_logic := '0';
  begin
    clk_tmp := not clk_tmp;
    CLK <= clk_tmp;
    wait for Period/2;
  end process;
process

  begin

-- Insert TEST BENCH Code Here
rst_n <= '1';
encode_en <= '0';
d <= "00000010";
wait for 50 ns;
rst_n <= '1';
d<= "10000000";
    encode_en <= '0';
    wait for 50 ns;
    encode_en <= '1';
    d <= "01010100";
    wait for 100 ns;
    d <= "11110001";
    wait for 100 ns;
    d <= "10100011";

  end process;
end TEST;
