-- $Id: $
-- File name:   frame_decoder_2D12_main_controller.vhd
-- Created:     11/20/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 2D1/2 block main controller


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_2D12_main_controller is
  port (
    clk 	   : in std_logic;
    rst 	   : in std_logic;
    data_read      : in std_logic;
    input_sel      : in std_logic;
    six_assert     : in std_logic;
    reset_error    : in std_logic; 
    control 	   : in std_logic_vector(2 downto 0);
    concat         : out std_logic;
    sel            : out std_logic;
    clk_in_color   : out std_logic;
    clk_in_packet  : out std_logic;
    ready2 	   : out std_logic;
    restart 	   : out std_logic;
    clk_up 	   : out std_logic
  );

end frame_decoder_2D12_main_controller;

architecture behavioral of frame_decoder_2D12_main_controller is
  type stateType is (IDLE, COLOR1, NULLSTATE1, COLOR2, NULLSTATE2, COLOR3, NULLSTATE3, PACKETIN1, NULLSTATE4, READY, PACKETIN2, NULLSTATE5, CONCACT, READY1,NULLSTATE6,NULLSTATE7);
  signal state, next_state : stateType;
begin 
  regist: process ( clk, rst, reset_error, next_state)
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
------------------------------------------------------------------------------------------
   nextstatelogic: process (state, data_read, input_sel, six_assert,control)
     begin
       next_state <= state;
       case state is 
         when IDLE =>
           if (input_sel = '1') and (control = "010") and (data_read = '1') then
             next_state <= COLOR1;
           elsif (input_sel = '1') and (control = "011") and (data_read = '1') then
             next_state <= COLOR1;
           else
             next_state <= IDLE;
           end if;
------------------------------------------------------------------------------------------
        when COLOR1 =>
          next_state <= NULLSTATE1;
------------------------------------------------------------------------------------------
        when NULLSTATE1 => 
          if (data_read = '1') then
            next_state <= COLOR2;
          else 
            next_state <= NULLSTATE1;
          end if;
------------------------------------------------------------------------------------------
        when COLOR2 => 
          next_state <= NULLSTATE2;
------------------------------------------------------------------------------------------
        when NULLSTATE2 =>
          if (data_read = '1') then 
            next_state <= COLOR3;
          else 
            next_state <= NULLSTATE2;
          end if;
------------------------------------------------------------------------------------------
        when COLOR3 => 
          next_state <= NULLSTATE3;
------------------------------------------------------------------------------------------
        when NULLSTATE3 => 
          if ( data_read = '1') then
            next_state <= PACKETIN1;
          else 
            next_state <= NULLSTATE3;
          end if;
------------------------------------------------------------------------------------------
        when PACKETIN1 =>
            next_state <= NULLSTATE4;
------------------------------------------------------------------------------------------
        when NULLSTATE4 =>
          if (six_assert = '1') then
            next_state <= READY;
          elsif ( data_read = '1') then
	    next_state <= PACKETIN1;
	  else
            next_state <= NULLSTATE4;
          end if;
------------------------------------------------------------------------------------------
        when READY => 
          next_state <= NULLSTATE6;
------------------------------------------------------------------------------------------
        when NULLSTATE6 =>
          if (data_read = '1') then
            next_state <= PACKETIN2;
          else
            next_state <= NULLSTATE6;
          end if;
------------------------------------------------------------------------------------------
        when PACKETIN2 =>
            next_state <= NULLSTATE5;
------------------------------------------------------------------------------------------
        when NULLSTATE5 =>
          if (data_read = '1') then
            next_state <= CONCACT;
          else
            next_state <= NULLSTATE5;
          end if;
-------------------------------------------------------------------------------------------
        --when PACKETIN3 =>
        --    next_state <= CONCACT;
------------------------------------------------------------------------------------------
        when CONCACT => 
          next_state <= READY1;
------------------------------------------------------------------------------------------
        when NULLSTATE7 =>
           next_state <= READY1;
------------------------------------------------------------------------------------------
        when READY1 =>
          next_state <= IDLE;
------------------------------------------------------------------------------------------
        when others => null;
      end case;
    end process nextstatelogic;
------------------------------------------------------------------------------------------
    outputlogic: process (state)
      begin
      concat <= '0';        
      sel <= '0';
      clk_in_color <= '0'; 
      clk_in_packet <= '0';
      ready2 <= '0';	   
      restart <= '0';	   
      clk_up <= '0';
      case state is
        when IDLE => 	  
          concat <= '0';        
          sel <= '0';
          clk_in_color <= '0'; 
          clk_in_packet <= '0';
          ready2 <= '0';	   
          restart <= '1';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when COLOR1 => 	  
          concat <= '0';        
          sel <= '1';
          clk_in_color <= '1'; 
          clk_in_packet <= '0';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE1 => 	  
          concat <= '0';        
          sel <= '1';
          clk_in_color <= '0'; 
          clk_in_packet <= '0';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when COLOR2 => 	  
          concat <= '0';        
          sel <= '1';
          clk_in_color <= '1'; 
          clk_in_packet <= '0';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE2 => 	  
          concat <= '0';        
          sel <= '1';
          clk_in_color <= '0'; 
          clk_in_packet <= '0';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when COLOR3 => 	  
          concat <= '0';        
          sel <= '1';
          clk_in_color <= '1'; 
          clk_in_packet <= '0';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE3 => 	  
          concat <= '0';        
          sel <= '1';
          clk_in_color <= '0'; 
          clk_in_packet <= '0';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE6 => 	  
          concat <= '0';        
          sel <= '0';
          clk_in_color <= '0'; 
          clk_in_packet <= '0';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when PACKETIN1 => 	  
          concat <= '0';        
          sel <= '0';
          clk_in_color <= '0'; 
          clk_in_packet <= '1';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '1';
------------------------------------------------------------------------------------------
        when NULLSTATE4 => 	  
          concat <= '0';        
          sel <= '0';
          clk_in_color <= '0'; 
          clk_in_packet <= '0';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when READY => 	  
          concat <= '0';        
          sel <= '0';
          clk_in_color <= '0'; 
          clk_in_packet <= '0';
          ready2 <= '1';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when PACKETIN2 => 	  
          concat <= '0';        
          sel <= '0';
          clk_in_color <= '0'; 
          clk_in_packet <= '1';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE5 => 	  
          concat <= '0';        
          sel <= '0';
          clk_in_color <= '0'; 
          clk_in_packet <= '0';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
       -- when PACKETIN3 => 	  
        --  concat <= '0';        
       --   sel <= '0';
        --  clk_in_color <= '0'; 
        --  clk_in_packet <= '1';
        --  ready2 <= '0';	   
        --  restart <= '0';	   
        --  clk_up <= '0';
------------------------------------------------------------------------------------------
        when CONCACT => 	  
          concat <= '1';        
          sel <= '0';
          clk_in_color <= '0'; 
          clk_in_packet <= '1';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when READY1 => 	  
          concat <= '0';        
          sel <= '0';
          clk_in_color <= '0'; 
          clk_in_packet <= '0';
          ready2 <= '1';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE7 => 	  
          concat <= '0';        
          sel <= '0';
          clk_in_color <= '0'; 
          clk_in_packet <= '0';
          ready2 <= '0';	   
          restart <= '0';	   
          clk_up <= '0';
------------------------------------------------------------------------------------------
        when others => null;
      end case;
    end process outputlogic;
end behavioral;
