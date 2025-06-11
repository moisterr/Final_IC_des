library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.lib.all;

library std;
use std.textio.all;

entity integral_image_tb_imp is
end integral_image_tb_imp;

architecture tb of integral_image_tb_imp is
    constant clk_period : time := 10 ns;
    signal clk_imp : std_logic := '0';
    signal clk : std_logic := '0';
    signal start,rst : std_logic;
    
    signal M, N: std_logic_vector(8 downto 0);
    signal base_addr_in, base_addr_out: std_logic_vector(17 downto 0);
    
    signal mem_addr: std_logic_vector(17 downto 0);
    signal mem_read_data, mem_write_data: std_logic_vector(31 downto 0) ;
    signal mem_w_en,mem_r_en: std_logic;
    signal done: std_logic;
    signal error: std_logic;
begin

	clk <= not clk after clk_period / 2;
	
	clk_implement_process : process
begin
    wait for 3 ns; 
    while true loop
        clk_imp <= '0';
        wait for clk_period / 2;
        clk_imp <= '1';
        wait for clk_period / 2;
    end loop;
end process;

	dut : integral_image
        port map(
            rst => rst,
	        clk => clk_imp, 
	        start => start,
	        
	        M => M,
            N => N,
            base_addr_in => base_addr_in, 
	        base_addr_out => base_addr_out,
	        
	        mem_w_en => mem_w_en,
	        mem_r_en => mem_r_en,
	        mem_read_data => mem_read_data,
	        mem_write_data => mem_write_data,
	        mem_addr => mem_addr,
	        
            done => done,
            error => error
    	);
	memory_unit : memory
	   port map(
	        clk => clk,
	        addr => mem_addr,
            we_in => mem_w_en,
            re_in => mem_r_en,
            d_in => mem_write_data,
            d_out => mem_read_data
	    );
	    
    stimulus: process
        begin	

	        M <= std_logic_vector(to_unsigned(5, 9));
            N <= std_logic_vector(to_unsigned(5, 9));
	        base_addr_in <= std_logic_vector(to_unsigned(0, 18));
            base_addr_out <= std_logic_vector(to_unsigned(50, 18));
        
	        rst <= '1';
	        wait for clk_period;
            rst <= '0';
            start <= '1';
	        wait until done = '1';
	        start <= '0';
	        wait for 5 * clk_period;
	        wait;
    end process; 
    monitor: process(clk)
    begin
        if rising_edge(clk) then
            if (mem_w_en = '1') then
            report "writing" & " data = " & integer'image(conv_integer(mem_write_data)) & " at address = " 
            & integer'image(conv_integer(mem_addr)) & " of memory";
            end if;
        end if;
    end process;
    
    ok: process(done)
    begin
        if rising_edge(done) then
            report "Complete";
        end if;
    end process;
    
    error_ann: process(error)
    begin
        if rising_edge(error) then
            report "Error";
        end if;
    end process;
end tb;