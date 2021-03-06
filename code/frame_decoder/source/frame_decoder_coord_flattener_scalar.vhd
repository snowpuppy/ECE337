-- $Id: $
-- File name:   frame_decoder_coord_flattener_scalar.vhd
-- Created:     11/16/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: scalar block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_unsigned.all;

entity frame_decoder_coord_flattener_scalar is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        start       : in std_logic;
        placer_z_in    : in std_logic_vector(15 downto 0); --z component
        placer_y_in    : in std_logic_vector(15 downto 0); --y component
        placer_x_in    : in std_logic_vector(15 downto 0); --x component
        quotient_xz : out std_logic_vector(15 downto 0); --results for x/z
        quotient_yz : out std_logic_vector(15 downto 0); --results for y/z
        error_z     : out std_logic;
	done        : out std_logic
    );
end frame_decoder_coord_flattener_scalar;

architecture behaviroal of frame_decoder_coord_flattener_scalar is
signal count, nextcount                  : std_logic_vector(4 downto 0);
signal res_xz, nextres_xz        	 : std_logic_vector(15 downto 0);
signal res_yz, nextres_yz            	 : std_logic_vector(15 downto 0);
signal quoti_xz, nextquoti_xz   	 : std_logic_vector(15 downto 0);
signal quoti_yz, nextquoti_yz    	 : std_logic_vector(15 downto 0);
signal divide_xz, nextdivide_xz 	 : std_logic_vector(15 downto 0);
signal divide_yz, nextdivide_yz  	 : std_logic_vector(15 downto 0);
signal temp_xz, nexttemp_xz, tempsign_xz : std_logic_vector(15 downto 0);
signal temp_yz, nexttemp_yz, tempsign_yz : std_logic_vector(15 downto 0);
signal done_c                   	 : std_logic;
signal error_z_reg_next,error_z_reg      : std_logic;
signal placer_z, placer_x, placer_y	 : std_logic_vector(15 downto 0);

begin

   placer_z <= std_logic_vector(abs(signed(placer_z_in)));
   placer_y <= std_logic_vector(abs(signed(placer_y_in)));
   placer_x <= std_logic_vector(abs(signed(placer_x_in)));

  -- state register. Keeps track of the state.
  regist: process (clk, rst)
  begin
    if rst = '1' then -- active reset
      count <= ( others => '0' );
      res_xz <= (others => '0');
      res_yz <= (others => '0');
      temp_xz <= (others => '0');
      temp_yz <= (others => '0');
      quoti_xz <= (others => '0');
      quoti_yz <= (others => '0');
      divide_xz <= (others => '0');
      divide_yz <= (others => '0');

      error_z_reg <= '0';

    elsif rising_edge(clk) then -- check clock edge
      count <= nextcount;
      res_xz <= nextres_xz;
      res_yz <= nextres_yz; 
      temp_xz <= nexttemp_xz;
      temp_yz <= nexttemp_yz;    
      quoti_xz <= nextquoti_xz;
      quoti_yz <= nextquoti_yz; 
      divide_xz <= nextdivide_xz;
      divide_yz <= nextdivide_yz;

      error_z_reg <= error_z_reg_next;

    end if;
  end process regist;

 -- nextstate process block
  nextState: process (tempsign_xz, tempsign_yz, nextcount, nexttemp_xz, nexttemp_yz, nextdivide_xz, nextdivide_yz, nextquoti_xz, nextquoti_yz, done_c, divide_xz, divide_yz, quoti_xz, quoti_yz, count, temp_xz, temp_yz, res_xz, res_yz, placer_z, placer_y,placer_x, start,nextres_xz,nextres_yz)
  begin
    --detect z if is right or wrong
      if ( placer_z < "000000000000000001") and (start = '1') then
        error_z_reg_next <= '1';
      else 
        error_z_reg_next <= '0';
      end if;

    -- set default values.
    nextcount <= count;

    --defult for x/z
    nexttemp_xz <= temp_xz;
    nextdivide_xz <= divide_xz;
    nextquoti_xz <= quoti_xz;
    nextres_xz <= res_xz;
    tempsign_xz <= (others => '0');

    --defult for y/z
    nexttemp_yz <= temp_yz;
    nextdivide_yz <= divide_yz;
    nextquoti_yz <= quoti_yz;
    nextres_yz <= res_yz;
    tempsign_yz <= (others => '0');

    if ( done_c = '0' ) then 
        -- increment the count
        nextcount <= count + 1;

        tempsign_xz <= temp_xz(14 downto 0) & divide_xz(15);
        nextres_xz <= tempsign_xz - placer_z;

        tempsign_yz <= temp_yz(14 downto 0) & divide_yz(15);
        nextres_yz <= tempsign_yz - placer_z;

        -- shift in a one or a zero
        if ( nextres_xz(15) = '1' ) then
            nextquoti_xz <= quoti_xz(14 downto 0) & '0';
            nexttemp_xz <= tempsign_xz;
        else
            nextquoti_xz <= quoti_xz(14 downto 0) & '1';
            nexttemp_xz <= nextres_xz;
        end if;

	if ( nextres_yz(15) = '1' ) then
            nextquoti_yz <= quoti_yz(14 downto 0) & '0';
            nexttemp_yz <= tempsign_yz;
        else
            nextquoti_yz <= quoti_yz(14 downto 0) & '1';
            nexttemp_yz <= nextres_yz;
        end if;

         --extract values.
        nextdivide_xz <= divide_xz(14 downto 0) & '0';
        nextdivide_yz <= divide_yz(14 downto 0) & '0';
    end if;

    -- reset logic
    if (start = '1') then
        nextcount <= ( others => '0');
        nexttemp_xz <= ( others => '0');
        nextdivide_xz <= placer_x;
        nextquoti_xz <= ( others => '0');
        nextres_xz <= ( others => '0');

        nexttemp_yz <= ( others => '0');
        nextdivide_yz <= placer_y;
        nextquoti_yz <= ( others => '0');
        nextres_yz <= ( others => '0');
    end if;

  end process nextState;

    -- output logic
    quotient_xz <= quoti_xz when placer_z_in(15) = placer_x_in(15) else std_logic_vector( -signed(quoti_xz));
    quotient_yz <= quoti_yz when placer_z_in(15) = placer_y_in(15) else std_logic_vector( -signed(quoti_xz));
    error_z <= error_z_reg;
    done_c <= '1' when count = "10000" else '0';
    done <= done_c;

end behaviroal;
