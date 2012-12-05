-- $Id: $
-- File name:   sram_tb_address_buffer.vhd
-- Created:     11/22/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity sram_tb_address_buffer is
end sram_tb_address_buffer;

architecture TEST of sram_tb_address_buffer is

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

  component sram_address_buffer
    PORT(
         address_in : in std_logic_vector(19 downto 0);
         address : out std_logic_vector(19 downto 0);
         rst_n : in std_logic;
         clk : in std_logic;
         ad_load : in std_logic
    );
  end component;

-- Insert signals Declarations here
  signal address_in : std_logic_vector(19 downto 0);
  signal address : std_logic_vector(19 downto 0);
  signal rst_n : std_logic;
  signal clk : std_logic;
  signal ad_load : std_logic;

-- signal <name> : <type>;

begin
CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for 5 ns ;
end process;



  
  DUT: sram_address_buffer port map(
                address_in => address_in,
                address => address,
                rst_n => rst_n,
                clk => clk,
                ad_load => ad_load
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here
       --          01234567890123456789
    address_in <= "01010101010101010101";
    rst_n <='0'; 
    ad_load <= '0';
    wait for 10 ns;

    rst_n <= '1';
    wait for 20 ns;

    ad_load <= '1';

    wait for 10 ns;

    ad_load <= '0';
    address_in <= "11110101110111011111";

    wait for 10 ns;

    ad_load <= '1';

    wait for 40 ns;

    
    
     
  end process;
end TEST;
