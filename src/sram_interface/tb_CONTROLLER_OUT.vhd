-- $Id: $
-- File name:   tb_CONTROLLER_OUT.vhd
-- Created:     11/30/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_CONTROLLER_OUT is
end tb_CONTROLLER_OUT;

architecture TEST of tb_CONTROLLER_OUT is

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

  component CONTROLLER_OUT
    PORT(
         rst_n : in std_logic;
         clk : in std_logic;
         ad_sel_w : in std_logic;
         need_input : in std_logic;
         done : in std_logic;
         sram_sel : out std_logic;
         out_en : out std_logic;
         write_done : out std_logic;
         data_ready : out std_logic;
         OE_ONE : out std_logic;
         OE_TWO : out std_logic;
         update : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal rst_n : std_logic;
  signal clk : std_logic;
  signal ad_sel_w : std_logic;
  signal need_input : std_logic;
  signal done : std_logic;
  signal sram_sel : std_logic;
  signal out_en : std_logic;
  signal write_done : std_logic;
  signal data_ready : std_logic;
  signal OE_ONE : std_logic;
  signal OE_TWO : std_logic;
  signal update : std_logic;

-- signal <name> : <type>;

begin
   
CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for 5 ns ;
end process;





  
  DUT: CONTROLLER_OUT port map(
                rst_n => rst_n,
                clk => clk,
                ad_sel_w => ad_sel_w,
                need_input => need_input,
                done => done,
                sram_sel => sram_sel,
                out_en => out_en,
                write_done => write_done,
                data_ready => data_ready,
                OE_ONE => OE_ONE,
                OE_TWO => OE_TWO,
                update => update
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    -- 1. rst;
       rst_n <= '0';   
       ad_sel_w <='0' ;
       need_input <= '0';
       done <= '0';
       wait for 10 ns;
    -- 2. go through all state
       rst_n <= '1';
       need_input <= '1';
       wait for 10 ns;
       need_input <='0';

       wait for 70 ns;

  end process;
end TEST;
