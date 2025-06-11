library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;

package lib is

    -- Counter
    component up_counter IS
        generic( start: std_logic_vector(8 downto 0) );  
        port ( 
            clk, rst: in std_logic;
            inc: in std_logic;
            z: out std_logic;
            count: out std_logic_vector(8 downto 0);
            stop: in std_logic_vector(8 downto 0));
    end component;
    
    -- Register
    component reg is
        port (
	       rst, clk: in STD_logic;
	       en: in std_logic;
	       d: in std_logic_vector(31 downto 0);
	       q: out std_logic_vector(31 downto 0)
        );
    end component;

    -- Memory
    component memory IS
        port (
            clk    : IN std_logic;
            we_in  : IN std_logic;
            re_in  : IN std_logic;
            addr   : IN std_logic_vector(17 downto 0);  -- 9 for input + 16 for output
            d_in   : IN std_logic_vector(31 downto 0);
            d_out  : OUT std_logic_vector(31 downto 0)
        );
    end component;

    -- Datapath
    component datapath is
        port (
            rst, clk: in std_logic;
            M, N: in std_logic_vector(8 downto 0);
    
            -- counter control signal
            j_zero_rst, j_zero_cnt: in std_logic;
            j_one_rst, j_one_cnt: in std_logic;
            i_one_rst, i_one_cnt: in std_logic;
            j_0max,j_1max, i_1max: out std_logic;
    
            -- register control signal
	        pixel_in_ld, pixel_out_ld: in std_logic;
	        pixel_out_left_ld, pixel_out_above_ld, pixel_out_diag_ld : in std_logic;
	
	        -- memory control signal
	        base_addr_in, base_addr_out: in std_logic_vector(17 downto 0);
	        mem_w_select: in std_logic;
	        mem_addr_select: in std_logic_vector(2 downto 0);
	        mem_read_data: in std_logic_vector(31 downto 0);
            mem_addr: out std_logic_vector(17 downto 0) ;
            mem_write_data: out std_logic_vector(31 downto 0);
            
            fail: out std_logic
        );
    end component;

    -- Controller
    component controller is
        port (
            rst, clk: in std_logic;
            start: in std_logic;
            done : out std_logic;
    
            -- counter control signal
            j_zero_rst, j_zero_cnt: out std_logic;
            j_one_rst, j_one_cnt: out std_logic;
            i_one_rst, i_one_cnt: out std_logic;
            j_0max,j_1max, i_1max: in std_logic;
    
            -- register control signal
	        pixel_in_ld, pixel_out_ld: out std_logic;
	        pixel_out_left_ld, pixel_out_above_ld, pixel_out_diag_ld: out std_logic;
	
	        -- memory control signal
            mem_w_en, mem_r_en : out std_logic;
	        mem_w_select : out std_logic;
	        mem_addr_select: out std_logic_vector(2 downto 0);
	        
	        fail: in std_logic;
	        error: out std_logic
        );
    end component;

    -- Integral_image
    component integral_image is
        port (
            rst, clk: in std_logic;
            start: in std_logic;
            done : out std_logic;
    
            M, N: in std_logic_vector(8 downto 0);
            base_addr_in, base_addr_out: in std_logic_vector(17 downto 0);
    
            mem_read_data: in std_logic_vector(31 downto 0);
	        mem_w_en,mem_r_en: out std_logic;
	        mem_write_data: out std_logic_vector(31 downto 0);
	        mem_addr: out std_logic_vector(17 downto 0);
	        error: out std_logic
        );
    end component;
end lib;