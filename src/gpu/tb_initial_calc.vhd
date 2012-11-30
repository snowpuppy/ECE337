-- $Id: $
-- File name:   tb_initial_calc.vhd
-- Created:     11/29/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_initial_calc is
generic (Period : Time := 4 ns);
end tb_initial_calc;

architecture TEST of tb_initial_calc is

  function UINT_TO_STDV( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector(to_unsigned(X, NumBits));
  end;

  function STDV_TO_UINT( X: std_logic_vector)
     return integer is
  begin
    return to_integer(unsigned(x));
  end;

  procedure check_values( xi_l: in std_logic_vector; xf_l : in std_logic_vector; yi_l: in std_logic_vector; yf_l : in std_logic_vector; dx_l : in std_logic_vector; dy_l : in std_logic_vector; x1_l : in std_logic_vector; y1_l : in std_logic_vector; x2_l : in std_logic_vector; y2_l : in std_logic_vector; positive_slope : in std_logic; small_slope : in std_logic )
    is
    variable xi_g, xf_g, yi_g, yf_g, dx_g, dy_g: integer;
    variable p_slope_g, s_slope_g : std_logic; -- positive and small slope
    variable xi, xf, yi, yf, dx, dy, x1, y1, x2, y2 : integer;
  begin
    -- initialize all of the variables.
    xi := to_integer(signed(xi_l));
    xf := to_integer(signed(xf_l));
    yi := to_integer(signed(yi_l));
    yf := to_integer(signed(yf_l));
    dx := to_integer(signed(dx_l));
    dy := to_integer(signed(dy_l));
    x1 := to_integer(signed(x1_l));
    x2 := to_integer(signed(x2_l));
    y1 := to_integer(signed(y1_l));
    y2 := to_integer(signed(y2_l));

    -- set the gold values based on these.
    -- find slope.
    if x2 > x1 then
        dx_g := x2 - x1;
        dy_g := y2 - y1;
    elsif (x1 = x2 and y1 > y2) then
        dx_g := x2 - x1;
        dy_g := y2 - y1;
    else
        dx_g := x1 - x2;
        dy_g := y1 - y2;
    end if;

    -- find appropriate initial values.
    if y1 < y2 then
        yi_g := y1;
    else
        yi_g := y2;
    end if;
    if y1 > y2 then
        yf_g := y1;
    else
        yf_g := y2;
    end if;
    if x1 < x2 then
        xi_g := x1;
    else
        xi_g := x2;
    end if;
    if x1 > x2 then
        xf_g := x1;
    else
        xf_g := x2;
    end if;
    -- find positive slope value
    if (dx_g > 0 and dy_g > 0) or (dx_g < 0 and dy_g < 0) then
        p_slope_g := '1';
    else
        p_slope_g := '0';
    end if;
    
    -- make corrections given slope
    if (p_slope_g = '1') then
        if (dx_g >= dy_g) then
            s_slope_g := '1';
        else
            s_slope_g := '0';
        end if;
    else
        if (abs(dx_g) >= abs(dy_g)) then
            if y1 > y2 then
                yi_g := y1;
            else
                yi_g := y2;
            end if;
            if y1 < y2 then
                yf_g := y1;
            else
                yf_g := y2;
            end if;
            s_slope_g := '1';
        else
            if x1 > x2 then
                xi_g := x1;
            else
                xi_g := x2;
            end if;
            if x1 < x2 then
                xf_g := x1;
            else
                xf_g := x2;
            end if;
            s_slope_g := '0';
        end if;
    end if;
    
    -- Test for correct values.
    if xi = xi_g then
        report "Correct xi value found." severity NOTE;
    else
        report "Incorrect xi value found." severity ERROR;
    end if;
    if xf = xf_g then
        report "Correct xf value found." severity NOTE;
    else
        report "Incorrect xf value found." severity ERROR;
    end if;
    if yi = yi_g then
        report "Correct yi value found." severity NOTE;
    else
        report "Incorrect yi value found." severity ERROR;
    end if;
    if yf = yf_g then
        report "Correct yf value found." severity NOTE;
    else
        report "Incorrect yf value found." severity ERROR;
    end if;
    if dx = dx_g then
        report "Correct dx value found." severity NOTE;
    else
        report "Incorrect dx value found." severity ERROR;
    end if;
    if dy = dy_g then
        report "Correct dy value found." severity NOTE;
    else
        report "Incorrect dy value found." severity ERROR;
    end if;
    if s_slope_g = small_slope then
        report "Correct small_slope value found." severity NOTE;
    else
        report "Incorrect small_slope value found." severity ERROR;
    end if;
    if p_slope_g = positive_slope then
        report "Correct positive_slope value found." severity NOTE;
    else
        report "Incorrect positive_slope value found." severity ERROR;
    end if;

  end;

  component initial_calc
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         read_data : in std_logic;
         x1 : in std_logic_vector(15 downto 0);
         x2 : in std_logic_vector(15 downto 0);
         y1 : in std_logic_vector(15 downto 0);
         y2 : in std_logic_vector(15 downto 0);
         xi : out std_logic_vector(15 downto 0);
         xf : out std_logic_vector(15 downto 0);
         yi : out std_logic_vector(15 downto 0);
         yf : out std_logic_vector(15 downto 0);
         dx : out std_logic_vector(15 downto 0);
         dy : out std_logic_vector(15 downto 0);
         positive_slope : out std_logic;
         small_slope : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal read_data : std_logic;
  signal x1 : std_logic_vector(15 downto 0);
  signal x2 : std_logic_vector(15 downto 0);
  signal y1 : std_logic_vector(15 downto 0);
  signal y2 : std_logic_vector(15 downto 0);
  signal xi : std_logic_vector(15 downto 0);
  signal xf : std_logic_vector(15 downto 0);
  signal yi : std_logic_vector(15 downto 0);
  signal yf : std_logic_vector(15 downto 0);
  signal dx : std_logic_vector(15 downto 0);
  signal dy : std_logic_vector(15 downto 0);
  signal positive_slope : std_logic;
  signal small_slope : std_logic;

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: initial_calc port map(
                clk => clk,
                rst => rst,
                read_data => read_data,
                x1 => x1,
                x2 => x2,
                y1 => y1,
                y2 => y2,
                xi => xi,
                xf => xf,
                yi => yi,
                yf => yf,
                dx => dx,
                dy => dy,
                positive_slope => positive_slope,
                small_slope => small_slope
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    rst <= '1';
    read_data <= '0';
    x1 <= x"0000";
    x2 <= x"0000";
    y1 <= x"0000";
    y2 <= x"0000";
    wait for Period/2;
    rst <= '0';

    -- slope > 1
    -- positive_slope
    x1 <= x"0012"; -- 18
    y1 <= x"0008"; -- 8
    x2 <= x"0022"; -- 34
    y2 <= x"0030"; -- 48
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

    -- slope = 1
    -- positive_slope
    x1 <= x"0001"; -- 1
    y1 <= x"0001"; -- 1
    x2 <= x"0005"; -- 5
    y2 <= x"0005"; -- 5
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

    -- slope = 1
    -- positive_slope
    x1 <= x"0005"; -- 5
    y1 <= x"0005"; -- 5
    x2 <= x"0001"; -- 1
    y2 <= x"0001"; -- 1
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

    -- slope < 1
    -- positive slope
    x1 <= x"0001"; -- 1
    y1 <= x"0001"; -- 1
    x2 <= x"0005"; -- 5
    y2 <= x"0003"; -- 3
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

    -- slope < 1
    x1 <= x"0005"; -- 5
    y1 <= x"0001"; -- 3
    x2 <= x"0003"; -- 1
    y2 <= x"0001"; -- 1
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;
    
    -- slope > 1
    x1 <= x"0001"; -- 1
    y1 <= x"0003"; -- 1
    x2 <= x"0001"; -- 3
    y2 <= x"0005"; -- 5
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

    
    -- slope > 1
    x1 <= x"0003"; -- 3
    y1 <= x"0001"; -- 5
    x2 <= x"0005"; -- 1
    y2 <= x"0001"; -- 1
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

    -- slope = 0
    x1 <= x"0003"; -- 3
    y1 <= x"0005"; -- 5
    x2 <= x"000A"; -- 10
    y2 <= x"0005"; -- 5
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

    -- slope = 0
    x1 <= x"000A"; -- 10
    y1 <= x"0005"; -- 5
    x2 <= x"0003"; -- 3
    y2 <= x"0005"; -- 5
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

    
    -- slope = inf
    x1 <= x"0003"; -- 3
    y1 <= x"0005"; -- 5
    x2 <= x"0003"; -- 3
    y2 <= x"0019"; -- 25
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

    -- slope = inf
    x1 <= x"0003"; -- 3
    y1 <= x"0019"; -- 25
    x2 <= x"0003"; -- 3
    y2 <= x"0005"; -- 5
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

--#### NEGATIVE SLOPES ##### (Passing)
--# slope of -1
--test_line(5,0,0,5)
    x1 <= x"0005"; -- 5
    y1 <= x"0000"; -- 0
    x2 <= x"0000"; -- 0
    y2 <= x"0005"; -- 5
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

--# slope of -1 points reversed
--test_line(0,5,5,0)
    x1 <= x"0000"; -- 0
    y1 <= x"0005"; -- 5
    x2 <= x"0005"; -- 5
    y2 <= x"0000"; -- 0
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

--# slope > -1
--test_line(5,2,0,5)
    x1 <= x"0005"; -- 5
    y1 <= x"0002"; -- 2
    x2 <= x"0000"; -- 0
    y2 <= x"0005"; -- 5
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

--# slope > -1 points reversed
--test_line(0,5,5,2)
    x1 <= x"0000"; -- 0
    y1 <= x"0005"; -- 5
    x2 <= x"0005"; -- 5
    y2 <= x"0002"; -- 2
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

--# slope < -1
--test_line(7,0,3,12)
    x1 <= x"0007"; -- 7
    y1 <= x"0000"; -- 0
    x2 <= x"0003"; -- 3
    y2 <= x"000C"; -- 12
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

--# slope < -1 points reversed
--test_line(3,12,7,0)
    x1 <= x"0003"; -- 3
    y1 <= x"000C"; -- 12
    x2 <= x"0007"; -- 7
    y2 <= x"0000"; -- 0
    wait for Period;
    read_data <= '1';
    wait for 2*Period;
    check_values( xi, xf, yi, yf, dx, dy, x1, y1, x2, y2, positive_slope, small_slope );
    read_data <= '0';
    wait for Period;

  end process;
end TEST;
