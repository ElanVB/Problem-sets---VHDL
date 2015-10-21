LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY altera;
use altera.altera_primitives_components.all;

entity flipflop_e is 
port	(	d, clk, preset, clear 	: in std_logic; 
			q, nq							: inout std_logic);
end flipflop_e;

architecture flip of flipflop_e is
begin

process(d, clk, preset, clear)
begin
	if preset = '0' then
		q <= '1';
		
	elsif clear = '0' then
		q <= '0';
		
	elsif clk'event and clk = '1' then
		q <= d;
		
	end if;

end process;

nq <= not q;

end flip;