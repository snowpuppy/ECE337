-- $Id: $
-- File name:   tb_drawlogic_block.vhd
-- Created:     12/4/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_drawlogic_block is
generic (Period : Time := 4 ns);
end tb_drawlogic_block;

architecture TEST of tb_drawlogic_block is

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

  function to_string(sv: Std_Logic_Vector) return string is
    use Std.TextIO.all;
    variable bv: bit_vector(sv'range) := to_bitvector(sv);
    variable lp: line;
  begin
    write(lp, bv);
    return lp.all;
  end;

  component drawlogic_block
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         start : in std_logic;
         new_data : in std_logic;
         strobe_fill : in std_logic;
         next_pixel : in std_logic;
         num_vertices : in std_logic_vector(7 downto 0);
         vertices : in std_logic_vector(767 downto 0);
         done1 : out std_logic;
         done2 : out std_logic;
         pixel_ready : out std_logic;
         fill_coord : out std_logic_vector(31 downto 0);
         line_coord : out std_logic_vector(31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal start : std_logic;
  signal new_data : std_logic;
  signal strobe_fill : std_logic;
  signal next_pixel : std_logic;
  signal num_vertices : std_logic_vector(7 downto 0);
  signal vertices : std_logic_vector(767 downto 0);
  signal done1 : std_logic;
  signal done2 : std_logic;
  signal pixel_ready : std_logic;
  signal fill_coord : std_logic_vector(31 downto 0);
  signal line_coord : std_logic_vector(31 downto 0);
  signal x_l, y_l, x_f, y_f : std_logic_vector(15 downto 0);

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: drawlogic_block port map(
                clk => clk,
                rst => rst,
                start => start,
                new_data => new_data,
                strobe_fill => strobe_fill,
                next_pixel => next_pixel,
                num_vertices => num_vertices,
                vertices => vertices,
                done1 => done1,
                done2 => done2,
                pixel_ready => pixel_ready,
                fill_coord => fill_coord,
                line_coord => line_coord
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);
    x_l <= line_coord(31 downto 16);
    y_l <= line_coord(15 downto 0);
    x_f <= fill_coord(31 downto 16);
    y_f <= fill_coord(15 downto 0);

process

  begin

-- Insert TEST BENCH Code Here

    rst <= '1';
    start <= '0';
    new_data <= '0';
    strobe_fill <= '0';
    next_pixel <= '0';
    num_vertices <= (others => '0');
    vertices <= (others => '0');
    wait for Period/2;
    rst <= '0';

    -- start the data!
    num_vertices <= UINT_TO_STDV(3,8);
    for i in 0 to 15 loop
        vertices(767 - i*8 downto 767-7-i*8) <= UINT_TO_STDV(i+15,8);
    end loop;
    -- start the sequence.
    start <= '1';
    wait for Period;
    start <= '0';

    -- wait for the drawing to finish
    while done1 = '0' loop
        while pixel_ready = '0' loop
            wait for Period;
        end loop;
        wait for 3*Period;
        next_pixel <= '1';
        wait for Period;
        next_pixel <= '0';
    end loop;

  end process;
end TEST;
