-- $Id: $
-- File name:   sram_tb_TMDS_clk.vhd
-- Created:     11/21/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity sram_tb_TMDS_clk is
end sram_tb_TMDS_clk;

architecture TEST of sram_tb_TMDS_clk is

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

  component sram_TMDS_clk
    PORT(
         clock_me : in std_logic;
         rst_n : in std_logic;
         TMDS_CLK : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clock_me : std_logic;
  signal rst_n : std_logic;
  signal TMDS_CLK : std_logic;

-- signal <name> : <type>;

begin
  DUT: sram_TMDS_clk port map(
                clock_me => clock_me,
                rst_n => rst_n,
                TMDS_CLK => TMDS_CLK
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here
  rst_n <= '0';
wait for 2 ns;
rst_n <= '1';
wait for 2 ns;
    
for I in 0 to 1000 loop
     clock_me <= '0';
    wait for 10 ns;
    clock_me <= '1';
    wait for 10 ns;
    
  end loop;  -- I
   
   
  end process;
end TEST;
