-- author: R.D. Beyers
-- updated on 29/04/2015
-- STELLENBOSCH UNIVERSITY

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ADDER IS
	PORT
	(
		SEL			:	IN  STD_LOGIC; -- select which byte will be loaded
		EN			:	IN 	STD_LOGIC; -- enable/disable the adder
		CLK_N		:	IN  STD_LOGIC; -- clock input
		OE			:	IN	STD_LOGIC; -- enable/disable outputs on the shared data bus
		DATA		:	INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);	-- the data inputs/outputs
		D_BUS_LIVE	:	IN STD_LOGIC -- detect whetheror not the shared data bus is being used
	);
END ADDER;

ARCHITECTURE STRUCTURE OF ADDER IS
	SIGNAL NUM1		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL NUM2		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL DATA_IN	:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL DATA_OUT	:	STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN	
	PROCESS(CLK_N)
	BEGIN		
		IF CLK_N'EVENT AND CLK_N = '0' THEN
			IF EN = '1' AND OE = '0' THEN
				IF SEL = '0' THEN 
					NUM1 <= DATA_IN;
				ELSIF SEL = '1' THEN
					NUM2 <= DATA_IN;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	DATA_OUT <= STD_LOGIC_VECTOR(UNSIGNED(NUM1) + UNSIGNED(NUM2));	
	DATA_IN <= DATA;
	DATA <= DATA_OUT WHEN ((OE = '1') AND (D_BUS_LIVE = '0')) ELSE "ZZZZZZZZ";
	
END STRUCTURE;
