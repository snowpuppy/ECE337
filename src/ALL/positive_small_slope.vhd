-- $Id: $
-- File name:   positive_small_slope.vhd
-- Created:     11/19/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This function draws a line for a positive small slope.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

entity positive_small_slope is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        strobe              : in    std_logic;
        load                : in    std_logic;
        enable              : in    std_logic;
        dx                  : in    std_logic_vector(15 downto 0);
        dy                  : in    std_logic_vector(15 downto 0);
        xi                  : in    std_logic_vector(15 downto 0);
        xf                  : in    std_logic_vector(15 downto 0);
        yi                  : in    std_logic_vector(15 downto 0);
        yf                  : in    std_logic_vector(15 downto 0);
        pixel_done          : out    std_logic;
        line_done           : out    std_logic;
        x                   : out    std_logic_vector(15 downto 0);
        y                   : out    std_logic_vector(15 downto 0)
    );
end entity positive_small_slope;

architecture positive_small_slope_arch of positive_small_slope is
    signal x_reg, y_reg : std_logic_vector(15 downto 0);
    signal x_nxt, y_nxt : std_logic_vector(15 downto 0);
    signal eps_reg, eps_nxt: std_logic_vector(15 downto 0);
    signal x_plus_one, y_plus_one : std_logic_vector(15 downto 0);
    signal eps_plus_dy_reg, eps_plus_dy_nxt, epsdy_min_dx : std_logic_vector(15 downto 0);
    signal epsdy_shift_left : std_logic_vector(15 downto 0);
    signal enstrobe : std_logic;
    signal wait_load_reg : std_logic;
begin
  -- state register. Keeps track of the state.
  reg: process (clk, rst)
  begin
    if rst = '1' then -- active reset
      x_reg <= (others =>'0');
      y_reg <= (others =>'0');
      eps_reg <= (others =>'0');
      eps_plus_dy_reg <= (others =>'0');
      wait_load_reg <= '0';
    elsif rising_edge(clk) then  -- check clock edge
      x_reg <= x_nxt;
      y_reg <= y_nxt;
      eps_reg <= eps_nxt;
      wait_load_reg <= load or not wait_load_reg;
      eps_plus_dy_reg <= eps_plus_dy_nxt;
    end if;
  end process reg;

  -- addition for x and y
  add: process(x_reg, y_reg)
  begin
    x_plus_one <= x_reg + 1;
    y_plus_one <= y_reg + 1;
  end process add;

  -- addition for eps
  add_eps: process(eps_reg, dy, dx, eps_plus_dy_reg, wait_load_reg)
  begin
    eps_plus_dy_nxt <= eps_plus_dy_reg;
    if wait_load_reg = '0' then
        eps_plus_dy_nxt <= eps_reg + dy;
    end if;
    if load = '1' then
        eps_plus_dy_nxt <= dy;
    end if;
  end process add_eps;

  -- subtraction for eps
  min_eps: process(eps_plus_dy_reg, dy, dx)
  begin
    epsdy_min_dx <= eps_plus_dy_reg - dx;
    epsdy_shift_left <= eps_plus_dy_reg(14 downto 0) & '0';
  end process min_eps;

  nextState: process(x_reg, y_reg, eps_reg, enstrobe,load, xi, yi, epsdy_min_dx, eps_plus_dy_reg, dx, wait_load_reg, epsdy_shift_left)
  begin
    -- Set default next values.
    x_nxt <= x_reg;
    y_nxt <= y_reg;
    eps_nxt <= eps_reg;
    
    if enstrobe = '1' then
        if wait_load_reg = '0' then
            -- handle x next value
            if x_reg < xf then
                x_nxt <= x_reg + 1;
            else
                x_nxt <= x_reg;
            end if;
        end if;
        -- handle error next value
        if epsdy_shift_left >= dx and not eps_plus_dy_reg(15) = '1' then
            eps_nxt <= epsdy_min_dx;
            if wait_load_reg = '0' then
                y_nxt <= y_reg + 1;
            end if;
        else
            eps_nxt <= eps_plus_dy_reg;
        end if;
    end if;
    
    -- Check if we need to load a new value (highest priority)
    if load = '1' then
        x_nxt <= xi;
        y_nxt <= yi;
        eps_nxt <= (others =>'0');
    end if;
  end process nextState;

  --output: process()
  --begin
  --end process output;

  line_done <= '1' when x_reg = xf else '0';
  pixel_done <= not wait_load_reg;
  x <= x_reg;
  y <= y_reg;
  enstrobe <= enable and strobe;

end architecture positive_small_slope_arch;
