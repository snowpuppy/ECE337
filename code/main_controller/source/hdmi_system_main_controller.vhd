-- $Id: $
-- File name:   hdmi_system_main_controller.vhd
-- Created:     11/16/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: HDMI system main controller


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity hdmi_system_main_controller is
  port (
    clk 	     : in std_logic;
    rst 	     : in std_logic;
    data_received    : in std_logic;  -- from the rising edge found of pulse generator
    frame_done       : in std_logic;
    computation_done : in std_logic;
    buffer_switch    : in std_logic;
    write_done       : in std_logic;
    busy 	     : out std_logic;
    read_frame       : out std_logic;
    switch_buffer    : out std_logic
  ); 

end hdmi_system_main_controller;

architecture aaa of hdmi_system_main_controller is
  type stateType is (IDLE,GETFRAME,NULLSTATE1,BUSYSTATE,READFRAME,BUFFERSWITCH,NULLSTATE2,NULLSTATE3,HOLD,SWITCHBUFFER);
  signal state, next_state, state1, next_state1  : stateType;
begin 
  regist: process (clk,rst,next_state)
    begin
      if (rst = '1') then
        state <= IDLE;
      elsif (rising_edge(clk)) then
        state <= next_state;
      end if;
   end process regist;
------------------------------------------------------------
  nextstatelogic: process (state, data_received, frame_done, computation_done, buffer_switch)
  begin 
    next_state <= state;
    case state is
      when IDLE =>
        if (data_received = '1') then
          next_state <= GETFRAME;
        else
          next_state <= IDLE;
        end if;
------------------------------------------------
      when GETFRAME =>
        next_state <= NULLSTATE1;
------------------------------------------------
      when NULLSTATE1 =>
        if ((frame_done = '1') and (computation_done = '0')) then
          next_state <= BUSYSTATE;
        elsif ((frame_done = '1') and (computation_done = '1')) then
          next_state <= READFRAME;
        elsif ((buffer_switch = '1') and (frame_done = '1')) then
          next_state <= BUFFERSWITCH;
        elsif (data_received = '1') then
          next_state <= GETFRAME;
        else
          next_state <= NULLSTATE1;
        end if;
-----------------------------------------------
     when BUSYSTATE =>
       if ((frame_done = '1') and (computation_done = '1')) then
         next_state <= READFRAME;
       else 
         next_state <= BUSYSTATE;
       end if;
-----------------------------------------------
     when READFRAME =>
      next_state <= NULLSTATE2;
-----------------------------------------------
     when BUFFERSWITCH =>
      next_state <= NULLSTATE3;
-----------------------------------------------
     when NULLSTATE2 =>
      next_state <= IDLE;
-----------------------------------------------
     when NULLSTATE3 =>
      next_state <= IDLE;
-----------------------------------------------
     when others => null;
   end case;
  end process nextstatelogic;
-----------------------------------------------
  outputlogic:process (state)
  begin
   busy <= '0';
   read_frame <= '0';
   case state is 
     when IDLE =>
       busy <= '0';
       read_frame <= '0';
-----------------------------------------------
     when GETFRAME =>
       busy <= '0';
       read_frame <= '0';
-----------------------------------------------
     when NULLSTATE1 =>
       busy <= '0';
       read_frame <= '0';
-----------------------------------------------
     when BUSYSTATE =>
       busy <= '1';
       read_frame <= '0';
-----------------------------------------------
     when READFRAME =>
       busy <= '0';
       read_frame <= '1';
-----------------------------------------------
     when BUFFERSWITCH =>
       busy <= '0';
       read_frame <= '0';
-----------------------------------------------
     when NULLSTATE2 =>
       busy <= '0';
       read_frame <= '0';
-----------------------------------------------
     when NULLSTATE3 =>
       busy <= '0';
       read_frame <= '0';
-----------------------------------------------
     when others => null;
   end case;
 end process outputlogic;

----------------------------------------------------------------------
regist1: process (clk,rst,next_state1)
    begin
      if (rst = '1') then
        state1 <= IDLE;
      elsif (rising_edge(clk)) then
        state1 <= next_state1;
      end if;
   end process regist1;
------------------------------------------------------------
  nextstatelogic1: process (state1, buffer_switch, write_done)
  begin 
    next_state1 <= state1;
    case state is
      when IDLE =>
        if (buffer_switch = '1') then
          next_state1 <= HOLD;
        else
          next_state1 <= IDLE;
        end if;
------------------------------------------------
      when HOLD =>
        if (write_done = '1') then
          next_state1 <= SWITCHBUFFER;
        else 
          next_state1 <= HOLD;
        end if;
------------------------------------------------
      when SWITCHBUFFER =>
        next_state1 <= IDLE;
------------------------------------------------
     when others => null;
   end case;
  end process nextstatelogic1;
-----------------------------------------------
  outputlogic1:process (state1)
  begin
    switch_buffer <= '0';
   case state is 
     when IDLE =>
       switch_buffer <= '0';
-----------------------------------------------
     when HOLD =>
       switch_buffer <= '0';
-----------------------------------------------
     when SWITCHBUFFER =>
       switch_buffer <= '1';
-----------------------------------------------
     when others => null;
   end case;
 end process outputlogic1;
----------------------------------------------------------------------
end aaa;

         
















 
       
