-- $Id: $
-- File name:   frame_decoder_header_main_controller.vhd
-- Created:     11/18/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: frame decoder header main controller


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_header_main_controller is
  port (
    clk 	    : in std_logic;
    rst 	    : in std_logic;
    data_read 	    : in std_logic;
    input_sel       : in std_logic;
    control_correct : in std_logic;
    num_correct     : in std_logic; 
    move_buffer     : in std_logic;   
    frame_done 	    : in std_logic;
    reset_error     : in std_logic; 
    control_clk_in  : out std_logic;
    num_clk_in      : out std_logic;
    switch_buffer   : out std_logic;
    valid_header    : out std_logic
  );
end frame_decoder_header_main_controller;

architecture behavioral of frame_decoder_header_main_controller is
  type stateType is (IDLE, CONTROLCLK, NULLSTATE1, NUMCLK,NULLSTATE3, WAITING1,WAITING2);
  signal state, next_state : stateType;
begin 
  regist: process ( clk, rst, next_state,reset_error)
 begin
    if (rst = '1') then 
      state <= IDLE;
    elsif (rising_edge(clk)) then
      state <= next_state;
      if (reset_error = '1') then
        state <= IDLE;
      end if;
    end if;
  end process regist;
----------------------------------------------------------------------
   nextstatelogic: process (state, data_read, control_correct, num_correct, frame_done, move_buffer, input_sel)
     begin
       next_state <= state;
       case state is 
         when IDLE =>
           if (data_read = '1') and (input_sel = '0') then
             next_state <= CONTROLCLK;
           else
             next_state <= IDLE;
           end if;
----------------------------------------------------------------------
         when CONTROLCLK => 
           next_state <= NULLSTATE1;
----------------------------------------------------------------------
         when NULLSTATE1 =>
           if (data_read = '1') then
             next_state <= NUMCLK;
           else
             next_state <= NULLSTATE1;
           end if;
----------------------------------------------------------------------
         when NUMCLK =>
           next_state <= NULLSTATE3;
----------------------------------------------------------------------
         when NULLSTATE3 =>
           if (control_correct = '0') or (num_correct = '0') then
             next_state <= IDLE;
           elsif ( control_correct = '1') and (num_correct = '1') and (move_buffer = '0') then --no buffer switch
             next_state <= WAITING1;
           elsif ( control_correct = '1') and (num_correct = '1') and (move_buffer = '1') then --with buffer switch
             next_state <= WAITING2;
           else
             next_state <= NULLSTATE3;
           end if;
----------------------------------------------------------------------
         when WAITING1 =>
           if (frame_done = '1') then
             next_state <= IDLE;
           else
             next_state <= WAITING1;
           end if;
---------------------------------------------------------------------
         when WAITING2 =>
           if (frame_done = '1') then
             next_state <= IDLE;
           else
             next_state <= WAITING2;
          end if;
----------------------------------------------------------------------
         when others => null;
       end case;
     end process nextstatelogic;
----------------------------------------------------------------------
  outputlogic: process (state)
    begin
      control_clk_in <= '0';
      num_clk_in     <= '0';
      valid_header   <= '0';
      switch_buffer  <= '0';
      case state is 
        when IDLE => 
     	  control_clk_in <= '0';
          num_clk_in     <= '0';
          valid_header   <= '0';
          switch_buffer  <= '0';
----------------------------------------------------------------------
        when CONTROLCLK => 
     	  control_clk_in <= '1';
          num_clk_in     <= '0';
          valid_header   <= '0';
          switch_buffer  <= '0';
----------------------------------------------------------------------
        when NULLSTATE1 => 
     	  control_clk_in <= '0';
          num_clk_in     <= '0';
          valid_header   <= '0';
          switch_buffer  <= '0';
----------------------------------------------------------------------
        when NUMCLK => 
     	  control_clk_in <= '0';
          num_clk_in     <= '1';
          valid_header   <= '0';
          switch_buffer  <= '0';
----------------------------------------------------------------------
        when NULLSTATE3 => 
     	  control_clk_in <= '0';
          num_clk_in     <= '0';
          valid_header   <= '0';
          switch_buffer  <= '0';
----------------------------------------------------------------------
        when WAITING1 => 
     	  control_clk_in <= '0';
          num_clk_in     <= '0';
          valid_header   <= '1';
          switch_buffer  <= '0';
----------------------------------------------------------------------
        when WAITING2 => 
     	  control_clk_in <= '0';
          num_clk_in     <= '0';
          valid_header   <= '1';
          switch_buffer  <= '1';
----------------------------------------------------------------------
        when others => null;
      end case;
    end process outputlogic;
  end behavioral;






