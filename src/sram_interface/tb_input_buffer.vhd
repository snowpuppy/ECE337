-- $Id: $
-- File name:   tb_input_buffer.vhd
-- Created:     11/25/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_input_buffer is
end tb_input_buffer;

architecture TEST of tb_input_buffer is

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

  component input_buffer
    PORT(
         data : in std_logic_vector(63 downto 0);
         data_out : out std_logic_vector(23 downto 0);
         rst_n : in std_logic;
         clk : in std_logic;
         sram_sel : in std_logic;
         out_en : in std_logic
    );
  end component;

-- Insert signals Declarations here
  signal data : std_logic_vector(63 downto 0);
  signal data_out : std_logic_vector(23 downto 0);
  signal rst_n : std_logic;
  signal clk : std_logic;
  signal sram_sel : std_logic;
  signal out_en : std_logic;

-- signal <name> : <type>;

begin
CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for 5 ns ;
end process;




  
  DUT: input_buffer port map(
                data => data,
                data_out => data_out,
                rst_n => rst_n,
                clk => clk,
                sram_sel => sram_sel,
                out_en => out_en
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here
       --  0        1         2         3         4         5         6
    --     1234567890123456789012345678901234567890123456789012345678901234
  data <= "0000000000000000000000000000000000000000000000000000000000000000";
  sram_sel <= '0';
  out_en <= '0';

  rst_n <= '0';

  wait for 10 ns;

         --  0        1         2         3         4         5         6
    --     1234567890123456789012345678901234567890123456789012345678901234
  data <= "0000000000000000000000000000011111111111111111111111111111111111";

  sram_sel <= '1';
  out_en <= '1';
  rst_n <= '1';

  wait for 10 ns;

  sram_sel <= '0';

  wait for 10 ns;

  out_en <='0';
  sram_sel <= '1';
  
  
   

  end process;
end TEST;
