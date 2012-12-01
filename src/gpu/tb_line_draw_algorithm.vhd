-- $Id: $
-- File name:   tb_line_draw_algorithm.vhd
-- Created:     12/1/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_line_draw_algorithm is
generic (Period : Time := 4 ns);
end tb_line_draw_algorithm;

architecture TEST of tb_line_draw_algorithm is

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

  component line_draw_algorithm
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         next_line : in std_logic;
         next_pixel : in std_logic;
         twopoints : in std_logic_vector(63 downto 0);
         pixel_ready : out std_logic;
         line_drawn : out std_logic;
         line_coord : out std_logic_vector(31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal next_line : std_logic;
  signal next_pixel : std_logic;
  signal twopoints : std_logic_vector(63 downto 0);
  signal pixel_ready : std_logic;
  signal line_drawn : std_logic;
  signal line_coord : std_logic_vector(31 downto 0);

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: line_draw_algorithm port map(
                clk => clk,
                rst => rst,
                next_line => next_line,
                next_pixel => next_pixel,
                twopoints => twopoints,
                pixel_ready => pixel_ready,
                line_drawn => line_drawn,
                line_coord => line_coord
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    rst <= 

    next_line <= 

    next_pixel <= 

    twopoints <= 

  end process;
end TEST;