-- $Id: $
-- File name:   sram_Timer.vhd
-- Created:     11/20/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: timer


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


entity sram_Timer is
  
  port (
    tx_load    : in std_logic;
    clock_me   : in std_logic;
    sram_Timer_done : out std_logic;
    rst_n      : in std_logic);

end sram_Timer;


architecture con_timer of sram_Timer is
   type statetype is (IDLE,BIT0,BIT1,BIT2,BIT3,BIT4,BIT5,BIT6,BIT7,BIT8,BIT9,DONE);
   signal state,nextstate : statetype;


  
begin  -- con_timer
    -- purpose: for restart
    -- type   : sequential
    -- inputs : clock_me, rst_n
    -- outputs: 
    rst_me: process (clock_me, rst_n)
    begin  -- process rst_me
      if rst_n = '0' then               -- asynchronous reset (active low)
        state <= IDLE;
      elsif clock_me'event and clock_me = '1' then  -- rising clock edge
        state <= nextstate;
      end if;
    end process rst_me;


     -- purpose: nextstate logic
     -- type   : combinational
     -- inputs : tx_load,clock_me
     -- outputs: 
    nextstate_logic: process (tx_load,state)
     begin  -- process nextstate_logic
       nextstate <= state;              -- default
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
         nextstate <= DONE;

          when DONE =>
           if tx_load = '1' then
             nextstate <= BIT1;
           ELSE
              nextstate <= IDLE;
           end if;
        
      
      end case;
       
     end process nextstate_logic; 

     OUT_PUT: process (state)
     begin  -- process OUT_PUT
       sram_Timer_done <= '0';
       if state = DONE then
         sram_Timer_done <= '1';
       end if;
     end process OUT_PUT;
     
end con_timer;

