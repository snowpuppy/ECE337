-- $Id: $
-- File name:   sram_Controller.vhd
-- Created:     11/22/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: .


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity sram_Controller is
  
  port (
    data_ready  : in  std_logic;
    clk         : in  std_logic;
    rst_n       : in  std_logic;
    encode_en : out std_logic;
    sram_Timer_done  : in  std_logic;
    need_data   : out std_logic;
    tx_shift    : out std_logic;
    tx_load     : out std_logic;
    data_sel    : out std_logic;
    ctrl        : in  std_logic);

end sram_Controller;


architecture me_conc of sram_Controller is
   type statetype is (IDLE,READ_ME,ENCODE,LOAD,TX_READ,TX_ENCODE,TX_LOAD_STATE,TX_WAIT);
   signal state,nextstate : statetype;
   
begin  -- me_conc
   rst_me: process (clk, rst_n)
   begin  -- process rst_me
     if rst_n = '1' then                -- asynchronous reset (active low)
       state <= IDLE;
     elsif clk'event and clk = '1' then  -- rising clock edge
       state <= nextstate;
     end if;
   end process rst_me;


   nextstate_logic: process (data_ready,ctrl,sram_Timer_done,state)
   begin  -- process nextstate_logic
     nextstate <= state;

     case state is
       when IDLE =>
         nextstate <= READ_ME;
         
       when READ_ME =>
         if data_ready = '1' then
            nextstate <= ENCODE;
         else
            nextstate <= READ_ME;
          end if;

      when ENCODE =>
           nextstate <= LOAD;

      when LOAD =>
           nextstate <= TX_READ;

      when TX_READ =>
           if data_ready = '1' then
             nextstate <= TX_ENCODE;
           else
             nextstate <= TX_READ;
           end if;

      when TX_ENCODE =>
           nextstate <= TX_WAIT;
            
      when TX_WAIT =>      
           if sram_Timer_done = '1' then
              nextstate <= TX_LOAD_STATE;
           else
              nextstate <= TX_WAIT;
            end if; 
       when TX_LOAD_STATE =>
            nextstate <= TX_READ;
              

         
       when others => null;
     end case;
   end process nextstate_logic;

   out_put: process (state,ctrl)
   begin  -- process out_put
     need_data <= '0';
     encode_en <= '0';
     tx_load <= '0';
     tx_shift <='0';
     data_sel <= '0';
     
     case state is
       when IDLE =>
         need_data <= '0';
         encode_en <= '0';
         tx_load <= '0';
         tx_shift <='0';
         data_sel <= not ctrl;

       when READ_ME =>
         need_data <= '1';
         encode_en <= '0';
         tx_load <= '0';
         tx_shift <='0';
         data_sel <= not ctrl;

       when ENCODE =>
         need_data <= '0';
         encode_en <= '1';
         tx_load <= '0';
         tx_shift <='0';
         data_sel <= not ctrl;

       when LOAD =>
         need_data <= '1';
         encode_en <= '0';
         tx_load <= '1';
         tx_shift <='0';
         data_sel <= not ctrl;

       when TX_READ =>
         need_data <= '1';
         encode_en <= '0';
         tx_load <= '0';
         tx_shift <='1';
         data_sel <= not ctrl;
         
       when TX_ENCODE =>
         need_data <= '0';
         encode_en <= '1';
         tx_load <= '0';
         tx_shift <='1';
         data_sel <= not ctrl;

       when TX_WAIT =>
         need_data <= '0';
         encode_en <= '0';
         tx_load <= '0';
         tx_shift <='1';
         data_sel <= not ctrl;

       when TX_LOAD_STATE =>
         need_data <= '0';
         encode_en <= '0';
         tx_load <= '1';
         tx_shift <='1';
         data_sel <= not ctrl;   




         
         
       when others => null;
     end case;
   end process out_put;

end me_conc;

