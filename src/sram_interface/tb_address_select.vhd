-- $Id: $
-- File name:   tb_address_select.vhd
-- Created:     11/26/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_address_select is
end tb_address_select;

architecture TEST of tb_address_select is

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

  component address_select
    PORT(
         address : in std_logic_vector(19 downto 0);
         ad_r : in std_logic_vector(19 downto 0);
         ad_sel_w : in std_logic;
         clk : in std_logic;
         rst_n : in std_logic;
         SRAM1_address : out std_logic_vector(19 downto 0);
         SRAM2_address : out std_logic_vector(19 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal address : std_logic_vector(19 downto 0);
  signal ad_r : std_logic_vector(19 downto 0);
  signal ad_sel_w : std_logic;
  signal clk : std_logic;
  signal rst_n : std_logic;
  signal SRAM1_address : std_logic_vector(19 downto 0);
  signal SRAM2_address : std_logic_vector(19 downto 0);

-- signal <name> : <type>;

begin
  CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for 5 ns ;
end process;


  
  DUT: address_select port map(
                address => address,
                ad_r => ad_r,
                ad_sel_w => ad_sel_w,
                clk => clk,
                rst_n => rst_n,
                SRAM1_address => SRAM1_address,
                SRAM2_address => SRAM2_address
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    -- 1.  rst
       rst_n <= '0';
       address<="11110000000000000000";
       ad_r <= "00000000000011111111";
       wait for 10 ns;
    -- 2. read 1, write 2
       rst_n <= '1';
       ad_sel_w <= '1';
       wait for 10 ns;
    -- 3. read 2, write 1
       ad_sel_w <= '0';
       wait for 10 ns;

       
       
  

  end process;
end TEST;
