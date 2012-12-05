--- HDMI Encoder- Controller

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

Entity controller IS
  port(
    clk: in std_logic;
    rst_n: in std_logic;
    data_ready: in std_logic;
    timer_done: in std_logic;
    ctrl: in std_logic;
    pixel_loc: in std_logic_vector(9 downto 0);
    row_num:  in std_logic_vector(9 downto 0);
    encode_en: out std_logic;
    data_sel: out std_logic;
    tx_shift: out std_logic; -- optional
    tx_load: out std_logic;
    need_data: out std_logic
  );
end controller;

  Architecture struct_controller of controller is
  --internal signal declarations
  signal rencode_en,rdata_sel,rtx_shift,rtx_load,rneed_data: std_logic;
  type statetype is (idle,ctrl_load,ctrl_tx,wait1,call_data,encode_data,wait2,load_pixel,pixel_tx,wait3);--,empty1);--,empty2);
  signal state,nextstate: statetype;
  
begin
-------------------------------------------------------------------------------  
ctrl_reg: process(clk,rst_n)
begin
  if rst_n = '1' then
    state <= idle;
    encode_en <= '0';
    data_sel <= '0';
    tx_shift <= '0';
    tx_load <= '0';
    need_data <= '0';
  elsif(clk'event and clk = '1') then
    state <= nextstate;
    encode_en <= rencode_en;
    data_sel <= rdata_sel;
    tx_shift <= rtx_shift;
    tx_load <= rtx_load;
    need_data <= rneed_data;
  end if;
end process;
----------------------------------------------------------------------------------
nextstate_logic: process(state,data_ready,timer_done,pixel_loc,row_num,ctrl)
begin
  case state is
  
  when idle =>
    if ctrl = '1' then 
      nextstate <= ctrl_load;
    else
      nextstate <= idle;
    end if;
    
  when ctrl_load =>
      nextstate <= ctrl_tx;
      
  when ctrl_tx =>
      nextstate <= wait1;
      

    
  when wait1 =>
    --------
    if not (row_num > "0000101001" and row_num < "1000001010" and pixel_loc = "0010001001") then
                    --41(start from 42)        --522(ends at 521)           -- 137     --start from pixel_loc = 138, output video data
    ----
    if timer_done = '1' then
      nextstate <= ctrl_load;
     -- nextstate <= ctrl_load;  -- may be need an empty state between them
    else
      nextstate <= wait1;
    end if;
    ----
  else
      nextstate <= call_data;
    end if;
    --------
    
--  when empty1 =>
--      nextstate <= ctrl_load;
    
  when call_data =>
    if (data_ready = '1') then
      nextstate <= encode_data;
    else
      nextstate <= call_data;
    end if;
    
  when encode_data =>
      nextstate <= wait2;
      
  when wait2 =>
    if (timer_done = '1') then
      nextstate <= load_pixel; -- wait for a empty state then go to load_pixel
    else
      nextstate <= wait2;
    end if;
    
--  when empty2 =>
  --    nextstate <= load_pixel;
    
  when load_pixel =>
      nextstate <= pixel_tx;
      
  when pixel_tx =>
    if not (pixel_loc = "1101011001") then
                    --- 857 the last video pixel in the line
      nextstate <= call_data;
    else
      nextstate <= wait3;
    end if;
    
  when wait3 =>
    if(timer_done = '1') then
      nextstate <= ctrl_load;
    else
      nextstate <= call_data;
    end if;
    
  when others =>
    nextstate <= idle;
    
end case;
end process;
-----------------------------------------------------------------------------------------------------------------------------------------------------

out_logic: process(nextstate)
begin
  rneed_data <= '0';
  rencode_en <= '0';
  rtx_load <= '0';
  rtx_shift <= '0';
  rdata_sel <= '0';
  
case nextstate is
  
when idle =>
  rneed_data <= '0';
  rencode_en <= '0';
  rtx_load <= '0';
  rtx_shift <= '0';
  rdata_sel <= '0';
--
--when empty1 =>
--  rneed_data <= '0';
--  rencode_en <= '0';
--  rtx_load <= '0';
--  rtx_shift <= '0';
--  rdata_sel <= '0';
  
--when empty2 =>
--  rneed_data <= '0';
--  rencode_en <= '0';
--  rtx_load <= '0';
--  rtx_shift <= '0';
--  rdata_sel <= '1';
  

  
when ctrl_load =>
  rneed_data <= '0';
  rencode_en <= '0';
  rtx_load <= '1';
  rtx_shift <= '0';
  rdata_sel <= '0';
  
when ctrl_tx =>
  rneed_data <= '0';
  rencode_en <= '0';
  rtx_load <= '0';
  rtx_shift <= '1';
  rdata_sel <= '0';
  
when wait1 =>
  rneed_data <= '0';
  rencode_en <= '0';
  rtx_load <= '0';
  rtx_shift <= '1';
  rdata_sel <= '0';
  
when call_data =>
  rneed_data <= '1';
  rencode_en <= '0';
  rtx_load <= '0';
  rtx_shift <= '1';
  rdata_sel <= '1';
  
when encode_data =>
  rneed_data <= '0';
  rencode_en <= '1';
  rtx_load <= '0';
  rtx_shift <= '1';
  rdata_sel <= '1';
  
when wait2 =>
  rneed_data <= '0';
  rencode_en <= '0';
  rtx_load <= '0';
  rtx_shift <= '1';
  rdata_sel <= '1';
  
when load_pixel =>
  rneed_data <= '0';
  rencode_en <= '0';
  rtx_load <= '1';
  rtx_shift <= '0';
  rdata_sel <= '1';
  
when pixel_tx =>
  rneed_data <= '0';
  rencode_en <= '0';
  rtx_load <= '0';
  rtx_shift <= '1';
  rdata_sel <= '1';
  
when wait3 =>
  rneed_data <= '0';
  rencode_en <= '0';
  rtx_load <= '0';
  rtx_shift <= '0';
  rdata_sel <= '0';
  
when others =>
  rneed_data <= '0';
  rencode_en <= '0';
  rtx_load <= '0';
  rtx_shift <= '0';
  rdata_sel <= '0';
  
end case;
end process;
end struct_controller;
  
  
      
    
    
    
    

  
  
  
  

    
    
