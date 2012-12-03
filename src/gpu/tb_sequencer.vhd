-- $Id: $
-- File name:   tb_sequencer.vhd
-- Created:     12/2/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_sequencer is
generic (Period : Time := 4 ns);
end tb_sequencer;

architecture TEST of tb_sequencer is

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

  component sequencer
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         start : in std_logic;
         line_drawn : in std_logic;
         num_vertices : in std_logic_vector(15 downto 0);
         connection : in std_logic_vector(15 downto 0);
         next_line : out std_logic;
         sequence_drawn : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal start : std_logic;
  signal line_drawn : std_logic;
  signal num_vertices : std_logic_vector(15 downto 0);
  signal connection : std_logic_vector(15 downto 0);
  signal next_line : std_logic;
  signal sequence_drawn : std_logic;

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: sequencer port map(
                clk => clk,
                rst => rst,
                start => start,
                line_drawn => line_drawn,
                num_vertices => num_vertices,
                connection => connection,
                next_line => next_line,
                sequence_drawn => sequence_drawn
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    rst <= '0';
    start <= '0';
    line_drawn <= '0';
    num_vertices <= (others => '0');
    connection <= (others => '0');
    wait for Period;

  end process;
end TEST;
