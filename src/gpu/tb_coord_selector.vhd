-- $Id: $
-- File name:   tb_coord_selector.vhd
-- Created:     12/4/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_coord_selector is
generic (Period : Time := 4 ns);
end tb_coord_selector;

architecture TEST of tb_coord_selector is

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

  component coord_selector
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         start : in std_logic;
         continue : in std_logic;
         line_drawn : in std_logic;
         count : in std_logic_vector(3 downto 0);
         num_vertices : in std_logic_vector(7 downto 0);
         vertices : in std_logic_vector(767 downto 0);
         two_points : out std_logic_vector(63 downto 0);
         next_line : out std_logic;
         sequence_drawn : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal start : std_logic;
  signal continue : std_logic;
  signal line_drawn : std_logic;
  signal count : std_logic_vector(3 downto 0);
  signal num_vertices : std_logic_vector(7 downto 0);
  signal vertices : std_logic_vector(767 downto 0);
  signal two_points : std_logic_vector(63 downto 0);
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

  DUT: coord_selector port map(
                clk => clk,
                rst => rst,
                start => start,
                continue => continue,
                line_drawn => line_drawn,
                count => count,
                num_vertices => num_vertices,
                vertices => vertices,
                two_points => two_points,
                next_line => next_line,
                sequence_drawn => sequence_drawn
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    rst <= '1';
    start <= '0';
    continue <= '0';
    line_drawn <= '0';
    count <= (others => '0');
    num_vertices <= (others => '0');
    vertices <= (others => '0');
    wait for Period/2;
    rst <= '0';

    -- start computations!
    num_vertices <= UINT_TO_STDV(3,8);
    for i in 0 to 15 loop
        vertices(767 - i*8 downto 767-7-i*8) <= UINT_TO_STDV(i+15,8);
    end loop;
    count <= UINT_TO_STDV(0,4);
    start <= '1';
    wait for Period;
    start <= '0';

    -- count to 16
    for i in 0 to 3 loop
        -- Keep the system going.
        while sequence_drawn = '0' loop
            wait for Period;
            -- check if next_line asserted.
            if next_line = '1' then
                wait for 3*Period;
                line_drawn <= '1';
                wait for Period;
                line_drawn <= '0';
            end if;
        end loop;
        report "loop " & integer'image(i) & " complete.";
        count <= UINT_TO_STDV(i,4);
        wait for Period;
        continue <= '1';
        wait for Period;
        continue <= '0';
    end loop;

    report "x = " & integer'image(to_integer(signed(two_points(31 downto 16)))) & "y = " & integer'image(to_integer(signed(two_points(15 downto 0))));

  end process;
end TEST;
