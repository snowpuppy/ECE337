-- $Id: $
-- File name:   frame_decoder_2D3_main_controller.vhd
-- Created:     11/23/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 2D3 main controller block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_2D3_main_controller is
  port (
    clk 	      : in std_logic;
    rst 	      : in std_logic;
    reset_error       : in std_logic; 
    threed_clk_in     : in std_logic;
    twodonetwo_clk_in : in std_logic;
    twodthree_clk_in  : in std_logic;
    data_done         : in std_logic; --data done signal from 48 to 756 
    twodonetwo_block_sel : in std_logic;
    threed_block_sel     : in std_logic_vector(1 downto 0);
    control              : in std_logic_vector(2 downto 0);
    clk_sr            : out std_logic;
    done 	      : out std_logic
  );

end frame_decoder_2D3_main_controller;

architecture behavioral of frame_decoder_2D3_main_controller is
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
  nextstatelogic: process (state, twodonetwo_clk_in, threed_clk_in, twodthree_clk_in, data_done, control, twodonetwo_block_sel, threed_block_sel)
  begin
    next_state <= state;
    case state is 
      when IDLE =>
        if (twodonetwo_clk_in = '1') and (control = "010") and (twodonetwo_block_sel = '1') then 
          next_state <= COLOR1;
        elsif (twodonetwo_clk_in = '1') and (control = "011") and (twodonetwo_block_sel = '1') then
          next_state <= COLOR1;
	elsif (threed_clk_in = '1') and (control = "001") and (threed_block_sel = "10") then
          next_state <= COLOR1;
        elsif (twodthree_clk_in = '1') and (control = "100") then
          next_state <= COLOR1;
	else
          next_state <= IDLE;
        end if;
------------------------------------------------------------------------------------------
      when COLOR1 => 
        next_state <= NULLSTATE1;
------------------------------------------------------------------------------------------
      when NULLSTATE1 =>
        if (twodonetwo_clk_in = '1') and (control = "010") and (twodonetwo_block_sel = '1') then 
          next_state <= COLOR2;
        elsif (twodonetwo_clk_in = '1') and (control = "011") and (twodonetwo_block_sel = '1') then
          next_state <= COLOR2;
	elsif (threed_clk_in = '1') and (control = "001") and (threed_block_sel = "10") then
          next_state <= COLOR2;
        elsif (twodthree_clk_in = '1') and (control = "100") then
          next_state <= COLOR2;
	else
          next_state <= NULLSTATE1;
        end if;
------------------------------------------------------------------------------------------
      when COLOR2 => 
        next_state <= NULLSTATE2;
------------------------------------------------------------------------------------------
      when NULLSTATE2 =>
        if (twodonetwo_clk_in = '1') and (control = "010") and (twodonetwo_block_sel = '1') then 
          next_state <= COLOR3;
        elsif (twodonetwo_clk_in = '1') and (control = "011") and (twodonetwo_block_sel = '1') then
          next_state <= COLOR3;
	elsif (threed_clk_in = '1') and (control = "001") and (threed_block_sel = "10") then
          next_state <= COLOR3;
        elsif (twodthree_clk_in = '1') and (control = "100") then
          next_state <= COLOR3;
	else
          next_state <= NULLSTATE2;
        end if;
------------------------------------------------------------------------------------------
      when COLOR3 => 
        next_state <= NULLSTATE3;
------------------------------------------------------------------------------------------
      when NULLSTATE3 =>
        if (data_done = '1') and (control = "001") then
          next_state <= IDLE; 
	elsif (data_done = '1') and (control = "010") then
          next_state <= IDLE; 
	elsif (data_done = '1') and (control = "011") then
          next_state <= IDLE; 
	elsif (control = "100") then
          next_state <= IDLE; 
        else 
          next_state <= NULLSTATE3;
        end if;
------------------------------------------------------------------------------------------
    when others => null;
  end case;
end process nextstatelogic;
------------------------------------------------------------------------------------------
   outputlogic: process (state)
     begin
       done <= '0';
       clk_sr <= '0';
      case state is
        when IDLE =>
          done <= '0';
          clk_sr <= '0';
------------------------------------------------------------------------------------------
        when COLOR1 =>
          done <= '0';
          clk_sr <= '1';
------------------------------------------------------------------------------------------
        when NULLSTATE1 =>
          done <= '0';    
          clk_sr <= '0';     
------------------------------------------------------------------------------------------
        when COLOR2 =>
          done <= '0';
          clk_sr <= '1';
------------------------------------------------------------------------------------------
        when NULLSTATE2 =>
          done <= '0';
          clk_sr <= '0';
------------------------------------------------------------------------------------------
        when COLOR3 =>
          done <= '0'; 
          clk_sr <= '1';      
------------------------------------------------------------------------------------------
        when NULLSTATE3 =>
          done <= '1';  
          clk_sr <= '0';    
------------------------------------------------------------------------------------------
        when others => null;
      end case;
    end process outputlogic;       
end behavioral;
