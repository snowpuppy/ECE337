-- $Id: $
-- File name:   drawlogic_block.vhd
-- Created:     12/2/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This block contains all of the blocks directly involved in writing pixels
-- to the SRAM interface. The upper level block contains trivial blocks in comparison to
-- this one.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity drawlogic_block is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        start               : in    std_logic;
        new_data            : in    std_logic;
        strobe_fill         : in    std_logic;
        next_pixel          : in    std_logic;
        num_vertices        : in    std_logic_vector(7 downto 0);
        vertices            : in    std_logic_vector(767 downto 0);
        done1               : out   std_logic;
        done2               : out   std_logic;
        pixel_ready         : out   std_logic;
        fill_coord          : out   std_logic_vector(31 downto 0);
        line_coord          : out   std_logic_vector(31 downto 0)
        );
end entity drawlogic_block;

architecture drawlogic_block_arch of drawlogic_block is

component pixel_fill is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        strobe_fill         : in    std_logic;
        new_data            : in    std_logic;
        xi                  : in    std_logic_vector(15 downto 0);
        yi                  : in    std_logic_vector(15 downto 0);
        w                   : in    std_logic_vector(15 downto 0);
        h                   : in    std_logic_vector(15 downto 0);
        done2               : out   std_logic;
        x                   : out   std_logic_vector(15 downto 0);
        y                   : out   std_logic_vector(15 downto 0)
        );
end component pixel_fill;

component gpu_timer is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        start               : in    std_logic;
        sequence_drawn      : in    std_logic;
        num_vertices        : in    std_logic_vector(7 downto 0);
        done1               : out   std_logic;
        count               : out   std_logic_vector(3 downto 0)
        );
end component gpu_timer;

component line_draw_algorithm is
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
end component line_draw_algorithm;

component coord_selector is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        start               : in    std_logic;
        line_drawn          : in    std_logic;
        count               : in    std_logic_vector(3 downto 0);
        num_vertices        : in    std_logic_vector(7 downto 0);
        vertices            : in    std_logic_vector(767 downto 0);
        two_points          : out   std_logic_vector(63 downto 0);
        next_line           : out    std_logic;
        sequence_drawn      : out    std_logic
        );
end component coord_selector;

    signal xi, yi, w, h,x,y : std_logic_vector(15 downto 0);
    signal sequence_drawn : std_logic;
    signal count : std_logic_vector(3 downto 0);
    signal line_drawn : std_logic;
    signal next_line  : std_logic;
    signal two_points : std_logic_vector(63 downto 0);
begin

drw_pixel_fill: pixel_fill port map (
        clk => clk,
        rst => rst,
        strobe_fill => strobe_fill,
        new_data => new_data,
        xi => xi,
        yi => yi,
        w => w,
        h => h,
        done2 => done2,
        x => x,
        y => y
        );

drw_gpu_timer: gpu_timer port map (
        clk => clk,
        rst => rst,
        start => start,
        sequence_drawn => sequence_drawn,
        num_vertices => num_vertices,
        done1 => done1,
        count => count
        );

drw_line_draw_algorithm: line_draw_algorithm port map (
        clk => clk,
        rst => rst,
        next_line => next_line,
        next_pixel => next_pixel,
        twopoints => two_points,
        pixel_ready => pixel_ready,
        line_drawn => line_drawn,
        line_coord => line_coord
        );

drw_coord_selector:coord_selector port map (
        clk => clk,
        rst => rst,
        start => start,
        line_drawn => line_drawn,
        count => count,
        num_vertices => num_vertices,
        vertices => vertices,
        two_points => two_points,
        next_line => next_line,
        sequence_drawn => sequence_drawn
        );

        -- distribute xi, yi, w, and h appropriately.
        -- CONFIRM WITH CHUNTA
        xi <= vertices(767 downto 752);
        yi <= vertices(751 downto 736);
        w <= vertices(735 downto 720);
        h <= vertices(719 downto 704);

        -- output fill_coord
        fill_coord <= x & y;

end architecture drawlogic_block_arch;
