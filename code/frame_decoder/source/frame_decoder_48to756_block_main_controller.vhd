-- $Id: $
-- File name:   frame_decoder_48to756_block_main_controller.vhd
-- Created:     11/23/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 48 to 756 shift register block controller


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_48to756_block_main_controller is
  port (
    clk 	   : in std_logic;
    rst 	   : in std_logic;
    done_transfer  : in std_logic;
    threed_ready   : in std_logic;
    twod_ready     : in std_logic;
    reset_error    : in std_logic; 
    control        : in std_logic_vector(2 downto 0);
    done 	   : out std_logic;
    count_up       : out std_logic;
    clk_in_sr 	   : out std_logic;
    restart        : out std_logic
  );
end frame_decoder_48to756_block_main_controller;

architecture behavioral of frame_decoder_48to756_block_main_controller is
  type stateType is (IDLE, DATATRANSFER, NULLSTATE, DONETRANSFER);
  signal state,next_state : stateType;
begin
  regist: process (clk,rst,reset_error, next_state)
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
------------------------------------------------------------------
  nextstatelogic: process(state, done_transfer, threed_ready, twod_ready, control)
    begin
      next_state <= state;
      case state is 
        when IDLE =>
          if (control = "001") and (threed_ready = '1')  then
            next_state <= DATATRANSFER;
          elsif (control = "010") and (twod_ready = '1') then
            next_state <= DATATRANSFER;
          elsif (control = "011") and (twod_ready = '1') then
            next_state <= DATATRANSFER;
          else
            next_state <= IDLE;
          end if;
------------------------------------------------------------
        when DATATRANSFER =>
            next_state <= NULLSTATE;
--------------------------------------------------------------
        when NULLSTATE => 
          if (done_transfer = '1') then
            next_state <= DONETRANSFER;
          elsif (control = "001") and (threed_ready = '1')  then
            next_state <= DATATRANSFER;
          elsif  (control = "010") and (twod_ready = '1') then
            next_state <= DATATRANSFER;
          elsif  (control = "011") and (twod_ready = '1') then
            next_state <= DATATRANSFER;
          else
            next_state <= NULLSTATE;
          end if;
--------------------------------------------------------------
        when DONETRANSFER => 
          next_state <= IDLE;
--------------------------------------------------------------
        when others => null;
      end case;
    end process nextstatelogic;
---------------------------------------------------------------
  outputlogic: process (state)
  begin
    done <= '0';
    count_up <= '0';      
    clk_in_sr <= '0'; 
    restart <= '0';	  
    case state is
      when IDLE =>
        done <= '0';
        count_up <= '0';      
        clk_in_sr <= '0';
        restart <= '1'; 	
----------------------------------------------------------------
      when DATATRANSFER =>
        done <= '0';
        count_up <= '1';      
        clk_in_sr <= '1'; 
        restart <= '0'; 
----------------------------------------------------------------
      when NULLSTATE =>
        done <= '0';
        count_up <= '0';      
        clk_in_sr <= '0'; 
        restart <= '0'; 
----------------------------------------------------------------
      when DONETRANSFER =>
        done <= '1';
        count_up <= '0';      
        clk_in_sr <= '0';
        restart <= '0';  
----------------------------------------------------------------
      when others => null;
    end case;
  end process outputlogic;
end behavioral;

