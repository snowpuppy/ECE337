-- $Id: $
-- File name:   tb_seq_divider.vhd
-- Created:     11/11/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_seq_divider is
generic (Period : Time := 4 ns);
end tb_seq_divider;

architecture TEST of tb_seq_divider is

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

  component seq_divider
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         start : in std_logic;
         divisor : in std_logic_vector(15 downto 0);
         div : in std_logic_vector(15 downto 0);
         done : out std_logic;
         quotient1 : out std_logic_vector(15 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal start : std_logic;
  signal divisor : std_logic_vector(15 downto 0);
  signal div : std_logic_vector(15 downto 0);
  signal done : std_logic;
  signal quotient1 : std_logic_vector(15 downto 0);

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: seq_divider port map(
                clk => clk,
                rst => rst,
                start => start,
                divisor => divisor,
                div => div,
                done => done,
                quotient1 => quotient1
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    rst <= '1';
    start <= '1';
    divisor <= x"0003";
    div <= x"000A";
    wait for 6 ns;
    rst <= '0';
    wait for 4 ns;
    start <= '0';
    wait for 80 ns; -- wait for division to complete


    start <= '1';
    divisor <= x"0004";
    div <= x"0010";
    wait for 4 ns;
    start <= '0';
    wait for 80 ns;

    start <= '1';
    divisor <= x"0005";
    div <= x"0014";
    wait for 4 ns;
    start <= '0';
    wait for 80 ns;

    start <= '1';
    divisor <= x"0005";
    div <= x"0019";
    wait for 4 ns;
    start <= '0';
    wait for 80 ns;

    start <= '1';
    divisor <= x"002F";
    div <= x"02A2";
    wait for 4 ns;
    start <= '0';
    wait for 80 ns;

  end process;
end TEST;
