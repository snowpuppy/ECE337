-- $Id: $
-- File name:   Timer.vhd
-- Created:     11/20/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: timer


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


entity HDMITimer is
  
  port (
    clk:        in std_logic;
    rst_n      : in std_logic;
    tx_load    : in std_logic;
    Timer_done : out std_logic
    );

end HDMITimer;


architecture con_timer of HDMITimer is
   type statetype is (IDLE,BIT0,BIT1,BIT2,BIT3,BIT4,BIT5,BIT6,BIT7,BIT8,BIT9);
   signal state,nextstate : statetype;


  
begin  -- con_timer
    -- purpose: for restart
    -- type   : sequential
    -- inputs : clock_me, rst_n
    -- outputs: 
    rst_me: process ( rst_n,clk)
    begin  -- process rst_me
      if rst_n = '1' then               -- asynchronous reset (active low)
        state <= IDLE;
      elsif rising_edge(clk) then  -- rising clock edge
        state <= nextstate;
      end if;
    end process rst_me;


     -- purpose: nextstate logic
     -- type   : combinational
     -- inputs : tx_load,clock_me
     -- outputs: 
    nextstate_logic: process (state,tx_load)
     begin  -- process nextstate_logic
             -- default
     case state is
       when IDLE =>
        if tx_load = '1' then
          nextstate <= BIT0;
        else
          nextstate <= IDLE;
        end if;

       when BIT0 =>
         nextstate <= BIT1;
       
       when BIT1 =>
         nextstate <= BIT2;

        when BIT2 =>
         nextstate <= BIT3;
       when BIT3 =>
         nextstate <= BIT4;

         when BIT4 =>
         nextstate <= BIT5;
       when BIT5 =>
         nextstate <= BIT6;

         when BIT6 =>
         nextstate <= BIT7;
       when BIT7 =>
         nextstate <= BIT8;

         when BIT8 =>
         nextstate <= BIT9;
       when BIT9 =>
         nextstate <= BIT0;
    
      
      end case;
       
     end process nextstate_logic; 

     OUT_PUT: process (state)
     begin  -- process OUT_PUT
       Timer_done <= '0';
       if state = BIT8 then
         Timer_done <= '1';
       end if;
     end process OUT_PUT;
     
end con_timer;

