-- $Id: $
-- File name:   tb_Clock_divider.vhd
-- Created:     11/21/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_Clock_divider is
end tb_Clock_divider;

architecture TEST of tb_Clock_divider is

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

  component Clock_divider
    PORT(
         clk : in std_logic;
         rst_n : in std_logic;
         clock_me : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst_n : std_logic;
  signal clock_me : std_logic;

-- signal <name> : <type>;

begin
  DUT: Clock_divider port map(
                clk => clk,
                rst_n => rst_n,
                clock_me => clock_me
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
     clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    
  end loop;  -- I
   
   

  end process;
end TEST;
