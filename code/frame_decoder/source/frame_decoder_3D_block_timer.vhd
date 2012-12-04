-- $Id: $
-- File name:   frame_decoder_3D_block_timer.vhd
-- Created:     11/20/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: timer for 3D block in frame decoder


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_ARITH.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;

entity frame_decoder_3D_block_timer is
  port (
    clk               : in std_logic;
    rst 	      : in std_logic;
    restart 	      : in std_logic;
    clk_up            : in std_logic;
    sel 	      : in std_logic_vector(1 downto 0);
    num_vertices      : in std_logic_vector(7 downto 0);
    all_vertices_done : out std_logic;
    packet_done       : out std_logic;
    direction_done    : out std_logic
  );
end frame_decoder_3D_block_timer;

architecture behavioral of frame_decoder_3D_block_timer is 
  signal count_byte, next_count_byte : std_logic_vector(4 downto 0);
  signal count_vertices, next_count_vertices : std_logic_vector(4 downto 0);
  signal all_vertices_done_reg, all_vertices_done_reg_next : std_logic;
begin
  regist: process (rst,clk)
    begin
      if (rst = '1') then
        count_byte <= (others => '0');
        count_vertices <= (others => '0');
      elsif (rising_edge(clk)) then
        count_byte <= next_count_byte;
        count_vertices <= next_count_vertices;

        all_vertices_done_reg <= all_vertices_done_reg_next;
      end if;
    end process regist;
--------------------------------------------------------------------
nextstatelogic: process (count_byte, count_vertices,clk_up, num_vertices,restart,sel) 
    begin
      next_count_byte <= count_byte;
      next_count_vertices <= count_vertices;

      if (restart = '1') then
        next_count_byte <= (others => '0');
      elsif (clk_up = '1') then
        next_count_byte <= count_byte + 1;
      end if; 

      if (restart = '1') and (sel = "01") then
	next_count_vertices <= count_vertices + 1;
      end if;

       if ( count_vertices = num_vertices) then 
        all_vertices_done_reg_next <= '1';
      else
        all_vertices_done_reg_next <= '0';
      end if;

  end process nextstatelogic;
--------------------------------------------------------------------
  outputlogic : process(count_byte)
    begin
      if (count_byte = "00110")  then -- count to 6
       packet_done <= '1';
     else
       packet_done <= '0';
     end if;

      if (count_byte = "10010") then -- count to 18
       direction_done <= '1';
     else
       direction_done <= '0';
     end if;

  end process outputlogic;
  all_vertices_done <= all_vertices_done_reg;
end behavioral;


