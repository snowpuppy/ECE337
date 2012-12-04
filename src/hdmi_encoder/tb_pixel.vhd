-- $Id: $
-- File name:   tb_pixel.vhd
-- Created:     11/10/2012
-- Author:      Xiao Zuguang
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_pixel is
    generic (Period: Time:= 10 ns);
end tb_pixel;

architecture TEST of tb_pixel is

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

  component pixel
    PORT(
         rst_n : in std_logic;
         TMDS_CLK : in std_logic;
         pixel_loc : out std_logic_vector(9 downto 0);
         one_row: out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal rst_n : std_logic;
  signal TMDS_CLK : std_logic;
  signal pixel_loc : std_logic_vector(9 downto 0);
  signal one_row: std_logic;

-- signal <name> : <type>;

begin
  DUT: pixel port map(
                rst_n => rst_n,
                TMDS_CLK => TMDS_CLK,
                pixel_loc => pixel_loc,
                one_row => one_row
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);
  CLKGEN:process
  variable clk_tmp: std_logic := '0';
  begin
    clk_tmp := not clk_tmp;
    TMDS_CLK <= clk_tmp;
    wait for Period/2;
  end process;
process

  begin

-- Insert TEST BENCH Code Here

    rst_n <= '0';
    wait for 50 ns;

    rst_n <= '1';
    wait for 5000000 ns;

  end process;
end TEST;