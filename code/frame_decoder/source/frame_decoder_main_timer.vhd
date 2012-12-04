-- $Id: $
-- File name:   frame_decoder_main_timer.vhd
-- Created:     11/20/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: frame decoder main timer


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_ARITH.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;

entity frame_decoder_main_timer is
  port (
    clk                      : in std_logic;
    rst 	                   : in std_logic; 
    throw_frame 	           : in std_logic;
    body_parsed              : in std_logic;
    data_ready               : in std_logic;
    valid_header   	         : in std_logic;
    system_framing_error     : in std_logic;
    control                  : in std_logic_vector(2 downto 0);
    num_byte                 : in std_logic_vector(7 downto 0);
    data_read                : out std_logic;
    frame_received           : out std_logic;
    failed_frame             : out std_logic;   -- frame does not received
    send_error               : out std_logic   -- reset
  );
end frame_decoder_main_timer;

architecture behavioral of frame_decoder_main_timer is
  signal count_byte, next_count_byte : std_logic_vector(7 downto 0);
  signal data_read_reg, data_read_reg_next : std_logic;
  signal frame_received_reg, frame_received_reg_next : std_logic;
  signal send_error_reg, send_error_reg_next : std_logic;
  signal failed_frame_reg, failed_frame_reg_next : std_logic;
  signal wait_reg, wait_reg_next : std_logic;
begin
  regist: process (rst,clk,next_count_byte)
    begin
      if (rst = '1') then
        count_byte <= (others => '0');
        frame_received_reg <= '0';
        data_read_reg <= '0';
        failed_frame_reg <= '0'; 
        wait_reg <= '0';
      elsif (clk'event) and (clk = '1') then
	      count_byte <= next_count_byte;
        frame_received_reg <= frame_received_reg_next;
        data_read_reg <= data_read_reg_next; 
      	failed_frame_reg <= failed_frame_reg_next;
        wait_reg <= wait_reg_next;
      end if;
    end process regist;
--------------------------------------------------------------------
nextstatelogic: process (count_byte, body_parsed, data_ready, num_byte, system_framing_error, throw_frame, wait_reg, data_read_reg_next,control,frame_received_reg,valid_header) 
    begin
      next_count_byte <= count_byte;
--------------------------------------------------------------------
      if ( count_byte = num_byte) and (body_parsed = '1') and (control = "001") then 
        frame_received_reg_next <= '1';
      elsif (count_byte = num_byte) and ( control = "010") then
        frame_received_reg_next <= '1';
      elsif (count_byte = num_byte) and ( control = "011") then
        frame_received_reg_next <= '1';
      elsif (count_byte = num_byte) and ( control = "100") then
        frame_received_reg_next <= '1';
      else 
        frame_received_reg_next <= '0';
      end if;
--------------------------------------------------------------------
     if (frame_received_reg = '1') then
       next_count_byte <= "00000000";
     elsif (data_ready = '1') and (valid_header = '1')then
        next_count_byte <= count_byte + 1;
     else
      next_count_byte <= count_byte;
     end if;   

     if (data_ready = '1') then
       data_read_reg_next  <= '1';
     else
        data_read_reg_next <= '0';
     end if;

--------------------------------------------------------------------
      if (throw_frame = '1') and (count_byte = num_byte)  then
        failed_frame_reg_next <= '1'; --send no frame received to main controller
      else
        failed_frame_reg_next <= '0';
      end if;

      if (system_framing_error = '1') and not(count_byte = num_byte) then
        send_error_reg_next <= '1';
      elsif (throw_frame = '1') and not (count_byte = num_byte) then
        send_error_reg_next <= '1';
      elsif (wait_reg = '1') and (data_read_reg_next = '1') then
        send_error_reg_next <= '1';
      else
        send_error_reg_next <= '0';
      end if;

      if (system_framing_error = '1') and (count_byte = num_byte)  then
        wait_reg_next <= '1';
      else
        wait_reg_next <= '0';
      end if;



--------------------------------------------------------------------
  end process nextstatelogic;
--------------------------------------------------------------------
  frame_received <= frame_received_reg;
  data_read <= data_read_reg; 

  failed_frame <= failed_frame_reg;
  send_error <= send_error_reg;
end behavioral;
