-- $Id: $
-- File name:   sram_CONTROLLER_OUT.vhd
-- Created:     11/29/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: .


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity sram_CONTROLLER_OUT is

 port (
   rst_n      : in  std_logic;
   clk        : in  std_logic;
   ad_sel_w   : in  std_logic;
   need_input : in  std_logic;
   done       : in  std_logic;
   sram_sel_out   : out std_logic;
   out_en     : out std_logic;
   write_done : out std_logic;
   pixel_ready : out std_logic;
   OE_ONE     : out std_logic;
   OE_TWO     : out std_logic;
   update    : out std_logic);

end sram_CONTROLLER_OUT;


architecture ro of sram_CONTROLLER_OUT is
  --                    0     1      2    3      4    5     6      7
    type statetype is (IDLE,WAIT1,WAIT2,WAIT3,WAIT4,WAIT5,LOAD,UPDATE_STATE);
    signal state,nextstate : statetype;
begin  -- ro
    rst_me: process (clk, rst_n)
    begin  -- process rst_me
      if rst_n = '0' then               -- asynchronous reset (active low)
        state <= IDLE;
      elsif clk'event and clk = '1' then  -- rising clock edge
        state <= nextstate;
      end if;
    end process rst_me;
  


    next_state: process (need_input,state)
    begin  -- process next_state
      nextstate <= state;

      case state is
        when IDLE =>
          if need_input = '1' then
            nextstate <= WAIT1;
          else
            nextstate <= IDLE;
          end if;

       
        when WAIT1 =>
          nextstate <= WAIT2;

        when WAIT2 =>
          nextstate <= WAIT3;

        when WAIT3 =>
          nextstate <= WAIT4;
        when WAIT4 =>
          nextstate <= WAIT5;

        when WAIT5 =>
          nextstate <= LOAD;
        when LOAD =>
          nextstate <= UPDATE_STATE;
          
         when UPDATE_STATE =>
          nextstate <= IDLE;


          
        when others => null;
      end case;
    end process next_state;


     out_put_logic: process (state)
     begin  -- process out_put_logic
       update <= '0';
       out_en <= '0';
       pixel_ready <= '0';

       if state = UPDATE_STATE then
         update <= '1';
         out_en <= '0';
         pixel_ready <= '1';
       end if;

       if state = LOAD then
         update <= '0';
         out_en <= '1';
         pixel_ready <= '0';
       end if;

    
     end process out_put_logic;



    out_put_two: process (ad_sel_w,done)
    begin  -- process out_put_two
      write_done <= done;
      sram_sel_out <= not ad_sel_w;
      if ad_sel_w = '0' then
        OE_ONE <= '0';
        OE_TWO <= '1';
      else
        OE_TWO <='0';
        OE_ONE <= '1';
      end if;
    end process out_put_two;

    
end ro;


