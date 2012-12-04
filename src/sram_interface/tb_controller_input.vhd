-- $Id: $
-- File name:   tb_controller_input.vhd
-- Created:     11/27/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_controller_input is
end tb_controller_input;

architecture TEST of tb_controller_input is

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

  component controller_input
    PORT(
         clk : in std_logic;
         rst_n : in std_logic;
         data_ready : in std_logic;
         sram_sel : in std_logic;
         pixel_done : out std_logic;
         data_load : out std_logic;
         ad_load : out std_logic;
         ad_sel_w : out std_logic;
         data_sel_w : out std_logic;
         WE : out std_logic_vector(1 downto 0);
         CS : out std_logic_vector(7 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst_n : std_logic;
  signal data_ready : std_logic;
  signal sram_sel : std_logic;
  signal pixel_done : std_logic;
  signal data_load : std_logic;
  signal ad_load : std_logic;
  signal ad_sel_w : std_logic;
  signal data_sel_w : std_logic;
  signal WE : std_logic_vector(1 downto 0);
  signal CS : std_logic_vector(7 downto 0);

-- signal <name> : <type>;

begin
  
CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for 5 ns ;
end process;


  

  
  DUT: controller_input port map(
                clk => clk,
                rst_n => rst_n,
                data_ready => data_ready,
                sram_sel => sram_sel,
                pixel_done => pixel_done,
                data_load => data_load,
                ad_load => ad_load,
                ad_sel_w => ad_sel_w,
                data_sel_w => data_sel_w,
                WE => WE,
                CS => CS
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

  
-- 1. rst
    rst_n <= '0';

    data_ready <= '0'; 

    sram_sel <= '0';
    wait for 10 ns;
    rst_n <= '1';
--  2.write sram 1, read sram 2
    data_ready <= '1';

    wait for 10 ns;
     data_ready <= '0';
    wait for 10 ns;
    wait for 10 ns;
    wait for 10 ns;

-- 3. write sram 2, read sram 1
    sram_sel <= '1';
    wait for 10 ns;
    wait for 10 ns;
    wait for 10 ns;
    wait for 10 ns;

-- 4. rst and do 2, 3 in reverse
    rst_n <= '0';
    wait for 10 ns;
    rst_n <= '1';
    wait for 10 ns;

        sram_sel <= '1';
        data_ready <= '1';
    wait for 10 ns;
     data_ready <= '0';
    wait for 10 ns;
    wait for 10 ns;
    wait for 10 ns;

    sram_sel <= '0';
    data_ready <= '1';
    wait for 10 ns;
    data_ready <= '0';
    wait for 10 ns;
    wait for 10 ns;
    wait for 10 ns;
    


    
    
    

  end process;
end TEST;
