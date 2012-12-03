-- $Id: $
-- File name:   tb_data_select.vhd
-- Created:     11/26/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_data_select is
end tb_data_select;

architecture TEST of tb_data_select is

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

  component data_select
    PORT(
         data : in std_logic_vector(31 downto 0);
         data_sel_w : in std_logic;
         clk : in std_logic;
         rst_n : in std_logic;
         SRAM1_data : out std_logic_vector(31 downto 0);
         SRAM2_data : out std_logic_vector(31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal data : std_logic_vector(31 downto 0);
  signal data_sel_w : std_logic;
  signal clk : std_logic;
  signal rst_n : std_logic;
  signal SRAM1_data : std_logic_vector(31 downto 0);
  signal SRAM2_data : std_logic_vector(31 downto 0);

-- signal <name> : <type>;

begin
CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for 5 ns ;
end process;



  
  DUT: data_select port map(
                data => data,
                data_sel_w => data_sel_w,
                clk => clk,
                rst_n => rst_n,
                SRAM1_data => SRAM1_data,
                SRAM2_data => SRAM2_data
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    data <= "00000000000000000000000000000000";
    data_sel_w <= '0';
    rst_n <='0';

    wait for 10 ns;

    rst_n <= '1';
    data <= "11111111111111111111111111111111";
    wait for 10  ns;

    data_sel_w <= '1';
    
    wait for 10 ns;
    data_sel_w <= '0';
    
    wait for 10 ns;
    
  end process;
end TEST;
