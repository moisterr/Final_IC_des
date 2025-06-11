library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory IS
    port (
        clk    : IN std_logic;
        we_in  : IN std_logic;
        re_in  : IN std_logic;
        addr   : IN std_logic_vector(17 downto 0); 
        d_in   : IN std_logic_vector(31 downto 0);
        d_out  : OUT std_logic_vector(31 downto 0)
    );
end memory;

architecture behavior of memory is
    type memory_data is array(0 to 262143) of std_logic_vector(31 downto 0);
    signal memory_array : memory_data := (
    -- Input image 5x5: 
    0  => std_logic_vector(to_unsigned(17, 32)),
    1  => std_logic_vector(to_unsigned(24, 32)),
    2  => std_logic_vector(to_unsigned(1, 32)),
    3  => std_logic_vector(to_unsigned(8, 32)),
    4  => std_logic_vector(to_unsigned(15, 32)),
    5  => std_logic_vector(to_unsigned(23, 32)),
    6  => std_logic_vector(to_unsigned(5, 32)),
    7  => std_logic_vector(to_unsigned(7, 32)),
    8  => std_logic_vector(to_unsigned(14, 32)),
    9  => std_logic_vector(to_unsigned(16, 32)),
    10  => std_logic_vector(to_unsigned(4, 32)),
    11  => std_logic_vector(to_unsigned(6, 32)),
    12  => std_logic_vector(to_unsigned(13, 32)),
    13  => std_logic_vector(to_unsigned(20, 32)),
    14  => std_logic_vector(to_unsigned(22, 32)),
    15  => std_logic_vector(to_unsigned(10, 32)),
    16  => std_logic_vector(to_unsigned(12, 32)),
    17  => std_logic_vector(to_unsigned(19, 32)),
    18  => std_logic_vector(to_unsigned(21, 32)),
    19  => std_logic_vector(to_unsigned(3, 32)),
    20  => std_logic_vector(to_unsigned(11, 32)),
    21  => std_logic_vector(to_unsigned(18, 32)),
    22  => std_logic_vector(to_unsigned(25, 32)),
    23  => std_logic_vector(to_unsigned(2, 32)),
    24  => std_logic_vector(to_unsigned(9, 32)),

-- Input image 8x8:
100 => std_logic_vector(to_unsigned(1, 32)),
101 => std_logic_vector(to_unsigned(2, 32)),
102 => std_logic_vector(to_unsigned(3, 32)),
103 => std_logic_vector(to_unsigned(4, 32)),
104 => std_logic_vector(to_unsigned(5, 32)),
105 => std_logic_vector(to_unsigned(6, 32)),
106 => std_logic_vector(to_unsigned(7, 32)),
107 => std_logic_vector(to_unsigned(8, 32)),

108 => std_logic_vector(to_unsigned(2, 32)),
109 => std_logic_vector(to_unsigned(3, 32)),
110 => std_logic_vector(to_unsigned(4, 32)),
111 => std_logic_vector(to_unsigned(5, 32)),
112 => std_logic_vector(to_unsigned(6, 32)),
113 => std_logic_vector(to_unsigned(7, 32)),
114 => std_logic_vector(to_unsigned(8, 32)),
115 => std_logic_vector(to_unsigned(9, 32)),

116 => std_logic_vector(to_unsigned(3, 32)),
117 => std_logic_vector(to_unsigned(4, 32)),
118 => std_logic_vector(to_unsigned(5, 32)),
119 => std_logic_vector(to_unsigned(6, 32)),
120 => std_logic_vector(to_unsigned(7, 32)),
121 => std_logic_vector(to_unsigned(8, 32)),
122 => std_logic_vector(to_unsigned(9, 32)),
123 => std_logic_vector(to_unsigned(10, 32)),

124 => std_logic_vector(to_unsigned(4, 32)),
125 => std_logic_vector(to_unsigned(5, 32)),
126 => std_logic_vector(to_unsigned(6, 32)),
127 => std_logic_vector(to_unsigned(7, 32)),
128 => std_logic_vector(to_unsigned(8, 32)),
129 => std_logic_vector(to_unsigned(9, 32)),
130 => std_logic_vector(to_unsigned(10, 32)),
131 => std_logic_vector(to_unsigned(11, 32)),

132 => std_logic_vector(to_unsigned(5, 32)),
133 => std_logic_vector(to_unsigned(6, 32)),
134 => std_logic_vector(to_unsigned(7, 32)),
135 => std_logic_vector(to_unsigned(8, 32)),
136 => std_logic_vector(to_unsigned(9, 32)),
137 => std_logic_vector(to_unsigned(10, 32)),
138 => std_logic_vector(to_unsigned(11, 32)),
139 => std_logic_vector(to_unsigned(12, 32)),

140 => std_logic_vector(to_unsigned(6, 32)),
141 => std_logic_vector(to_unsigned(7, 32)),
142 => std_logic_vector(to_unsigned(8, 32)),
143 => std_logic_vector(to_unsigned(9, 32)),
144 => std_logic_vector(to_unsigned(10, 32)),
145 => std_logic_vector(to_unsigned(11, 32)),
146 => std_logic_vector(to_unsigned(12, 32)),
147 => std_logic_vector(to_unsigned(13, 32)),

148 => std_logic_vector(to_unsigned(7, 32)),
149 => std_logic_vector(to_unsigned(8, 32)),
150 => std_logic_vector(to_unsigned(9, 32)),
151 => std_logic_vector(to_unsigned(10, 32)),
152 => std_logic_vector(to_unsigned(11, 32)),
153 => std_logic_vector(to_unsigned(12, 32)),
154 => std_logic_vector(to_unsigned(13, 32)),
155 => std_logic_vector(to_unsigned(14, 32)),

156 => std_logic_vector(to_unsigned(8, 32)),
157 => std_logic_vector(to_unsigned(9, 32)),
158 => std_logic_vector(to_unsigned(10, 32)),
159 => std_logic_vector(to_unsigned(11, 32)),
160 => std_logic_vector(to_unsigned(12, 32)),
161 => std_logic_vector(to_unsigned(13, 32)),
162 => std_logic_vector(to_unsigned(14, 32)),
163 => std_logic_vector(to_unsigned(15, 32)),

    others => (others => '0')
);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we_in = '1' then
                memory_array(conv_integer(addr)) <= d_in;
            elsif re_in = '1' then
                d_out <= memory_array(conv_integer(addr));
            else
                d_out <= (others => '0');
            end if;
        end if;
    end process;
end behavior;
