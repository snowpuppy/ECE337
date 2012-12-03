-- $Id: $
-- File name:   gpu_storage_register.vhd
-- Created:     12/2/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This register stores all of the vertices, the color, the control signals, and
-- the number of vertices sent to the uart to hdmi device.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity gpu_storage_register is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        read_frame          : in    std_logic;
        control_in          : in    std_logic_vector(2 downto 0);
        color_in            : in    std_logic_vector(23 downto 0);
        vertices_in         : in    std_logic_vector(767 downto 0);
        num_vertices_in     : in    std_logic_vector(7 downto 0);
        control             : out   std_logic_vector(2 downto 0);
        color               : out   std_logic_vector(23 downto 0);
        vertices            : out   std_logic_vector(767 downto 0);
        num_vertices        : out   std_logic_vector(7 downto 0)
        );
end entity gpu_storage_register;

architecture gpu_storage_register_arch of gpu_storage_register is
    signal control_nxt : std_logic_vector(2 downto 0);
    signal color_nxt   : std_logic_vector(23 downto 0);
    signal vertices_nxt : std_logic_vector(767 downto 0);
    signal num_vertices_nxt : std_logic_vector(7 downto 0);
    signal control_reg : std_logic_vector(2 downto 0);
    signal color_reg   : std_logic_vector(23 downto 0);
    signal vertices_reg : std_logic_vector(767 downto 0);
    signal num_vertices_reg : std_logic_vector(7 downto 0);
begin

  reg: process (clk, rst)
  begin
    if rst = '1' then -- active reset
        control_reg <= (others => '0');
        color_reg <= (others => '0');
        vertices_reg <= (others => '0');
        num_vertices_reg <= (others => '0');
    elsif rising_edge(clk) then  -- check clock edge
        control_reg <= control_nxt;
        color_reg <= color_nxt;
        vertices_reg <= vertices_nxt;
        num_vertices_reg <= num_vertices_nxt;
    end if;
  end process reg;

  nextState: process(control_in, color_in, vertices_in, num_vertices_in, read_frame)
  begin
    -- initialize the registers.
    control_nxt <= control_reg;
    color_nxt <= color_reg;
    vertices_nxt <= vertices_reg;
    num_vertices_nxt <= num_vertices_reg;

    if (read_frame = '1') then
        control_nxt <= control_in;
        color_nxt <= color_in;
        vertices_nxt <= vertices_in;
        num_vertices_nxt <= num_vertices_in;
    end if;

  end process nextState;

  control <= control_reg;
  color <= color_reg;
  vertices <= vertices_reg;
  num_vertices <= num_vertices_reg;

end architecture gpu_storage_register_arch;
