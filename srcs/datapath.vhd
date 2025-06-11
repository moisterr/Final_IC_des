library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.lib.ALL;

entity datapath is
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
	
	-- memory signal
	base_addr_in, base_addr_out: in std_logic_vector(17 downto 0);
	mem_w_select: in std_logic;
	mem_addr_select: in std_logic_vector(2 downto 0);
	mem_read_data: in std_logic_vector(31 downto 0);
    mem_addr: out std_logic_vector(17 downto 0);
    mem_write_data: out std_logic_vector(31 downto 0);
    
    fail: out std_logic
    );
end datapath;

architecture rtl of datapath is
    constant max_addr : std_logic_vector(17 downto 0) := (others => '1');
    signal M_out, N_out :std_logic_vector(8 downto 0) ;
    signal add_row1, add_col1: std_logic_vector(17 downto 0);
    signal j_0out, j_1out, i_1out: std_logic_vector(8 downto 0);
    signal add_in: std_logic_vector(17 downto 0);
    signal add_out: std_logic_vector(17 downto 0);
    signal add_out_left: std_logic_vector(17 downto 0);
    signal add_out_above: std_logic_vector(17 downto 0);
    signal add_out_diag: std_logic_vector(17 downto 0);
    signal pixel_in, pixel_out_in, pixel_out_out: std_logic_vector(31 downto 0);
    signal pixel_out_left,pixel_out_above,pixel_out_diag: std_logic_vector(31 downto 0);
begin

    fail <= '1' when (M < 5 or N < 5 or M > 256 or N > 256
    or (base_addr_out < base_addr_in + M * N
    and base_addr_out > base_addr_in - M_out * N_out)
    or base_addr_out > max_addr - M_out * N_out) else '0'; 
    
    M_out <= M + 1;
    N_out <= N + 1;

    -- counter
    j_count_from_0 : up_counter
    generic map (start => (others => '0'))
        PORT map(
            clk => clk,
            inc => j_zero_cnt,
            rst => j_zero_rst,
            z => j_0max,
            count => j_0out,
            stop => M_out
        );
    j_count_from_1 : up_counter
    generic map (start => (0 => '1', others => '0'))
        PORT map(
            clk => clk,
            inc => j_one_cnt,
            rst => j_one_rst,
            z => j_1max,
            count => j_1out,
            stop => M_out
        );
    i_count_from_1 : up_counter
    generic map (start => (0 => '1', others => '0'))
        PORT map(
            clk => clk,
            inc => i_one_cnt,
            rst => i_one_rst,
            z => i_1max,
            count => i_1out,
            stop => N_out
        );
  
    -- address to access
    add_row1 <= base_addr_out + j_0out;
    add_col1 <= base_addr_out + M_out * i_1out;
    add_in <= base_addr_in + (i_1out - 1) * M + j_1out - 1;
    add_out <= base_addr_out + i_1out * M_out + j_1out;
    add_out_left <= base_addr_out + i_1out * M_out + j_1out - 1;
    add_out_above <= base_addr_out + (i_1out - 1) * M_out + j_1out;
    add_out_diag <= base_addr_out + (i_1out - 1) * M_out + j_1out - 1;

    -- address multiplexer
    mem_addr <= add_row1 when mem_addr_select = "000" else
		        add_col1 when mem_addr_select = "001" else
		        add_in when mem_addr_select = "010" else
		        add_out_left when mem_addr_select = "011" else
		        add_out_above when mem_addr_select = "100" else
		        add_out_diag when mem_addr_select = "101" else
		        add_out when mem_addr_select = "110" else (others => '0');

    -- register
    pixel_in_reg: reg
        port map (
	       rst => rst,
	       clk => clk,
	       en => pixel_in_ld,
	       d => mem_read_data,
	       q => pixel_in
        );
    pixel_out_left_reg: reg
        port map (
	       rst => rst,
	       clk => clk,
	       en => pixel_out_left_ld,
	       d => mem_read_data,
	       q => pixel_out_left
        );
    pixel_out_above_reg: reg
        port map (
	       rst => rst,
	       clk => clk,
	       en => pixel_out_above_ld,
	       d => mem_read_data,
	       q => pixel_out_above
        );
    pixel_out_diag_reg: reg
        port map (
	       rst => rst,
	       clk => clk,
	       en => pixel_out_diag_ld,
	       d => mem_read_data,
	       q => pixel_out_diag
        );
    pixel_out_reg: reg
        port map (
	       rst => rst,
	       CLK => clk,
	       en => pixel_out_ld,
	       d => pixel_out_in,
	       q => pixel_out_out
        );
        
    -- calculate pixel_out
    pixel_out_in <= pixel_in + pixel_out_left + pixel_out_above - pixel_out_diag;
    
    -- data multiplexer
    mem_write_data <= pixel_out_out when mem_w_select = '1' else (others => '0');

end rtl;