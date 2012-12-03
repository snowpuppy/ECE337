-- $Id: $
-- File name:   gpu_timer.vhd
-- Created:     12/2/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This block counts to the number of vertices
-- so that each vertices connection byte can be considered.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity gpu_timer is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        start               : in    std_logic;
        sequence_drawn      : in    std_logic;
        num_vertices        : in    std_logic_vector(7 downto 0);
        done1               : out   std_logic;
        count               : out   std_logic_vector(3 downto 0)
        );
end entity gpu_timer;

architecture gpu_timer_arch of gpu_timer is
    signal count_reg, count_nxt : std_logic_vector(4 downto 0);
begin

  reg: process (clk, rst)
  begin
    if rst = '1' then -- active reset
        count_reg <= (others => '0');
    elsif rising_edge(clk) then  -- check clock edge
        count_reg <= count_nxt;
    end if;
  end process reg;

  -- Next count logic for timer.
  nextCount : process(count_reg)
  begin
    count_nxt <= count_reg;
    if start = '1' then
        count_nxt <= (others => '0');
    elsif count_reg = num_vertices(4 downto 0) then
        count_nxt <= (others => '0');
    elsif sequence_drawn = '1' then
        count_nxt <= count_reg + 1;
    end if;
  end process nextCount;

    count <= count_reg(3 downto 0);
    done1 <= '1' when count_reg = num_vertices(4 downto 0) else '0';

end architecture gpu_timer_arch;
