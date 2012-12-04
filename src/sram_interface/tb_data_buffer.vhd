-- $Id: $
-- File name:   tb_data_buffer.vhd
-- Created:     11/22/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_data_buffer is
end tb_data_buffer;

architecture TEST of tb_data_buffer is

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

  component data_buffer
    PORT(
         rst_n : in std_logic;
         clk : in std_logic;
         data_in : in std_logic_vector(23 downto 0);
         data_load : in std_logic;
         data : out std_logic_vector(31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal rst_n : std_logic;
  signal clk : std_logic;
  signal data_in : std_logic_vector(23 downto 0);
  signal data_load : std_logic;
  signal data : std_logic_vector(31 downto 0);

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for 5 ns ;
end process;


  
  DUT: data_buffer port map(
                rst_n => rst_n,
                clk => clk,
                data_in => data_in,
                data_load => data_load,
                data => data
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    rst_n <= '0';

     --       "012345678901234567890123"
    data_in <="000000000000000000000000"; 

    data_load <='0';

    wait for 20 ns;

    rst_n <= '1';

    wait for 20 ns;

     --       "012345678901234567890123"
    data_in <="100001000010000100001000"; 

    wait for 20 ns;

    data_load <= '1';

    wait for 20 ns;
  --          "012345678901234567890123"
    data_in <="111111111010000100001000";

    wait for 20 ns;

    data_load <= '0';
    data_in <= "000000000000000000000000"; 

    wait for 20 ns;

    data_load <= '1';

    wait for 20 ns;

    

  end process;
end TEST;
