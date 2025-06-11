library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controller is
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
end controller;

architecture rtl of controller is
--    signal state : std_logic_vector(5 downto 0);
    type state_type is (error_check, err, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12,
    s13, s14, s15, s16, s17, s18, s19, s20, s21, s22);
    signal state: state_type;
begin
    process(clk,rst)
    begin
        if (rst = '1') then state <= s0;
        elsif (clk'event and clk = '1') then
            case state is
                when s0 => 
	                state <= s1;
                when s1 => 
	                if start = '1' then 
	                    state <= error_check;
	                end if;
	            when error_check =>
	                if fail = '1' then 
	                    state <= err;
	                else
	                    state <= s2;
	                end if;
	            when err =>
	                state <= s21;
	            when s2 => 
	                state <= s3;
	            when s3 => 
	                if j_0max = '1' then
	                    state <= s5;
	                else 
	                    state <= s4;
	                end if;
	            when s4 => 
	                state <= s3;
	            when s5 => 
	                state <= s6;		
	            when s6 => 
	                if I_1max = '1' then 
	                    state <= s8;
	                else 
	                    state <= s7;
	                end if;
	            when s7 => 
	                state <= s6;
	            when s8 => 
	                state <= s9;
	            when s9 => 
	                if i_1max = '1' then 
	                    state <= s20;
	                else 
	                    state <= s10;
	                end if;
	            when s10 => 
	                    state <= s11;
	            when s11 => 
	                if j_1max = '1' then 
	                    state <= s19;
	                else 
	                    state <= s12;
	                end if;
	            when s12 => 
	                state <= s13;
	            when s13 => 
	                state <= s14;
	            when s14 =>
	                state <= s15;
	            when s15 => 
	                state <= s16;
	            when s16 =>
	                state <= s17;
	            when s17 => 
	                state <= s18;
	            when s18 =>
	                state <= s11;
	            when s19 => 
	                state <= s9;
	            when s20 => 
	                state <= s21;
	            when s21 => 
	                state <= s22;
	            when s22 =>
	                state <= s0;		
	            when others =>
	                state <= s0;				
	        end case;
        end if;
    end process;
    
    -- counter control signal
    j_zero_rst <= '1' when state = s0 or state = s2 else '0';
    j_zero_cnt <= '1' when state = s4 else '0';
    j_one_rst <= '1' when state = s0 or state = s10 else '0';
    j_one_cnt <= '1' when state = s18 else '0';
    i_one_rst <= '1' when state = s0 or state = s8 or state = s5 else '0';
    i_one_cnt <= '1' when state = s19 or state = s7 else '0';

    -- register control signal
    pixel_in_ld <= '1' when state = s13 else '0';
    pixel_out_left_ld <= '1' when state = s14 else '0';
    pixel_out_above_ld <= '1' when state = s15 else '0';
    pixel_out_diag_ld <= '1' when state = s16 else '0';
    pixel_out_ld <= '1' when state = s17 else '0';
    
    -- memory control signal
    mem_w_en <= '1' when (state = s4 or state = s7 or state = s18) else '0';
    mem_r_en <= '1' when (state = s12 or state = s13 or state = s14 or state = s15) else '0';
    
    -- memory access
    mem_w_select <= '1' when state = s18 else '0';
    mem_addr_select <= "000" when state = s4 else
		               "001" when state = s7 else
		               "010" when state = s12 else
		               "011" when state = s13 else
		               "100" when state = s14 else
		               "101" when state = s15 else
		               "110" when state = s18 else "111";

    error <= '1' when state = err else '0';
    done <= '1' when state = s20 else '0';
end rtl;