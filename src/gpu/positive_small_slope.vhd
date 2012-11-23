-- $Id: $
-- File name:   positive_small_slope.vhd
-- Created:     11/19/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This function draws a line for a positive small slope.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity positive_small_slope is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        strobe              : in    std_logic;
        load                : in    std_logic;
        enable1             : in    std_logic;
        dx                  : in    std_logic_vector(15 downto 0);
        dy                  : in    std_logic_vector(15 downto 0);
        xi                  : in    std_logic_vector(15 downto 0);
        xf                  : in    std_logic_vector(15 downto 0);
        yi                  : in    std_logic_vector(15 downto 0);
        yf                  : in    std_logic_vector(15 downto 0);
        pixel_done          : out    std_logic;
        line_done           : out    std_logic;
        x                   : out    std_logic_vector(15 downto 0);
        y                   : out    std_logic_vector(15 downto 0);
    );
end entity positive_small_slope;

architecture positive_small_slope_arch of positive_small_slope is
    signal x_reg, y_reg : std_logic_vector(15 downto 0)
    signal x_nxt, y_nxt : std_logic_vector(15 downto 0)
    signal eps_reg, eps_nxt: std_logic_vector(15 downto 0)
    signal enstrobe : std_logic;
begin
  -- state register. Keeps track of the state.
  reg: process (clk, rst)
  begin
    if rst = '1' then -- active reset
      x_reg <= '0';
      y_reg <= '0';
      eps_reg <= '0';
    elsif rising_edge(clk) then  -- check clock edge
      x_reg <= x_nxt;
      y_reg <= y_nxt;
      eps_reg <= eps_nxt;
    end if;
  end process reg;

  nextState: process(x_reg, y_reg, eps_reg, enstrobe,load, xi, yi)
  begin
    -- Set default next values.
    x_nxt <= x_reg;
    y_nxt <= y_reg;
    
    if enstrobe = '1' then
        if x_reg <= xf then
            x_nxt <= x_reg + 1;
        else
            x_nxt <= x_reg;
        end if;
    end if;
    
    -- Check if we need to load a new value (highest priority)
    if load = '1' then
        x_nxt <= xi;
        y_nxt <= yi;
        eps_nxt <= '0';
    end if;
  end process nextState;

  output: process()
  begin
  end process output;

  enstrobe <= enable and strobe;

end architecture positive_small_slope_arch;
