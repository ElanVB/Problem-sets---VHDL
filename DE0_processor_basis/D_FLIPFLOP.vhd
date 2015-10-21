-- author: R.D. Beyers
-- updated on 29/04/2015
-- STELLENBOSCH UNIVERSITY

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY D_FLIPFLOP IS
	PORT
	(
		D		:		IN STD_LOGIC; -- data input
		EN		:		IN STD_LOGIC; -- enable the input
		OE		:		IN STD_LOGIC; -- enable the output
		CLK_N	:		IN STD_LOGIC; -- negative edge triggered clock
		PR_N	:		IN STD_LOGIC; -- NOT preset (active low)
		CL_N	:		IN STD_LOGIC; -- NOT clear (active low)
		Q		:		INOUT STD_LOGIC -- data output (tri-state)
	);
END D_FLIPFLOP;

ARCHITECTURE STRUCTURE OF D_FLIPFLOP IS
	SIGNAL NEXT_STATE	:	STD_LOGIC;
	SIGNAL CURR_STATE	:	STD_LOGIC := '0';
BEGIN
	-- set outputs to high impedance if output not enabled
	Q <= CURR_STATE WHEN OE = '1' ELSE 'Z';
	NEXT_STATE <= D;
	
	PROCESS(CLK_N,PR_N,CL_N)
	BEGIN
		-- preset or reset/clear the flip-flop state
		IF PR_N = '0' AND CL_N = '1' THEN
			CURR_STATE <= '1';
		ELSIF PR_N = '1' AND CL_N = '0' THEN
			CURR_STATE <= '0';	
		-- make the next state the current state on active (negative) clock edge	
		ELSIF CLK_N'EVENT AND CLK_N = '0' THEN
			IF PR_N = '1' AND CL_N = '1' AND EN = '1' THEN
				CURR_STATE <= NEXT_STATE;			
			END IF;
		END IF;
	END PROCESS;

END STRUCTURE;
