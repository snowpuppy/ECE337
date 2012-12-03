-- $Id: $
-- File name:   coord_selector.vhd
-- Created:     12/2/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This block selects the appropriate coordinates that
-- require lines to be drawn between them using the count values
-- from the timer and the sequencer. The timer and sequencer act
-- as a "double for loop".


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity coord_selector is
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
end entity coord_selector;

architecture coord_selector_arch of coord_selector is
    component sequencer is
        port (
            clk                 : in    std_logic;
            rst                 : in    std_logic;
            start               : in    std_logic;
            line_drawn          : in    std_logic;
            num_vertices        : in    std_logic_vector(7 downto 0);
            connection          : in    std_logic_vector(15 downto 0);
            next_line           : out    std_logic;
            sequence_drawn      : out    std_logic;
            addr                : out   std_logic_vector(3 downto 0)
            );
    end component sequencer;

    signal coord1, coord2 : std_logic_vector(31 downto 0);
    signal addr : std_logic_vector(3 downto 0);
    signal connection : std_logic_vector(15 downto 0);
begin
    -- map the sequencer
    seq1:sequencer port map (
            clk => clk,
            rst => rst,
            start => start,
            line_drawn => line_drawn,
            num_vertices => num_vertices,
            connection => connection,
            next_line => next_line,
            sequence_drawn => sequence_drawn,
            addr => addr
            );

    -- perform logic for multiplexers based
    -- on the count from the timer and the
    -- addr from the sequencer.
    -- There are 3 words per vertices and
    -- there are 16 vertices giving at total
    -- of 3x16x16 = 768 bits.
    with (count) select
    connection <= vertices(767 downto 752) when "0000",
    vertices(719 downto 704) when "0001",
    vertices(671 downto 656) when "0010",
    vertices(623 downto 608) when "0011",
    vertices(575 downto 560) when "0100",
    vertices(527 downto 512) when "0101",
    vertices(479 downto 464) when "0110",
    vertices(431 downto 416) when "0111",
    vertices(383 downto 368) when "1000",
    vertices(335 downto 320) when "1001",
    vertices(287 downto 272) when "1010",
    vertices(239 downto 224) when "1011",
    vertices(191 downto 176) when "1100",
    vertices(143 downto 128) when "1101",
    vertices(95 downto 80) when "1110",
    vertices(47 downto 32) when "1111",
    x"0000" when others;

    with (count) select
    coord1 <= vertices(751 downto 720) when "0000",
    vertices(703 downto 672) when "0001",
    vertices(655 downto 624) when "0010",
    vertices(607 downto 576) when "0011",
    vertices(559 downto 528) when "0100",
    vertices(511 downto 480) when "0101",
    vertices(463 downto 432) when "0110",
    vertices(415 downto 384) when "0111",
    vertices(367 downto 336) when "1000",
    vertices(319 downto 288) when "1001",
    vertices(271 downto 240) when "1010",
    vertices(223 downto 192) when "1011",
    vertices(175 downto 144) when "1100",
    vertices(127 downto 96) when "1101",
    vertices(79 downto 48) when "1110",
    vertices(31 downto 0) when "1111",
    x"00000000" when others;

    with (addr) select
    coord2 <= vertices(751 downto 720) when "0000",
    vertices(703 downto 672) when "0001",
    vertices(655 downto 624) when "0010",
    vertices(607 downto 576) when "0011",
    vertices(559 downto 528) when "0100",
    vertices(511 downto 480) when "0101",
    vertices(463 downto 432) when "0110",
    vertices(415 downto 384) when "0111",
    vertices(367 downto 336) when "1000",
    vertices(319 downto 288) when "1001",
    vertices(271 downto 240) when "1010",
    vertices(223 downto 192) when "1011",
    vertices(175 downto 144) when "1100",
    vertices(127 downto 96) when "1101",
    vertices(79 downto 48) when "1110",
    vertices(31 downto 0) when "1111",
    x"00000000" when others;

    two_points <= coord1 & coord2;

end architecture coord_selector_arch;
