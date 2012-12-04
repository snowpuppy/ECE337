-- $Id: $
-- File name:   frame_decoder_coord_flattener_main_controller.vhd
-- Created:     11/18/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: coorindate flattener main controller


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_coord_flattener_main_controller is
  port (
    clk 	      : in std_logic;
    rst 	      : in std_logic;
    done 	      : in std_logic;
    data_read 	      : in std_logic;
    reset_error       : in std_logic; 
    packet_received   : in std_logic;
    all_vertices_done : in std_logic;
    data_wrong        : in std_logic; 
    error_z           : in std_logic;
    threed_enable     : in std_logic_vector(1 downto 0);
    clk_up            : out std_logic;
    restart           : out std_logic;
    start_divide      : out std_logic;
    ready1            : out std_logic; 
    throw_frame       : out std_logic;
    restart_vertices  : out std_logic;
    done_one_vertices : out std_logic;
    clk_sr            : out std_logic_vector(3 downto 0);
    enable            : out std_logic_vector(3 downto 0)
  );
end frame_decoder_coord_flattener_main_controller; 

architecture behavioral of frame_decoder_coord_flattener_main_controller is
  type stateType is (IDLE, SINE, NULLSTATE1,TRANSIT1, COSINE, NULLSTATE2, TRANSIT2, OFFSET,NULLSTATE3, TRANSIT3, POINT, NULLSTATE4, NULLSTATE5, NULLSTATE6, NULLSTATE7, NULLSTATE8, NULLSTATE9,NULLSTATE10, SCALARGO, NULLSTATE11, READY, NULLSTATE12,ERROROUT,NULLSTATE13);
  signal state, next_state : stateType;
  signal done_reg, done_reg1 : std_logic;
begin 
  regist: process (clk, rst, reset_error,next_state, data_wrong, error_z)
    begin
      if (rst = '1') then
        state <= IDLE;
        done_reg <= '0';
        done_reg1 <= '0';
      elsif (rising_edge(clk)) then
        state <= next_state;
        done_reg <= done;
        done_reg1 <= done_reg;
        if (reset_error = '1') then
          state <= IDLE;
        elsif (data_wrong = '1') or (error_z = '1') then
          state <= ERROROUT;
        end if;
    end if;
  end process regist;
-----------------------------------------------------------------
  nextstatelogic: process (done, data_read, threed_enable, packet_received, all_vertices_done, state)
  begin  
    next_state <= state;
    case state is
      when IDLE =>
        if (threed_enable = "01") and (data_read = '1') then
          next_state <= SINE;
        else 
          next_state <= IDLE;
        end if;
-------------------------------------------------------------------
      when SINE =>
          next_state <= NULLSTATE1;
-------------------------------------------------------------------
      when NULLSTATE1 =>
        if (packet_received = '1') then
          next_state <= TRANSIT1;
        elsif (data_read = '1') then
          next_state <= SINE;
        else
          next_state <= NULLSTATE1;
        end if;
-------------------------------------------------------------------
      when TRANSIT1 =>
        if (data_read = '1') then
          next_state <= COSINE;
        else 
          next_state <= TRANSIT1;
        end if;
--------------------------------------------------------------------
      when COSINE =>
          next_state <= NULLSTATE2;    
--------------------------------------------------------------------
      when NULLSTATE2 =>
        if (packet_received = '1') then
          next_state <= TRANSIT2;
        elsif (data_read = '1') then
          next_state <= COSINE;
        else
          next_state <= NULLSTATE2;
        end if;
-------------------------------------------------------------------
      when TRANSIT2 =>
        if (data_read = '1') then
          next_state <= OFFSET;
        else 
          next_state <= TRANSIT2;
        end if;
--------------------------------------------------------------------
      when OFFSET =>
	  next_state <= NULLSTATE3;  
--------------------------------------------------------------------
      when NULLSTATE3 =>
        if (packet_received = '1') then
          next_state <= TRANSIT3;
        elsif (data_read = '1') then
          next_state <= OFFSET;
        else
          next_state <= NULLSTATE3;
        end if;
--------------------------------------------------------------------
      when TRANSIT3 =>
        if (data_read = '1') and (threed_enable = "01") then
          next_state <= POINT;
        else 
          next_state <= TRANSIT3;
        end if;
--------------------------------------------------------------------
      when POINT =>
          next_state <= NULLSTATE4; 
--------------------------------------------------------------------
      when NULLSTATE4 =>
        if (packet_received = '1') then
          next_state <= NULLSTATE5;
        elsif (data_read = '1') then
          next_state <= POINT;
        else
          next_state <= NULLSTATE4;
       end if;
-------------------------------------------------------------------
      when NULLSTATE5 => 
        next_state <= NULLSTATE6;
-------------------------------------------------------------------
      when NULLSTATE6 => 
        next_state <= NULLSTATE7;
------------------------------------------------------------------
      when NULLSTATE7 => 
        next_state <= NULLSTATE8;
------------------------------------------------------------------
      when NULLSTATE8 => 
        next_state <= NULLSTATE9;
------------------------------------------------------------------
      when NULLSTATE9 => 
        next_state <= NULLSTATE10;
------------------------------------------------------------------
      when NULLSTATE10 => 
        next_state <= SCALARGO;
------------------------------------------------------------------
      when SCALARGO => 
        next_state <= NULLSTATE11;
------------------------------------------------------------------
      when NULLSTATE11 => 
        if (done_reg1 = '1') then
         next_state <= READY;
        else
          next_state <= NULLSTATE11;
        end if;
------------------------------------------------------------------
      when READY => 
        next_state <= NULLSTATE13;
------------------------------------------------------------------
      when NULLSTATE13 => 
        next_state <= NULLSTATE12;
------------------------------------------------------------------
      when NULLSTATE12 => 
        if (all_vertices_done = '1') then
          next_state <= IDLE;
        else
          next_state <= TRANSIT3;
        end if;
------------------------------------------------------------------
      when ERROROUT =>
          next_state <= IDLE;
------------------------------------------------------------------
      when others => null;
    end case;
  end process nextstatelogic;
------------------------------------------------------------------
  outputlogic: process (state)
  begin
    clk_sr <= "0000";
    clk_up <= '0';
    restart <= '0';
    enable <= "0000";
    start_divide <= '0';
    ready1 <= '0';
    throw_frame <= '0';
    restart_vertices  <= '0';
    done_one_vertices <= '0';
    case state is
      when IDLE =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '1';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '1';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when SINE =>
    	clk_sr <= "1000";
  	clk_up <= '1';
    	restart <= '0';
    	enable <= "1000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE1 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when TRANSIT1 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '1';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when COSINE =>
    	clk_sr <= "0100";
  	clk_up <= '1';
    	restart <= '0';
    	enable <= "0100";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE2 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when TRANSIT2 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '1';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when OFFSET =>
    	clk_sr <= "0010";
  	clk_up <= '1';
    	restart <= '0';
    	enable <= "0010";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE3 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when TRANSIT3 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '1';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when POINT =>
    	clk_sr <= "0001";
  	clk_up <= '1';
    	restart <= '0';
    	enable <= "0001";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE4 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE5 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '1';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE6 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE7 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE8 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE9 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE10 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when SCALARGO =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '1';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE11 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when ready =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '1';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '1';
-------------------------------------------------------------------
      when NULLSTATE12 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when NULLSTATE13 =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '0';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when ERROROUT =>
    	clk_sr <= "0000";
  	clk_up <= '0';
    	restart <= '0';
    	enable <= "0000";
    	start_divide <= '0';
    	ready1 <= '0';
        throw_frame <= '1';
        restart_vertices  <= '0';
        done_one_vertices <= '0';
-------------------------------------------------------------------
      when others => null;
    end case;
  end process outputlogic;
end behavioral;
