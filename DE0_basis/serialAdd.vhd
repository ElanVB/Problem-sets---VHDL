LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY altera;
use altera.altera_primitives_components.all;

entity serialAdd is
port(	read_n, clk 	: 	in 		std_logic;
		ser 				: 	inout 	std_logic);
end serialAdd;

