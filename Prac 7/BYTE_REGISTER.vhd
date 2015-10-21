-- author: R.D. Beyers
-- updated on 29/04/2015
-- STELLENBOSCH UNIVERSITY

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY BYTE_REGISTER IS
	PORT
	(
		D		:		IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- data inputs
		EN		:		IN STD_LOGIC; -- enable the 8-bit (byte) register
		OE		:		IN STD_LOGIC; -- enable the outputs of the register
		CLK_N	:		IN STD_LOGIC; -- negative edge triggered clock
		PR_N	:		IN STD_LOGIC; -- NOT preset (active low)
		CL_N	:		IN STD_LOGIC; -- NOT clear (active low)
		Q		:		INOUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- data outputs (tri-state)
	);
END BYTE_REGISTER;

ARCHITECTURE STRUCTURE OF BYTE_REGISTER IS
	COMPONENT D_FLIPFLOP
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
	END COMPONENT;
BEGIN	
	-- instantiate a single flip-flop for bit0
	flipflop0: D_FLIPFLOP PORT MAP (D => D(0), EN => EN, OE => OE, CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q(0));
	-- instantiate a single flip-flop for bit1
	flipflop1: D_FLIPFLOP PORT MAP (D => D(1), EN => EN, OE => OE, CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q(1));
	-- instantiate a single flip-flop for bit2
	flipflop2: D_FLIPFLOP PORT MAP (D => D(2), EN => EN, OE => OE, CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q(2));
	-- instantiate a single flip-flop for bit3
	flipflop3: D_FLIPFLOP PORT MAP (D => D(3), EN => EN, OE => OE, CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q(3));
	-- instantiate a single flip-flop for bit4
	flipflop4: D_FLIPFLOP PORT MAP (D => D(4), EN => EN, OE => OE, CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q(4));
	-- instantiate a single flip-flop for bit5
	flipflop5: D_FLIPFLOP PORT MAP (D => D(5), EN => EN, OE => OE, CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q(5));
	-- instantiate a single flip-flop for bit6
	flipflop6: D_FLIPFLOP PORT MAP (D => D(6), EN => EN, OE => OE, CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q(6));
	-- instantiate a single flip-flop for bit7
	flipflop7: D_FLIPFLOP PORT MAP (D => D(7), EN => EN, OE => OE, CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q(7));	
END STRUCTURE;
