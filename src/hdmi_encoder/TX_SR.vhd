-- $Id: $
-- File name:   TX_SR.vhd
-- Created:     11/10/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: .


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity TX_SR is
  
 
  port (
    clock_me : in std_logic;
    rst_n : in std_logic;
    tx_shift : in std_logic;
    data_sel : in std_logic;
    tx_load : in std_logic;
    --clock_me : in std_logic;
    R : in std_logic_vector(9 downto 0);
    G : in std_logic_vector(9 downto 0);
    B : in STD_LOGIC_VECTOR(9 downto 0);
    
    H_VSYNC : in STD_LOGIC_VECTOR(9 downto 0);
    CTL0_1 : in STD_LOGIC_VECTOR(9 downto 0);
    CTL2_3 : in STD_LOGIC_VECTOR(9 downto 0);
    
    RO : out std_logic;
    GO : out std_logic;
    BO : out STD_LOGIC
    );

end TX_SR;


architecture tx_ar of TX_SR is
  signal R_NOW : std_logic_vector(9 downto 0);
  signal G_NOW : std_logic_vector(9 downto 0);
  signal B_NOW : std_logic_vector(9 downto 0);

  signal R_NEXT : std_logic_vector(9 downto 0) := "0000000000";
  signal G_NEXT : std_logic_vector(9 downto 0) := "0000000000";
  signal B_NEXT : std_logic_vector(9 downto 0) := "0000000000";

  
  
begin  -- tx_ar

  se_me: process (clock_me, rst_n)
  begin  -- process se_me
    if rst_n = '0' then                 -- asynchronous reset (active low)
      R_NOW <= "0000000000";
      G_NOW <= "0000000000";
      B_NOW <= "0000000000";

   
        
    elsif clock_me'event and clock_me = '1' then  -- rising clock edge
      R_NOW <=  R_NEXT;
      G_NOW <=  G_NEXT;
      B_NOW <=  B_NEXT; 
     
    end if;
  end process se_me;
  
   me_flip: process (tx_shift,data_sel,tx_load,clock_me,R,G,B,H_VSYNC,CTL0_1,CTL2_3,R_NOW,G_NOW,B_NOW)
   begin  -- process me_flip
     if data_sel = '1' then             -- if data_sel = 1 then MOVIE DATA
       if tx_load = '1' then
            R_NEXT(9 downto 0) <=  R;
            G_NEXT(9 downto 0) <=  G;
            B_NEXT(9 downto 0) <=  B;
       elsif tx_shift = '1' then
              R_NEXT <=  '0' & R_NOW(9 downto 1) ;
              G_NEXT <=  '0' & G_NOW(9 downto 1) ;
              B_NEXT <=  '0' & B_NOW(9 downto 1) ;
       ELSE
             R_NEXT <=  R_NOW;
             G_NEXT <=  G_NOW;
             B_NEXT <=  B_NOW; 
       end if;

       
     else                              -- if data_sel = 0 then CONTROL DATA 
       if tx_load = '1' then
         R_NEXT(9 downto 0) <= H_VSYNC;
         G_NEXT(9 downto 0) <= CTL0_1;
         B_NEXT(9 downto 0) <= CTL2_3;
       elsif tx_shift = '1' then
          R_NEXT <=  '0' & R_NOW(9 downto 1) ;
          G_NEXT <=  '0' & G_NOW(9 downto 1) ;
          B_NEXT <=  '0' & B_NOW(9 downto 1) ;
       ELSE
             R_NEXT <=  R_NOW;
             G_NEXT <=  G_NOW;
             B_NEXT <=  B_NOW; 

           --   R_NEXT(0) <=  R_NOW;
           --  G_NEXT(0) <=  G_NOW;
           --  B_NEXT(0) <=  B_NOW; 


             
         
       end if;
       
     end if;
     
   end process me_flip;

   RO <= R_NOW(0);
   GO <= G_NOW(0);
   BO <= B_NOW(0);
  
end tx_ar;
    
