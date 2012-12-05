-- $Id: $
-- File name:   sram_tb_Address_generator.vhd
-- Created:     11/26/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity sram_tb_Address_generator is
end sram_tb_Address_generator;

architecture TEST of sram_tb_Address_generator is

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

  component sram_Address_generator
    PORT(
         update : in std_logic;
         rst_n : in std_logic;
         clk : in std_logic;
         done : out std_logic;
         address_input : out std_logic_vector(19 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal update : std_logic;
  signal rst_n : std_logic;
  signal clk : std_logic;
  signal done : std_logic;
  signal address_input : std_logic_vector(19 downto 0);

-- signal <name> : <type>;

begin
CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for 1 ns ;
end process;



  
  DUT: sram_Address_generator port map(
                update => update,
                rst_n => rst_n,
                clk => clk,
                done => done,
                address_input => address_input
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here
-- rst 
    update <='0'; 

    rst_n <= '0';

    wait for 10 ns;

    rst_n <= '1';
    for i  in 0 to 345598 loop
      
      update <= '1';
      wait for 2 ns;
      update <= '0';
      wait for 2 ns;
      
    end loop;  -- i
    update <= '1';
    wait for 2 ns;
    update <= '0';
    wait for 500 ns;
    update <= '1';
    wait for 1000 ns;

  end process;
end TEST;
