-- $Id: $
-- File name:   tb_negative_small_slope.vhd
-- Created:     11/30/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_negative_small_slope is
generic (Period : Time := 4 ns);
end tb_negative_small_slope;

architecture TEST of tb_negative_small_slope is

  function UINT_TO_STDV( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector(to_unsigned(X, NumBits));
  end;

  function SINT_TO_STDV( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector(to_signed(X, NumBits));
  end;

  function STDV_TO_UINT( X: std_logic_vector)
     return integer is
  begin
    return to_integer(unsigned(x));
  end;

  component negative_small_slope
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         strobe : in std_logic;
         load : in std_logic;
         enable : in std_logic;
         dx : in std_logic_vector(15 downto 0);
         dy : in std_logic_vector(15 downto 0);
         xi : in std_logic_vector(15 downto 0);
         xf : in std_logic_vector(15 downto 0);
         yi : in std_logic_vector(15 downto 0);
         yf : in std_logic_vector(15 downto 0);
         pixel_done : out std_logic;
         line_done : out std_logic;
         x : out std_logic_vector(15 downto 0);
         y : out std_logic_vector(15 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal strobe : std_logic;
  signal load : std_logic;
  signal enable : std_logic;
  signal dx : std_logic_vector(15 downto 0);
  signal dy : std_logic_vector(15 downto 0);
  signal xi : std_logic_vector(15 downto 0);
  signal xf : std_logic_vector(15 downto 0);
  signal yi : std_logic_vector(15 downto 0);
  signal yf : std_logic_vector(15 downto 0);
  signal pixel_done : std_logic;
  signal line_done : std_logic;
  signal x : std_logic_vector(15 downto 0);
  signal y : std_logic_vector(15 downto 0);

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: negative_small_slope port map(
                clk => clk,
                rst => rst,
                strobe => strobe,
                load => load,
                enable => enable,
                dx => dx,
                dy => dy,
                xi => xi,
                xf => xf,
                yi => yi,
                yf => yf,
                pixel_done => pixel_done,
                line_done => line_done,
                x => x,
                y => y
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    rst <= '1';
    strobe <= '0';
    load <= '0';
    enable <= '0';
    dx <= x"0000";
    dy <= x"0000";
    xi <= x"0000";
    xf <= x"0000";
    yi <= x"0000";
    yf <= x"0000";
    wait for Period/2;
    rst <= '0';

    -- test regular line.
    strobe <= '0';
    load <= '1';
    enable <= '0';
    dx <= SINT_TO_STDV(5,16);
    dy <= SINT_TO_STDV(-5,16);
    xi <= SINT_TO_STDV(0,16);
    yi <= SINT_TO_STDV(5,16);
    xf <= SINT_TO_STDV(5,16);
    yf <= SINT_TO_STDV(0,16);
    wait for Period;

    for i in 0 to 12 loop
        strobe <= '1';
        load <= '0';
        enable <= '1';
        wait for Period;
    end loop;

    -- test flat line zero slope
    strobe <= '0';
    load <= '1';
    enable <= '0';
    dx <= SINT_TO_STDV(5,16);
    dy <= SINT_TO_STDV(-3,16);
    xi <= SINT_TO_STDV(0,16);
    yi <= SINT_TO_STDV(5,16);
    xf <= SINT_TO_STDV(5,16);
    yf <= SINT_TO_STDV(2,16);
    wait for Period;

    for i in 0 to 12 loop
        strobe <= '1';
        load <= '0';
        enable <= '1';
        wait for Period;
    end loop;

    -- test slope of one
    strobe <= '0';
    load <= '1';
    enable <= '0';
    dx <= SINT_TO_STDV(6,16);
    dy <= SINT_TO_STDV(-6,16);
    xi <= SINT_TO_STDV(1,16);
    yi <= SINT_TO_STDV(7,16);
    xf <= SINT_TO_STDV(7,16);
    yf <= SINT_TO_STDV(1,16);
    wait for Period;

    for i in 0 to 14 loop
        strobe <= '1';
        load <= '0';
        enable <= '1';
        wait for Period;
    end loop;

  end process;
end TEST;
