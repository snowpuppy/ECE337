-- $Id: $
-- File name:   frame_decoder_2D3_clk_in_main_controller.vhd
-- Created:     11/23/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 2D3 clk in main controller from data read to inner main controller


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_2D3_clk_in_main_controller is
  port (
    clk 	   : in std_logic;
    rst 	   : in std_logic;
    input_sel      : in std_logic;
    reset_error    : in std_logic; 
    data_read      : in std_logic;
    control        : in std_logic_vector(2 downto 0);
    clk_in 	   : out std_logic
  );

end frame_decoder_2D3_clk_in_main_controller;

architecture behavioral of frame_decoder_2D3_clk_in_main_controller is
  type stateType is (IDLE, COLOR1, NULLSTATE1, COLOR2, NULLSTATE2, COLOR3, NULLSTATE3);
  signal state, next_state : stateType;
begin
  regist: process ( clk, rst, next_state, reset_error)
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
  nextstatelogic: process (state, control, data_read,input_sel)
  begin
    next_state <= state;
    case state is 
      when IDLE =>
        if (input_sel = '1') and (control = "100") and (data_read = '1') then
          next_state <= COLOR1;
        else
          next_state <= IDLE;
        end if;
------------------------------------------------------------------------------------------
      when COLOR1 => 
        next_state <= NULLSTATE1;
------------------------------------------------------------------------------------------
      when NULLSTATE1 =>
        if (input_sel = '1') and (control = "100") and (data_read = '1') then
          next_state <= COLOR2;
        else 
          next_state <= NULLSTATE1;
        end if;
------------------------------------------------------------------------------------------
      when COLOR2 => 
        next_state <= NULLSTATE2;
------------------------------------------------------------------------------------------
      when NULLSTATE2 =>
        if (input_sel = '1') and (control = "100") and (data_read = '1') then
          next_state <= COLOR3; 
        else 
          next_state <= NULLSTATE2;
        end if;
------------------------------------------------------------------------------------------
      when COLOR3 => 
        next_state <= NULLSTATE3;
------------------------------------------------------------------------------------------
      when NULLSTATE3 =>
          next_state <= IDLE;
------------------------------------------------------------------------------------------
    when others => null;
  end case;
end process nextstatelogic;
------------------------------------------------------------------------------------------
   outputlogic: process (state)
     begin
       clk_in <= '0';
      case state is
        when IDLE =>
          clk_in <= '0';
------------------------------------------------------------------------------------------
        when COLOR1 =>
          clk_in <= '1';
------------------------------------------------------------------------------------------
        when NULLSTATE1 =>
          clk_in <= '0';         
------------------------------------------------------------------------------------------
        when COLOR2 =>
          clk_in <= '1';
------------------------------------------------------------------------------------------
        when NULLSTATE2 =>
          clk_in <= '0';
------------------------------------------------------------------------------------------
        when COLOR3 =>
          clk_in <= '1';       
------------------------------------------------------------------------------------------
        when NULLSTATE3 =>
          clk_in <= '0';      
------------------------------------------------------------------------------------------
        when others => null;
      end case;
    end process outputlogic;       
end behavioral;
