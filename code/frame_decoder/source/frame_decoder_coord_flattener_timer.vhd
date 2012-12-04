-- $Id: $
-- File name:   frame_decoder_coord_flattener_timer.vhd
-- Created:     11/18/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: frame decoder coordinate flattener timer


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_ARITH.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;

entity frame_decoder_coord_flattener_timer is
  port (
    clk               : in std_logic;
    rst 	      : in std_logic;
    restart 	      : in std_logic;
    clk_up            : in std_logic;
    restart_vertices  : in std_logic;
    done_one_vertices : in std_logic;
    num_vertices      : in std_logic_vector(7 downto 0);
    all_vertices_done : out std_logic;
    xstart            : out std_logic;
    ystart            : out std_logic;
    zstart            : out std_logic;
    packet_received   : out std_logic
  );
end frame_decoder_coord_flattener_timer;

architecture behavioral of frame_decoder_coord_flattener_timer is
  signal count_byte,next_count_byte : std_logic_vector(3 downto 0);
  signal count_vertices, next_count_vertices : std_logic_vector(4 downto 0);
  signal all_vertices_done_reg, all_vertices_done_reg_next : std_logic;
begin
  regist: process (rst,clk)
    begin
      if (rst = '1') then
        count_byte <= (others => '0');
        count_vertices <= (others => '0');
        all_vertices_done_reg <= '0';
      elsif (rising_edge(clk)) then
        count_byte <= next_count_byte;
        count_vertices <= next_count_vertices;
        all_vertices_done_reg <= all_vertices_done_reg_next;
      end if;
    end process regist;
--------------------------------------------------------------------
  nextstatelogic: process (count_byte, count_vertices,clk_up,num_vertices, restart, restart_vertices, done_one_vertices) 
    begin 
      next_count_byte <= count_byte;
      next_count_vertices <= count_vertices;
      
      if (restart = '1') then
        next_count_byte <= (others => '0');
      elsif (clk_up = '1') then
        next_count_byte <= count_byte + 1;
      end if;

      if (restart_vertices = '1') then
	next_count_vertices <= (others => '0');
      elsif (done_one_vertices = '1') then
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
      if (count_byte = "0000") then -- count to 1
       xstart <= '1';
      else
       xstart <= '0';
      end if;
--------------------------------------------------------------------  
      if (count_byte = "0010") then -- count to 3
       ystart <= '1';
      else
       ystart <= '0';
      end if;
--------------------------------------------------------------------  
      if (count_byte = "0100") then -- count to 5
       zstart <= '1';
      else
       zstart <= '0';
      end if;
--------------------------------------------------------------------  
     if (count_byte = "0110") then -- count to 6
       packet_received <= '1';
     else
       packet_received <= '0';
     end if;
   end process outputlogic;
   all_vertices_done <= all_vertices_done_reg;
end  behavioral;
