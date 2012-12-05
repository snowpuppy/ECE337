-- $Id: $
-- File name:   gpu_block.vhd
-- Created:     12/2/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This is the GPU for the UART to HDMI adapter!


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity gpu_block is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        read_frame          : in    std_logic;
        pixel_done          : in    std_logic;
        control_in          : in    std_logic_vector(2 downto 0);
        num_vertices_in     : in    std_logic_vector(7 downto 0);
        color_in            : in    std_logic_vector(23 downto 0);
        vertices_in         : in    std_logic_vector(767 downto 0);
        computation_done    : out   std_logic;
        pixel_ready         : out   std_logic; -- note that pixel ready really maps to data ready and vice versa. This was due to a poor naming choice.
        data_in             : out   std_logic_vector(23 downto 0);
        address_in          : out   std_logic_vector(19 downto 0)
        );
end entity gpu_block;

architecture gpu_block_arch of gpu_block is

component gpu_storage_register is
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
end component gpu_storage_register;

component gpu_controller is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        read_frame          : in    std_logic;
        control             : in    std_logic_vector(2 downto 0);
        pixel_ready         : in    std_logic; -- note that pixel ready really maps to data ready and vice versa. This was due to a poor naming choice.
        data_read           : in    std_logic;
        valid               : in    std_logic;
        done1               : in    std_logic;
        done2               : in    std_logic;
        start               : out   std_logic;
        data_ready          : out   std_logic; -- note that pixel ready really maps to data ready and vice versa. This was due to a poor naming choice.
        computation_done    : out   std_logic;
        next_pixel          : out   std_logic;
        strobe_fill         : out   std_logic;
        read_input          : out   std_logic;
        new_data            : out   std_logic;
        mode                : out   std_logic
        );
end component gpu_controller;

component drawlogic_block is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        start               : in    std_logic;
        new_data            : in    std_logic;
        strobe_fill         : in    std_logic;
        next_pixel          : in    std_logic;
        num_vertices        : in    std_logic_vector(7 downto 0);
        vertices            : in    std_logic_vector(767 downto 0);
        done1               : out   std_logic;
        done2               : out   std_logic;
        pixel_ready         : out   std_logic; -- note that pixel ready really maps to data ready and vice versa. This was due to a poor naming choice.
        fill_coord          : out   std_logic_vector(31 downto 0);
        line_coord          : out   std_logic_vector(31 downto 0)
        );
end component drawlogic_block;

component coord_to_address is
    port (
        fill_coord         : in    std_logic_vector(31 downto 0);
        line_coord         : in    std_logic_vector(31 downto 0);
        mode               : in    std_logic;
        valid_address      : out   std_logic; -- logic to make sure the address is actually valid!
        address            : out   std_logic_vector(19 downto 0)
        );
end component coord_to_address;

    signal control : std_logic_vector(2 downto 0);
    signal color : std_logic_vector(23 downto 0);
    signal vertices : std_logic_vector(767 downto 0);
    signal num_vertices : std_logic_vector(7 downto 0);
    signal valid : std_logic;
    signal done1 : std_logic;
    signal done2 : std_logic;
    signal start : std_logic;
    signal data_ready : std_logic; -- note that pixel ready really maps to data ready and vice versa. This was due to a poor naming choice.
    signal next_pixel : std_logic;
    signal strobe_fill : std_logic;
    signal read_input : std_logic;
    signal new_data : std_logic;
    signal mode : std_logic;
    signal fill_coord : std_logic_vector(31 downto 0);
    signal line_coord : std_logic_vector(31 downto 0);
    signal address : std_logic_vector(19 downto 0);

begin
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
--                        BEGIN THE GPU ARCHITECTURE
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

COMstorage_register:gpu_storage_register port map (
        clk => clk,
        rst => rst,
        read_frame => read_frame,
        control_in => control_in,
        color_in => color_in,
        vertices_in => vertices_in,
        num_vertices_in => num_vertices_in,
        control => control,
        color => color,
        vertices => vertices,
        num_vertices => num_vertices
        );

COMgpu_controller: gpu_controller port map (
        clk => clk,
        rst => rst,
        read_frame => read_frame,
        control => control,
        pixel_ready => data_ready, -- note that pixel ready really maps to data ready and vice versa. This was due to a poor naming choice.
        data_read => pixel_done,
        valid => valid,
        done1 => done1,
        done2 => done2,
        start => start,
        data_ready => pixel_ready, -- note that pixel ready really maps to data ready and vice versa. This was due to a poor naming choice.
        computation_done => computation_done,
        next_pixel => next_pixel,
        strobe_fill => strobe_fill,
        read_input => read_input,
        new_data => new_data,
        mode => mode
        );

COMdrawlogic_block: drawlogic_block port map (
        clk => clk,
        rst => rst,
        start => start,
        new_data => new_data,
        strobe_fill => strobe_fill,
        next_pixel => next_pixel,
        num_vertices => num_vertices,
        vertices => vertices,
        done1 => done1,
        done2 => done2,
        pixel_ready => data_ready, -- note that pixel ready really maps to data ready and vice versa. This was due to a poor naming choice.
        fill_coord => fill_coord,
        line_coord => line_coord
        );

COMcoord_to_address: coord_to_address port map (
        fill_coord => fill_coord,
        line_coord => line_coord,
        mode => mode,
        valid_address => valid,
        address => address
        );

        data_in <= color;
        address_in <= address;

end architecture gpu_block_arch;
