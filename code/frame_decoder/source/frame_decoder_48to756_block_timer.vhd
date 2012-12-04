-- $Id: $
-- File name:   frame_decoder_48to756_block_timer.vhd
-- Created:     11/23/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 48 to 756 block timer

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_ARITH.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;

entity frame_decoder_48to756_block_timer is
  port (
    clk               : in std_logic;
    rst 	      : in std_logic;
    restart 	      : in std_logic;
    count_up          : in std_logic;
    control           : in std_logic_vector(2 downto 0);
    num_vertices      : in std_logic_vector(7 downto 0);
    done_transfer     : out std_logic
  );
end frame_decoder_48to756_block_timer;

architecture behavioral of frame_decoder_48to756_block_timer is 
  signal count_vertices, next_count_vertices : std_logic_vector(4 downto 0);
  signal done_transfer_reg, done_transfer_reg_next : std_logic;
begin
  regist: process (rst,clk)
    begin
      if (rst = '1') then
        count_vertices <= (others => '0');
        done_transfer_reg <= '0';
      elsif (rising_edge(clk)) then
        count_vertices <= next_count_vertices;
        done_transfer_reg <= done_transfer_reg_next;
      end if;
    end process regist;
--------------------------------------------------------------------
nextstatelogic: process (count_vertices,count_up, control, num_vertices,restart) 
    begin
      next_count_vertices <= count_vertices;

      if (restart = '1') then
        next_count_vertices <= (others => '0');
      elsif (count_up = '1') then
        next_count_vertices <= count_vertices + 1;
      end if; 

      if (count_vertices = num_vertices) and (control = "001") then 
        done_transfer_reg_next <= '1';
      elsif ( count_vertices = "00010") and (control = "010")  then
        done_transfer_reg_next <= '1';
      elsif ( count_vertices = "00010") and (control = "011")  then
        done_transfer_reg_next <= '1';
      else
         done_transfer_reg_next <= '0';
      end if;

  end process nextstatelogic;
--------------------------------------------------------------------
    done_transfer <= done_transfer_reg;
end behavioral;
