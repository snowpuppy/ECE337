-- $Id: $
-- File name:   sram_tb_row.vhd
-- Created:     11/10/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity sram_tb_row is
end sram_tb_row;

architecture TEST of sram_tb_row is

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

  component sram_row
    PORT(
         TMDS_CLK : in std_logic;
         one_sram_row : in std_logic;
         rst_n : in std_logic;
         sram_row_num : out std_logic_vector(9 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal TMDS_CLK : std_logic;
  signal one_sram_row : std_logic;
  signal rst_n : std_logic;
  signal sram_row_num : std_logic_vector(9 downto 0);

-- signal <name> : <type>;

begin
CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  TMDS_CLK <= clk_tmp;
  wait for 5 ns ;
end process;



  
  DUT: sram_row port map(
                TMDS_CLK => TMDS_CLK,
                one_sram_row => one_sram_row,
                rst_n => rst_n,
                sram_row_num => sram_row_num
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here
   rst_n <= '0';
    one_sram_row <= '0'; 
    wait for 10 ns;
    rst_n <= '1';

    for I  in 0 to 1000 loop
        one_sram_row <= '1';
    wait for 10 ns;
    one_sram_row <= '0';
    wait for 10 ns;
    
    end loop;  -- I 

    

  end process;
end TEST;
