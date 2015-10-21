LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY altera;
use altera.altera_primitives_components.all;


ENTITY GenericClockDivider IS
generic (divisor : integer range 0 to 1000 := 1); -- # of inputs
PORT (inCLK : IN STD_LOGIC;
outCLK : OUT STD_LOGIC);
END GenericClockDivider;
ARCHITECTURE anything OF GenericClockDivider IS
BEGIN
PROCESS (CLK)
VARIABLE CLKCount : integer range 0 to divisor := 0;
BEGIN
IF inCLK'EVENT AND inCLK = '1' THEN
IF (clkCount > divisor/2) then
outclk <= not inCLK; -- they pretended to make a new signal called subClock
-- invert subCLK
CLKCount := 0;
ELSE
CLKCount <= clkCount + 1;
END IF;
END IF;
end process;
END anything;