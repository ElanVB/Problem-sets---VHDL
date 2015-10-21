-- author: R.D. Beyers
-- updated on 29/04/2015
-- STELLENBOSCH UNIVERSITY

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY REGISTER_BANK IS
	PORT
	(
		D			:		INOUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input bus (connected to the shared data bus)
		CPY_N		:		IN STD_LOGIC; -- select whether to copy from one register to another, or not
		RE_ADDR		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- address to be read from
		WR_ADDR		:		IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- address to be written to
		WR_N		:		IN STD_LOGIC; -- enable writing
		RE_N		:		IN STD_LOGIC; -- enable reading
		CLK_N		:		IN STD_LOGIC; -- clock input (use cpu clock), this component is negative edge triggered
		PR_N		:		IN STD_LOGIC; -- preset input (all bits of all registers simultaneously)
		CL_N		:		IN STD_LOGIC; -- clear input (all bits of all registers simultaneously)
		Q			:		INOUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- data output (connected to the shared data bus)
		D_BUS_LIVE	:		IN STD_LOGIC -- detect whetheror not the shared data bus is being used
	);
END REGISTER_BANK;

ARCHITECTURE STRUCTURE OF REGISTER_BANK IS
	COMPONENT BYTE_REGISTER
		PORT
		(	
			D			:		IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- data inputs
			EN			:		IN STD_LOGIC; -- enable the 8-bit (byte) register
			OE			:		IN STD_LOGIC; -- enable the outputs of the register
			CLK_N		:		IN STD_LOGIC; -- negative edge triggered clock
			PR_N		:		IN STD_LOGIC; -- NOT preset (active low)
			CL_N		:		IN STD_LOGIC; -- NOT clear (active low)
			Q			:		INOUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- data outputs (tri-state)
		);
	END COMPONENT;
	SIGNAL D_INT		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Q_INT		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL DQ_INT		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL EN_ADDR		:	STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL OE_ADDR		:	STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL DEC_OE_ADDR	:	STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
	SIGNAL DEC_EN_ADDR	:	STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
BEGIN	

	-- connect the data outputs to the data inputs in copy mode, otherwise "ZZZZZZZZ"
	D_INT <= D WHEN CPY_N = '1' ELSE DQ_INT;
	DQ_INT <= Q_INT;
	Q <= Q_INT WHEN ((CPY_N = '1') AND (D_BUS_LIVE = '0')) ELSE "ZZZZZZZZ";

	WITH RE_ADDR(3 DOWNTO 0) SELECT 
		DEC_OE_ADDR <= "0000000000000001" WHEN "0000",
					  "0000000000000010" WHEN "0001",
					  "0000000000000100" WHEN "0010",
					  "0000000000001000" WHEN "0011",
					  "0000000000010000" WHEN "0100",
					  "0000000000100000" WHEN "0101",
					  "0000000001000000" WHEN "0110",
					  "0000000010000000" WHEN "0111",
					  "0000000100000000" WHEN "1000",
					  "0000001000000000" WHEN "1001",
					  "0000010000000000" WHEN "1010",
					  "0000100000000000" WHEN "1011",
					  "0001000000000000" WHEN "1100",
					  "0010000000000000" WHEN "1101",
					  "0100000000000000" WHEN "1110",
					  "1000000000000000" WHEN "1111";
			  
	WITH WR_ADDR(3 DOWNTO 0) SELECT 
		DEC_EN_ADDR <= "0000000000000001" WHEN "0000",
					  "0000000000000010" WHEN "0001",
					  "0000000000000100" WHEN "0010",
					  "0000000000001000" WHEN "0011",
					  "0000000000010000" WHEN "0100",
					  "0000000000100000" WHEN "0101",
					  "0000000001000000" WHEN "0110",
					  "0000000010000000" WHEN "0111",
					  "0000000100000000" WHEN "1000",
					  "0000001000000000" WHEN "1001",
					  "0000010000000000" WHEN "1010",
					  "0000100000000000" WHEN "1011",
					  "0001000000000000" WHEN "1100",
					  "0010000000000000" WHEN "1101",
					  "0100000000000000" WHEN "1110",
					  "1000000000000000" WHEN "1111";
	
	OE_ADDR <= DEC_OE_ADDR WHEN RE_N = '0' ELSE "0000000000000000";	
	EN_ADDR <= DEC_EN_ADDR WHEN WR_N = '0' ELSE "0000000000000000";
	
	-- instantiate a single register for byte0
	reg0: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(0), OE => OE_ADDR(0), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte1
	reg1: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(1), OE => OE_ADDR(1), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte2
	reg2: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(2), OE => OE_ADDR(2), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte3
	reg3: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(3), OE => OE_ADDR(3), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte4
	reg4: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(4), OE => OE_ADDR(4), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte5
	reg5: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(5), OE => OE_ADDR(5), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte6
	reg6: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(6), OE => OE_ADDR(6), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte7
	reg7: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(7), OE => OE_ADDR(7), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte8
	reg8: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(8), OE => OE_ADDR(8), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte9
	reg9: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(9), OE => OE_ADDR(9), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte10
	reg10: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(10), OE => OE_ADDR(10), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte11
	reg11: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(11), OE => OE_ADDR(11), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte12
	reg12: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(12), OE => OE_ADDR(12), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte13
	reg13: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(13), OE => OE_ADDR(13), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte14
	reg14: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(14), OE => OE_ADDR(14), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);
	-- instantiate a single register for byte15
	reg15: BYTE_REGISTER PORT MAP (D => D_INT, EN => EN_ADDR(15), OE => OE_ADDR(15), CLK_N => CLK_N, 
		PR_N => PR_N, CL_N => CL_N, Q => Q_INT);	
END STRUCTURE;
