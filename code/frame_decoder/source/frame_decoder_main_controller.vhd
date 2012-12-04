-- $Id: $
-- File name:   frame_decoder_main_controller.vhd
-- Created:     11/18/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: frame decoder main controller


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_main_controller is
  port (
    clk 	  	  : in std_logic;
    rst 	 	  : in std_logic;
    busy 	          : in std_logic;
    valid_header   	  : in std_logic;
    switch_buffer         : in std_logic;
    frame_received	  : in std_logic;
    system_overrun_error  : in std_logic;  -- overrun error from UART
    send_error            : in std_logic;  -- send error to reset the all system
    failed_frame          : in std_logic;  -- failed frame no frame done
    input_sel 	          : out std_logic;
    reset_error           : out std_logic; -- reset for the error to all over the system
    frame_done 	          : out std_logic
  );
end frame_decoder_main_controller;
architecture behavioral of frame_decoder_main_controller is
  type stateType is (IDLE, CHANGESEL, FRAMEGOT, SWITCHBUFFER,RESET,FAILFRAME);
  signal state,next_state : stateType;
begin
  regist: process (clk,rst,system_overrun_error, next_state, send_error)
    begin
      if (rst = '1') then
        state <= IDLE;
      elsif (clk'event) and (clk = '1') then
        state <= next_state;
        if (system_overrun_error = '1') or (send_error = '1') then
          state <= RESET;
        end if;
      end if;
    end process regist;
------------------------------------------------------------
  nextstatelogic: process(state, valid_header, switch_buffer, frame_received, failed_frame, busy)
    begin
      next_state <= state;
      case state is 
        when IDLE =>
          if (valid_header = '1') and (switch_buffer = '0') then
            next_state <= CHANGESEL;
          elsif (valid_header = '1') and (switch_buffer = '1') then
            next_state <= SWITCHBUFFER;
          else 
            next_state <= IDLE;
          end if;
-------------------------------------------------------------
        when CHANGESEL =>
          if (frame_received = '1') and (failed_frame = '0') then
            next_state <= FRAMEGOT;
          elsif (frame_received = '1') and (failed_frame = '1') then
            next_state <= FAILFRAME;
          else
            next_state <= CHANGESEL;
          end if;
--------------------------------------------------------------
        when FRAMEGOT => 
          if (busy = '0') then
            next_state <= IDLE;
          else
            next_state <=FRAMEGOT;
          end if;
--------------------------------------------------------------
        when FAILFRAME => 
          next_state <= IDLE;
--------------------------------------------------------------
        when SWITCHBUFFER => 
          next_state <= IDLE;
--------------------------------------------------------------
        when RESET => 
          next_state <= IDLE;
--------------------------------------------------------------
        when others => null;
      end case;
    end process nextstatelogic;
---------------------------------------------------------------
  outputlogic: process (state)
  begin
    input_sel <= '0';
    frame_done <= '0';
    reset_error <= '0';
    case state is
      when IDLE =>
        input_sel <= '0';
        frame_done <= '0';
        reset_error <= '0';
----------------------------------------------------------------
      when CHANGESEL =>
        input_sel <= '1';
        frame_done <= '0';
        reset_error <= '0';
----------------------------------------------------------------
      when FRAMEGOT =>
        input_sel <= '0';
        frame_done <= '1';
        reset_error <= '0';
----------------------------------------------------------------
      when FAILFRAME =>
        input_sel <= '0';
        frame_done <= '0';
        reset_error <= '0';
----------------------------------------------------------------
      when SWITCHBUFFER =>
        input_sel <= '0';
        frame_done <= '1';
        reset_error <= '0';
----------------------------------------------------------------
      when RESET =>
        input_sel <= '0';
        frame_done <= '0';
        reset_error <= '1';
----------------------------------------------------------------
      when others => null;
    end case;
  end process outputlogic;
end behavioral;
