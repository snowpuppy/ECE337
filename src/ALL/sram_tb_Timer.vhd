-- $Id: $
-- File name:   sram_tb_Timer.vhd
-- Created:     11/21/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity sram_tb_Timer is
end sram_tb_Timer;

architecture TEST of sram_tb_Timer is

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

  component sram_Timer
    PORT(
         tx_load : in std_logic;
         clock_me : in std_logic;
         sram_Timer_done : out std_logic;
         rst_n : in std_logic
    );
  end component;

-- Insert signals Declarations here
  signal tx_load : std_logic;
  signal clock_me : std_logic;
  signal sram_Timer_done : std_logic;
  signal rst_n : std_logic;

-- signal <name> : <type>;

begin
CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clock_me <= clk_tmp;
  wait for 5 ns ;
end process;




  
  DUT: sram_Timer port map(
                tx_load => tx_load,
                clock_me => clock_me,
                sram_Timer_done => sram_Timer_done,
                rst_n => rst_n
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    

    rst_n <= '0';
    wait for 10 ns;
    rst_n <= '1';
    tx_load <= '1';

    wait for 180 ns;

  end process;
end TEST;
