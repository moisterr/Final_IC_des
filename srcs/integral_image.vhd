library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.lib.ALL;

entity integral_image is
    port (
    rst, clk: in std_logic;
    start: in std_logic;
    done : out std_logic;
    
    M, N: in std_logic_vector(8 downto 0);
    base_addr_in, base_addr_out: in std_logic_vector(17 downto 0);
    
    mem_addr: out std_logic_vector(17 downto 0);
	mem_r_en,mem_w_en: out std_logic;
	mem_read_data: in std_logic_vector(31 downto 0);
	mem_write_data: out std_logic_vector(31 downto 0);
	error: out std_logic
    );
end integral_image;
    
architecture rtl of integral_image is
    signal j_zero_rst, j_zero_cnt: std_logic;
    signal j_one_rst, j_one_cnt: std_logic;
    signal i_one_rst, i_one_cnt: std_logic;
    signal j_0max,j_1max, i_1max: std_logic;

    signal pixel_in_ld,pixel_out_ld: std_logic;
    signal pixel_out_left_ld,pixel_out_above_ld,pixel_out_diag_ld: std_logic;

    signal mem_w_select: std_logic;
    signal mem_addr_select: std_logic_vector(2 downto 0);
    
    signal fail: std_logic;
    
begin
    control_unit: controller
	   port map(
           rst => rst,
           clk => clk,
           start => start,
           done => done,
           
           j_zero_rst => j_zero_rst,
           j_zero_cnt => j_zero_cnt,
           j_one_rst => j_one_rst,
           j_one_cnt => j_one_cnt,
           i_one_rst => i_one_rst,
           i_one_cnt => i_one_cnt,
           j_0max => j_0max,
           j_1max => j_1max,
           i_1max => i_1max,

	
	       pixel_in_ld => pixel_in_ld,
	       pixel_out_ld => pixel_out_ld,
	       pixel_out_left_ld => pixel_out_left_ld,
	       pixel_out_above_ld => pixel_out_above_ld,
	       pixel_out_diag_ld => pixel_out_diag_ld,

           mem_w_en => mem_w_en, 
           mem_r_en => mem_r_en,
	       mem_w_select => mem_w_select,
	       mem_addr_select => mem_addr_select,
	       
	       fail => fail,
           error => error
	   );
	
	datapath_unit : datapath
	   port map(
           rst => rst,
	       clk => clk,
	       M => M,
	       N => N, 
	       base_addr_in => base_addr_in,
           base_addr_out => base_addr_out,
	       
	       j_zero_rst => j_zero_rst,
           j_zero_cnt => j_zero_cnt,
           j_one_rst => j_one_rst,
           j_one_cnt => j_one_cnt,
           i_one_rst => i_one_rst,
           i_one_cnt => i_one_cnt,
           j_0max => j_0max,
           j_1max => j_1max,
           i_1max => i_1max,
	
	       pixel_in_ld => pixel_in_ld,
	       pixel_out_ld => pixel_out_ld,
	       pixel_out_left_ld => pixel_out_left_ld,
	       pixel_out_above_ld => pixel_out_above_ld,
	       pixel_out_diag_ld => pixel_out_diag_ld,

	       mem_addr_select => mem_addr_select,
	       mem_w_select => mem_w_select,
           mem_read_data => mem_read_data,
           mem_addr => mem_addr,
           mem_write_data => mem_write_data,
           
           fail => fail
       );
end rtl;