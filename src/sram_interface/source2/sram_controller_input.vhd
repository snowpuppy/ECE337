-- $Id: $
-- File name:   sram_controller_input.vhd
-- Created:     11/27/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: .


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


entity sram_controller_input is
  
  port (
    clk        : in  std_logic;
    rst_n      : in  std_logic;
    data_ready : in  std_logic;
    sram_sel   : in  std_logic;
    pixel_done : out std_logic;
    data_load  : out std_logic;
    ad_load    : out std_logic;
    ad_sel_w   : out std_logic;
    data_sel_w : out std_logic;
    WE_TWO     : out std_logic;
    WE_ONE     : out std_logic);
    
    

end sram_controller_input;

architecture ro_con of sram_controller_input is
    type statetype is (IDLE,LOAD,WAIT_FOR_LOAD,WAIT1,WAIT2,WAIT3,WAIT4,WAIT5,DONE);
    signal state,nextstate : statetype;

    signal write_now : std_logic:= '0';
    signal write_next : std_logic;
    --variable save_sram_change: integer range 0 to 256 := 0;
  
begin  -- ro_con

  rst_me: process (clk, rst_n)
  begin  -- process rst_me
    if rst_n = '0' then                 -- asynchronous reset (active low)
      state <= IDLE;
      write_now <= '0';
    elsif clk'event and clk = '1' then  -- rising clock edge
      state <= nextstate;
      write_now <= write_next;
    end if;
  end process rst_me;



  nextstate_logic: process (data_ready,state)
  begin  -- process nextstate_logic
    nextstate <= state;

    case state is
      when IDLE =>
         if data_ready = '1' then
           nextstate <= LOAD;
         else
           nextstate <= IDLE;
         end if;

      when LOAD =>
        nextstate <= WAIT_FOR_LOAD;

      when WAIT_FOR_LOAD =>
        nextstate <= WAIT1;

      when WAIT1 =>
        nextstate <= WAIT2;
        
      when WAIT2 =>
        nextstate <= WAIT3;
        
       when WAIT3 =>
        nextstate <= WAIT4;
        
      when WAIT4 =>
        nextstate <= WAIT5;
        
       when WAIT5 =>
        nextstate <= DONE;
     
        
        
      when DONE =>
        nextstate <= IDLE;

        
      when others => null;
    end case;


    
  end process nextstate_logic;

  -- purpose: out put logic
  -- type   : combinational
  -- inputs : state
  -- outputs: data_load, ad_load,pixxel_done
  out_putlogic: process (state)
  begin  -- process out_putlogic
    
    data_load <= '0';
    ad_load <= '0';
    pixel_done <= '0';

    if state = LOAD then
      data_load <= '1';
      ad_load <= '1';
    end if;

    if state = DONE then
      pixel_done <= '1';
    end if;

   
  end process out_putlogic;


 -- purpose: write_next_logic
 -- type   : combinational
 -- inputs : sram_sel
 -- outputs: 
 write_sel: process (sram_sel,write_now)
 begin  -- process write_sel
         
     write_next <= write_now xor sram_sel;
 end process write_sel;

 we_me: process (write_now)
 begin  -- process we_me
   WE_ONE <='0';
   WE_TWO <='0';
   if write_now = '0' then
     WE_ONE <= '1';
     WE_TWO <= '0';
   else
     WE_ONE <= '0';
     WE_TWO <= '1';
   end if;
 end process we_me;
  
 ad_sel_w <= write_now;
 data_sel_w <= write_now; 
 
  
end ro_con;

