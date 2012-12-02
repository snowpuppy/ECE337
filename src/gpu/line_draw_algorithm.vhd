-- $Id: $
-- File name:   line_draw_algorithm.vhd
-- Created:     12/1/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This is a combination of blocs that makes the line drawing
-- algorithm possible. There are four separate blocks for four different cases
-- in drawing lines. There is a block for initial calculations on the x and y values,
-- and there is a controller.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity line_draw_algorithm is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        next_line            : in    std_logic;
        next_pixel           : in    std_logic;
        twopoints           : in    std_logic_vector(63 downto 0);
        pixel_ready         : out   std_logic;
        line_drawn          : out   std_logic;
        line_coord          : out   std_logic_vector(31 downto 0)
        );
end entity line_draw_algorithm;

architecture line_draw_algorithm_arch of line_draw_algorithm is

component positive_small_slope is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        strobe              : in    std_logic;
        load                : in    std_logic;
        enable              : in    std_logic;
        dx                  : in    std_logic_vector(15 downto 0);
        dy                  : in    std_logic_vector(15 downto 0);
        xi                  : in    std_logic_vector(15 downto 0);
        xf                  : in    std_logic_vector(15 downto 0);
        yi                  : in    std_logic_vector(15 downto 0);
        yf                  : in    std_logic_vector(15 downto 0);
        pixel_done          : out    std_logic;
        line_done           : out    std_logic;
        x                   : out    std_logic_vector(15 downto 0);
        y                   : out    std_logic_vector(15 downto 0)
    );
end component positive_small_slope;

component negative_small_slope is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        strobe              : in    std_logic;
        load                : in    std_logic;
        enable              : in    std_logic;
        dx                  : in    std_logic_vector(15 downto 0);
        dy                  : in    std_logic_vector(15 downto 0);
        xi                  : in    std_logic_vector(15 downto 0);
        xf                  : in    std_logic_vector(15 downto 0);
        yi                  : in    std_logic_vector(15 downto 0);
        yf                  : in    std_logic_vector(15 downto 0);
        pixel_done          : out    std_logic;
        line_done           : out    std_logic;
        x                   : out    std_logic_vector(15 downto 0);
        y                   : out    std_logic_vector(15 downto 0)
    );
end component negative_small_slope;

component line_alg_controller is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        small_slope         : in    std_logic;
        positive_slope      : in    std_logic;
        next_line           : in    std_logic;
        next_pixel          : in    std_logic;
        status              : in    std_logic_vector(7 downto 0); -- each block has two status bits which come here (4 blocks).
        load                : out    std_logic;
        strobe              : out    std_logic;
        read_data           : out    std_logic;
        line_drawn          : out   std_logic;
        pixel_ready         : out   std_logic;
        enable              : out    std_logic_vector(3 downto 0)
    );
end component line_alg_controller;

component initial_calc is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        read_data           : in    std_logic;
        x1                  : in    std_logic_vector(15 downto 0);
        x2                  : in    std_logic_vector(15 downto 0);
        y1                  : in    std_logic_vector(15 downto 0);
        y2                  : in    std_logic_vector(15 downto 0);
        --calculations        : out   std_logic_vector(95 downto 0);
        xi                  : out   std_logic_vector(15 downto 0);
        xf                  : out   std_logic_vector(15 downto 0);
        yi                  : out   std_logic_vector(15 downto 0);
        yf                  : out   std_logic_vector(15 downto 0);
        dx                  : out   std_logic_vector(15 downto 0);
        dy                  : out   std_logic_vector(15 downto 0);
        positive_slope      : out   std_logic;
        small_slope         : out   std_logic
     );
end component initial_calc;

-- DECLARE SIGNALS FOR USE WITH DRAWLOGIC BLOCK
    signal xps, xpl, xns, xnl : std_logic_vector(15 downto 0);
    signal yps, ypl, yns, ynl : std_logic_vector(15 downto 0);
    signal x_l, y_l : std_logic_vector(15 downto 0);
    signal enable : std_logic_vector(3 downto 0);
    signal status : std_logic_vector(7 downto 0);
    signal read_data, strobe : std_logic;
    signal xi, xf, yi, yf, dx, dy :std_logic_vector(15 downto 0);
    signal positive_slope, small_slope : std_logic;
    signal load : std_logic;
    signal x1, y1, x2, y2 : std_logic_vector(15 downto 0);
    signal enable0, enable1, enable2, enable3 : std_logic;
    signal status0, status1, status2, status3, status4, status5, status6, status7 : std_logic;
    signal negdy, negdx : std_logic_vector(15 downto 0);

begin

pos_small_slope:positive_small_slope port map(
        clk => clk,
        rst => rst,
        strobe => strobe,
        load => load,
        enable => enable0,
        dx => dx,
        dy => dy,
        xi => xi,
        xf => xf,
        yi => yi,
        yf => yf,
        pixel_done => status0,
        line_done => status1,
        x => xps,
        y => yps
    );

pos_large_slope:positive_small_slope port map(
        clk => clk,
        rst => rst,
        strobe => strobe,
        load => load,
        enable => enable1,
        dx => dy,
        dy => dx,
        xi => yi,
        xf => yf,
        yi => xi,
        yf => xf,
        pixel_done => status2,
        line_done => status3,
        x => ypl,
        y => xpl
    );
neg_small_slope:negative_small_slope port map ( 
        clk => clk,
        rst => rst,
        strobe => strobe,
        load => load,
        enable => enable2,
        dx => dx,
        dy => dy,
        xi => xi,
        xf => xf,
        yi => yi,
        yf => yf,
        pixel_done => status4,
        line_done => status5,
        x => xns,
        y => yns
    );

neg_large_slope:negative_small_slope port map (
        clk => clk,
        rst => rst,
        strobe => strobe,
        load => load,
        enable => enable3,
        dx => dy,--negdy,
        dy => dx,--negdx,
        xi => yi,
        xf => yf,
        yi => xi,
        yf => xf,
        pixel_done => status6,
        line_done => status7,
        x => ynl,
        y => xnl
    );

line_alg_cntr:line_alg_controller port map (
        clk => clk,
        rst => rst,
        small_slope => small_slope,
        positive_slope => positive_slope,
        next_line => next_line,
        next_pixel => next_pixel,
        status => status,               -- each block has two status bits which come here (4 blocks).
        load => load,
        strobe => strobe,
        read_data => read_data,
        line_drawn => line_drawn,
        pixel_ready => pixel_ready,
        enable => enable
    );

init_calc:initial_calc port map (
        clk => clk,
        rst => rst,
        read_data => read_data,
        x1 => x1,
        x2 => x2,
        y1 => y1,
        y2 => y2,
        -- => --calculations,
        xi => xi,
        xf => xf,
        yi => yi,
        yf => yf,
        dx => dx,
        dy => dy,
        positive_slope => positive_slope,
        small_slope => small_slope
     );

    --complement:process(dx,dy)
    --begin
    --    negdx <= std_logic_vector( not(signed(dx)) + 1 );
    --    negdy <= std_logic_vector( not(signed(dy)) + 1 );
    --end process complement;

    status <= status7 & status6 & status5 & status4 & status3 & status2 & status1 & status0;

    enable0 <= enable(0);
    enable1 <= enable(1);
    enable2 <= enable(2);
    enable3 <= enable(3);

    x1 <= twopoints(63 downto 48);
    y1 <= twopoints(47 downto 32);
    x2 <= twopoints(31 downto 16);
    y2 <= twopoints(15 downto 0);

    -- choose the correct x and y data.
    x_l <= xps when enable = "0001" else xpl when enable = "0010" else xns when enable = "0100" else xnl when enable = "1000" else (others => '0');
    y_l <= yps when enable = "0001" else ypl when enable = "0010" else yns when enable = "0100" else ynl when enable = "1000" else (others => '0');

    -- join the x and y data
    line_coord <= x_l & y_l;

end architecture line_draw_algorithm_arch;
