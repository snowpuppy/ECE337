-- $Id: $
-- File name:   tb_frame_decoder_coord_flattener_scalar.vhd
-- Created:     12/2/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_frame_decoder_coord_flattener_scalar is
generic (Period : Time := 4 ns);
end tb_frame_decoder_coord_flattener_scalar;

architecture TEST of tb_frame_decoder_coord_flattener_scalar is

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

  function STDV_TO_SINT( X: std_logic_vector)
     return integer is
  begin
    return to_integer(signed(x));
  end;

  component frame_decoder_coord_flattener_scalar
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         start : in std_logic;
         placer_z_in : in std_logic_vector(15 downto 0);
         placer_y_in : in std_logic_vector(15 downto 0);
         placer_x_in : in std_logic_vector(15 downto 0);
         quotient_xz : out std_logic_vector(15 downto 0);
         quotient_yz : out std_logic_vector(15 downto 0);
         error_z : out std_logic;
         done : out std_logic
    );
  end component;

  procedure test_division( x : in integer;
                           y : in integer;
                           z : in integer;
                           signal placer_z_in : out std_logic_vector(15 downto 0);
                           signal placer_x_in : out std_logic_vector(15 downto 0);
                           signal placer_y_in : out std_logic_vector(15 downto 0);
                           signal start : out std_logic;
                           signal quotient_xz : in std_logic_vector(15 downto 0);
                           signal quotient_yz : in std_logic_vector(15 downto 0);
                           signal error_z : in std_logic;
                           signal done : in std_logic
                           ) is
    variable x_div_z, y_div_z : integer;
  begin
    -- find the real values.
    x_div_z := x/z;
    y_div_z := y/z;

    -- perform the division circuit.
    start <= '1';
    placer_z_in <= SINT_TO_STDV(z,16);
    placer_y_in <= SINT_TO_STDV(y,16);
    placer_x_in <= SINT_TO_STDV(x,16);
    wait for Period;
    start <= '0';

    while done = '0' loop
        wait for Period;
    end loop;

    if (x_div_z = STDV_TO_SINT(quotient_xz)) then
        report "Division was correct for x / z.";
    else
        report "Division was incorrect for x / z.";
    end if;

  end procedure test_division;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal start : std_logic;
  signal placer_z_in : std_logic_vector(15 downto 0);
  signal placer_y_in : std_logic_vector(15 downto 0);
  signal placer_x_in : std_logic_vector(15 downto 0);
  signal quotient_xz : std_logic_vector(15 downto 0);
  signal quotient_yz : std_logic_vector(15 downto 0);
  signal error_z : std_logic;
  signal done : std_logic;

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: frame_decoder_coord_flattener_scalar port map(
                clk => clk,
                rst => rst,
                start => start,
                placer_z_in => placer_z_in,
                placer_y_in => placer_y_in,
                placer_x_in => placer_x_in,
                quotient_xz => quotient_xz,
                quotient_yz => quotient_yz,
                error_z => error_z,
                done => done
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    rst <= '1';
    start <= '0';
    placer_z_in <= (others => '0');
    placer_y_in <= (others => '0');
    placer_x_in <= (others => '0');
    wait for Period / 2;
    rst <= '0';

    test_division( 10, 22, 3, placer_z_in, placer_x_in, placer_y_in, start, quotient_xz, quotient_yz, error_z, done );
    test_division( -10, 22, 3, placer_z_in, placer_x_in, placer_y_in, start, quotient_xz, quotient_yz, error_z, done );
    test_division( 10, 22, -3, placer_z_in, placer_x_in, placer_y_in, start, quotient_xz, quotient_yz, error_z, done );
    test_division( 10, 22, 20, placer_z_in, placer_x_in, placer_y_in, start, quotient_xz, quotient_yz, error_z, done );

  end process;
end TEST;
