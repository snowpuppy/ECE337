-- $Id: $
-- File name:   initial_calc.vhd
-- Created:     11/28/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This file performs initial calculations for drawing a line
-- and stores them in a large register for use by the line drawing algorithms.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
--USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity initial_calc is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        read_data           : in    std_logic;
        x1                  : in    std_logic_vector(15 downto 0);
        x2                  : in    std_logic_vector(15 downto 0);
        y1                  : in    std_logic_vector(15 downto 0);
        y2                  : in    std_logic_vector(15 downto 0);
        --calculations        : out   std_logic_vector(95 downto 0);
        xi                  : out   std_logic_vector(15 downto 0);
        xf                  : out   std_logic_vector(15 downto 0);
        yi                  : out   std_logic_vector(15 downto 0);
        yf                  : out   std_logic_vector(15 downto 0);
        dx                  : out   std_logic_vector(15 downto 0);
        dy                  : out   std_logic_vector(15 downto 0);
        positive_slope      : out   std_logic;
        small_slope         : out   std_logic
     );
end entity initial_calc;

architecture initial_calc_arch of initial_calc is
    signal dx_reg, dy_reg, xi_reg, xf_reg, yi_reg, yf_reg : std_logic_vector(15 downto 0);
    signal dx_nxt, dy_nxt, xi_nxt, xf_nxt, yi_nxt, yf_nxt : signed(15 downto 0);
    signal x1lessx2: std_logic;
    signal y1lessy2: std_logic;
    signal x1equalx2: std_logic;
    signal y1equaly2: std_logic;
    signal y1greatery2: std_logic;
    signal x1greaterx2: std_logic;
    signal x2greaterx1: std_logic;
    signal small_slope_reg, positive_slope_reg : std_logic;
    signal small_slope_nxt, positive_slope_nxt : std_logic;
    signal absdxgreaterabsdy : std_logic;
begin
  reg: process (clk, rst)
  begin
    if rst = '1' then -- active reset
        dx_reg <= (others =>'0');
        dy_reg <= (others =>'0');
        xi_reg <= (others =>'0');
        xf_reg <= (others =>'0');
        yi_reg <= (others =>'0');
        yf_reg <= (others =>'0');
        positive_slope_reg <= '0';
        small_slope_reg <= '0';
    elsif rising_edge(clk) then  -- check clock edge
        dx_reg <= std_logic_vector(dx_nxt);
        dy_reg <= std_logic_vector(dy_nxt);
        xi_reg <= std_logic_vector(xi_nxt);
        xf_reg <= std_logic_vector(xf_nxt);
        yi_reg <= std_logic_vector(yi_nxt);
        yf_reg <= std_logic_vector(yf_nxt);
        positive_slope_reg <= positive_slope_nxt;
        small_slope_reg <= small_slope_nxt;
    end if;
  end process reg;

  y1equaly2 <= '1' when y1 = y2 else '0';
  x1equalx2 <= '1' when x1 = x2 else '0';
  y1lessy2 <= '1' when signed(y1) < signed(y2) else '0';
  x1lessx2 <= '1' when signed(x1) < signed(x2) else '0';
  y1greatery2 <= '1' when y1lessy2 = '0' and y1equaly2 = '0' else '0';
  x1greaterx2 <= '1' when x1lessx2 = '0' and x1equalx2 = '0' else '0';
  x2greaterx1 <= '1' when x1lessx2 = '1' and x1equalx2 = '0' else '0';
  absdxgreaterabsdy <= '1' when abs(signed(dx_reg)) >= abs(signed(dy_reg)) else '0';

  -- Process for comparing x and y
  -- values for next state logic.
  --compare:process(x1,x2,y1,y2)
  --begin
  --  -- default values.
  --  y1equaly2 <= '0';
  --  x1equalx2 <= '0';
  --  y1lessy2 <= '0';
  --  x1lessx2 <= '0';
  --  -- set the flags appropriately.
  --  if x1 < x2 then
  --      x1lessx2 <= '1';
  --  end if;
  --  if y1 < y2 then
  --      y1lessy2 <= '1';
  --  end if;
  --  if y1 = y2 then
  --      y1equaly2 <= '1';
  --  end if;
  --  if x1 = x2 then
  --      x1equalx2 <= '1';
  --  end if;
  --end process compare;

  -- Next state logic to determine
  -- the values used by the line
  -- drawing algorithm.
  nextState_xixfyiyf: process(x1, x2, y1, y2, x1lessx2, y1lessy2, positive_slope_nxt, absdxgreaterabsdy, y1greatery2, x1greaterx2, xi_reg, xf_reg, yi_reg, yf_reg, small_slope_reg, read_data)
  begin
    xi_nxt <= signed(xi_reg);
    xf_nxt <= signed(xf_reg);
    yi_nxt <= signed(yi_reg);
    yf_nxt <= signed(yf_reg);
    small_slope_nxt <= small_slope_reg;
    -- Only update the values if asked to do so!
    if read_data = '1' then
        -- sort out the x values.
        -- Assume positive slope.
        if x1lessx2 = '1' then
            xi_nxt <= signed(x1);
            xf_nxt <= signed(x2);
        else
            xi_nxt <= signed(x2);
            xf_nxt <= signed(x1);
        end if;
        -- sort out the y values.
        if y1lessy2 = '1' then
            yi_nxt <= signed(y1);
            yf_nxt <= signed(y2);
        else
            yi_nxt <= signed(y2);
            yf_nxt <= signed(y1);
        end if;

        -- If the slope is negative, we need to make some
        -- changes to the order of x,y values.
        if positive_slope_nxt = '0' then
            if absdxgreaterabsdy = '1' then
                if y1greatery2 = '1' then
                    yi_nxt <= signed(y1);
                    yf_nxt <= signed(y2);
                else
                    yi_nxt <= signed(y2);
                    yf_nxt <= signed(y1);
                end if;
            else
                if x1greaterx2 = '1' then
                    xi_nxt <= signed(x1);
                    xf_nxt <= signed(x2);
                else
                    xi_nxt <= signed(x2);
                    xf_nxt <= signed(x1);
                end if;
            end if;
        end if;

        -- find out what the slope
        -- is.
        if absdxgreaterabsdy = '1' then
            small_slope_nxt <= '1';
        else
            small_slope_nxt <= '0';
        end if;

    end if;
  end process nextState_xixfyiyf;

  nextState_dxdy: process(x1, x2, y1, y2, x2greaterx1, y1greatery2, dx_reg, dy_reg, read_data)
  begin
    dx_nxt <= signed(dx_reg);
    dy_nxt <= signed(dy_reg);
    if read_data = '1' then
        if x2greaterx1 = '1' then
            dx_nxt <= signed(x2) - signed(x1);
            dy_nxt <= signed(y2) - signed(y1);
        elsif x1equalx2 = '1' and y1greatery2 = '1' then
            dx_nxt <= signed(x2) - signed(x1);
            dy_nxt <= signed(y2) - signed(y1);
        else
            dx_nxt <= signed(x1) - signed(x2);
            dy_nxt <= signed(y1) - signed(y2);
        end if;
    end if;
  end process nextState_dxdy;

  -- next state for positive slope.
  positive_slope_nxt <= '1' when ( signed(dx_reg) > 0 and signed(dy_reg) > 0 ) or ( signed(dx_reg) < 0 and signed(dy_reg) < 0 ) else '0';

  positive_slope <= positive_slope_reg;
  small_slope <= small_slope_reg;

  xi <= xi_reg;
  xf <= xf_reg;
  yi <= yi_reg;
  yf <= yf_reg;
  dx <= dx_reg;
  dy <= dy_reg;

end architecture initial_calc_arch;
