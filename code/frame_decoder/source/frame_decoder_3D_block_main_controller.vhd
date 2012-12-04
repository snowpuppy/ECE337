-- $Id: $
-- File name:   frame_decoder_3D_block_main_controller.vhd
-- Created:     11/20/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 3D block main controller


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_3D_block_main_controller is
  port ( 
    clk               : in std_logic;
    rst               : in std_logic;
    data_read         : in std_logic;
    input_sel         : in std_logic;
    packet_done       : in std_logic;
    all_vertices_done : in std_logic;
    direction_done    : in std_logic;
    reset_error       : in std_logic; 
    control           : in std_logic_vector(2 downto 0);
    restart           : out std_logic;
    clk_up            : out std_logic;
    clk_in_color      : out std_logic;
    clk_in_connection : out std_logic;
    sel               : out std_logic_vector(1 downto 0)
  );

end frame_decoder_3D_block_main_controller;

architecture behavioral of frame_decoder_3D_block_main_controller is
  type stateType is (IDLE, COLOR1, NULLSTATE1, COLOR2, NULLSTATE2, COLOR3, NULLSTATE3, SENDDIRECTION, NULLSTATE4, NULLSTATE5, CONNECTION1, NULLSTATE6, CONNECTION2, NULLSTATE7, SENDDATA, NULLSTATE8, NULLSTATE9,IDENTIFY);
 -- senddirection = send sin,cos,offset
 -- senddata = send each point
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
  nextstatelogic: process (data_read, input_sel, packet_done, all_vertices_done, direction_done, control, state)
  begin
    next_state <= state;
    case state is 
      when IDLE =>
        if (data_read = '1') and (control = "001") and (input_sel = '1') then
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
        if (data_read = '1') then
          next_state <= SENDDIRECTION;
        else 
          next_state <= NULLSTATE3;
        end if;
------------------------------------------------------------------------------------------
      when SENDDIRECTION =>
          next_state <= NULLSTATE4;
------------------------------------------------------------------------------------------
      when NULLSTATE4 =>
        if ( direction_done = '1') then
          next_state <= NULLSTATE5;
        elsif (data_read = '1') then
          next_state <= SENDDIRECTION;
        else
          next_state <= NULLSTATE4;
        end if;
------------------------------------------------------------------------------------------
     when NULLSTATE5 => 
       if (data_read = '1') then
         next_state <= CONNECTION1;
       else 
         next_state <= NULLSTATE5;
       end if;
------------------------------------------------------------------------------------------
     when CONNECTION1 => 
       next_state <= NULLSTATE6;
------------------------------------------------------------------------------------------
     when NULLSTATE6 =>
       if (data_read = '1') then
         next_state <= CONNECTION2;
       else
         next_state <= NULLSTATE6;
       end if;
------------------------------------------------------------------------------------------
    when CONNECTION2 => 
      next_state <= NULLSTATE7;
------------------------------------------------------------------------------------------
    when NULLSTATE7 =>
      if (data_read = '1') then 
        next_state <= SENDDATA;
      else 
        next_state <= NULLSTATE7;
      end if;
------------------------------------------------------------------------------------------
    when SENDDATA =>
        next_state <= NULLSTATE8;
------------------------------------------------------------------------------------------
    when NULLSTATE8 =>
      if ( packet_done = '1') then
        next_state <= IDENTIFY;
      elsif ( data_read = '1') then
        next_state <= SENDDATA;
      else
        next_state <= NULLSTATE8;
      end if;
------------------------------------------------------------------------------------------
    when IDENTIFY =>
        next_state <= NULLSTATE9;
------------------------------------------------------------------------------------------
    when NULLSTATE9 => 
      if ( all_vertices_done = '1') then
        next_state <= IDLE;
      else 
        next_state <= NULLSTATE5;
      end if;
------------------------------------------------------------------------------------------
    when others => null;
  end case;
end process nextstatelogic;
------------------------------------------------------------------------------------------
   outputlogic: process (state)
     begin
      sel <= "11";
      clk_in_color <= '0';
      clk_in_connection <= '0';
      clk_up <= '0';
      restart <= '0';
      case state is
        when IDLE =>
          sel <= "11";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '1';
------------------------------------------------------------------------------------------
        when COLOR1 =>
          sel <= "10";
          clk_in_color <= '1';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE1 =>
          sel <= "10";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when COLOR2 =>
          sel <= "10";
          clk_in_color <= '1';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE2 =>
          sel <= "10";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when COLOR3 =>
          sel <= "10";
          clk_in_color <= '1';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE3 =>
          sel <= "01";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when SENDDIRECTION =>
          sel <= "01";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '1';
          restart <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE4 =>
          sel <= "01";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE5 =>
          sel <= "00";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '1';
------------------------------------------------------------------------------------------
        when CONNECTION1 =>
          sel <= "00";
          clk_in_color <= '0';
          clk_in_connection <= '1';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE6 =>
          sel <= "00";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when CONNECTION2 =>
          sel <= "00";
          clk_in_color <= '0';
          clk_in_connection <= '1';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE7 =>
          sel <= "01";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when SENDDATA =>
          sel <= "01";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '1';
          restart <= '0';
------------------------------------------------------------------------------------------
        when NULLSTATE8 =>
          sel <= "01";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when IDENTIFY =>
          sel <= "01";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '1';
------------------------------------------------------------------------------------------
        when NULLSTATE9 =>
          sel <= "11";
          clk_in_color <= '0';
          clk_in_connection <= '0';
          clk_up <= '0';
          restart <= '0';
------------------------------------------------------------------------------------------
        when others => null;
      end case;
    end process outputlogic;       
end behavioral;
