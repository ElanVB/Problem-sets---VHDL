LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY altera;
use altera.altera_primitives_components.all;

entity counter is
port	(	en, load, clk 	:	in 	std_logic;
			d 					:  in 	std_logic_vector(3 downto 0);
			q 					:	inout 	std_logic_vector(3 downto 0));
end counter;

architecture counter_a of counter is
begin

process(clk)
begin
	
	if load = '1' then
		q <= d;
		
	elsif en = '1' then
	
		if clk'event and clk = '1' then
			q <= std_logic_vector(unsigned(q) + 1);
		end if;
		
	end if;
end process;
end counter_a;
