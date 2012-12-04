-- $Id: $
-- File name:   tb_frame_decoder_2D12_timer.vhd
-- Created:     11/29/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_frame_decoder_2D12_timer is
  generic (Period : Time := 10 ns);
end tb_frame_decoder_2D12_timer;

architecture TEST of tb_frame_decoder_2D12_timer is

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

  component frame_decoder_2D12_timer
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         restart : in std_logic;
         clk_up : in std_logic;
         six_assert : out std_logic;
         eight_assert : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal restart : std_logic;
  signal clk_up : std_logic;
  signal six_assert : std_logic;
  signal eight_assert : std_logic;

-- signal <name> : <type>;

begin
    CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;
  DUT: frame_decoder_2D12_timer port map(
                clk => clk,
                rst => rst,
                restart => restart,
                clk_up => clk_up,
                six_assert => six_assert,
                eight_assert => eight_assert
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

  	rst <= '1';
  	restart <= '0';
	clk_up <= '0';
	wait for 20 ns;
	rst <= '0';
	wait for 30 ns;
	for a in 1 to 9 loop
	  clk_up <= '1';
	  wait for 20 ns;
	  clk_up <= '0';
	  wait for 20 ns;
	end loop;

	restart <= '1';
 	wait for 20 ns;
	restart <= '0';
	wait for 20 ns;
	for b in 1 to 9 loop
	  clk_up <= '1';
	  wait for 10 ns;
	  clk_up <= '0';
	  wait for 10 ns;
	end loop;

	restart <= '1';
	wait for 100 ns;


  end process;
end TEST;
