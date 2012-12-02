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

procedure draw_line(
    x1 : in integer;
    y1 : in integer;
    x2 : in integer;
    y2 : in integer;
    signal pixel_ready : in std_logic;
    signal line_drawn : in std_logic;
    signal line_coord : in std_logic_vector(31 downto 0);
    signal next_line : out std_logic;
    signal next_pixel : out std_logic;
    signal twopoints : out std_logic_vector(63 downto 0)
    ) is

    variable x_o, y_o : std_logic_vector(15 downto 0);
begin

    -- write the x and y values
    twopoints <= SINT_TO_STDV(x1,16) & SINT_TO_STDV(y1,16) & SINT_TO_STDV(x2,16) & SINT_TO_STDV(y2,16);
    next_line <= '1';
    while pixel_ready = '0' loop
        wait for Period;
        next_line <= '0';
        report "continuing to iterate....";
        if pixel_ready = '1' then
            report "pixel ready went to 1";
        end if;
    end loop;

    wait for 3*Period;
    next_pixel <= '1';
    wait for Period;
    next_pixel <= '0';
    while line_drawn = '0' loop
        --report "entered line_drawn loop.";
        while pixel_ready = '0' loop
            report "entered pixel ready loop.";
            wait for Period;
        end loop;
        wait for 3*Period;
        next_pixel <= '1';
        wait for Period;
        next_pixel <= '0';
    end loop;
    report "Line Done.";
    
end procedure draw_line;


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
  signal xo, yo : integer;

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
    -- Seperate the x and y so I can see it.
    xo <= to_integer(signed(line_coord(31 downto 16)) );
    yo <= to_integer(signed(line_coord(15 downto 0)) );

    rst <= '1';
    next_line <= '0';
    next_pixel <= '0';
    twopoints <= (others => '0');
    wait for Period/2;
    rst <= '0';

    -- test positive slopes. (in groups of 4)
    draw_line(1,1,10,10, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);
    draw_line(5,5,1,1, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);
    draw_line(1,1,5,3, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);
    draw_line(5,3,1,1, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);

    draw_line(1,1,3,5, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);
    draw_line(3,5,1,1, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);
    draw_line(3,5,10,5, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);
    draw_line(10,5,3,5, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);

    draw_line(3,5,3,25, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);
    draw_line(3,25,3,5, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);

    -- test negative slopes. ( in groups of 4)
    draw_line(5,0,0,5, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);
    draw_line(0,5,5,0, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);
    draw_line(5,2,0,5, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);
    draw_line(7,0,3,12, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);

    draw_line(3,12,7,0, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);
    draw_line(2,2,10,8, pixel_ready, line_drawn, line_coord, next_line, next_pixel, twopoints);

  end process;
end TEST;
