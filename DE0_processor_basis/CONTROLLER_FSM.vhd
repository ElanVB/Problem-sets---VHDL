-- author: R.D. Beyers
-- updated on 29/04/2015
-- STELLENBOSCH UNIVERSITY

-- TODO: COMPLETE THE ARCHITECTURE OF THIS ENTITY

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CONTROLLER_FSM IS
	PORT
		(
			JUMP_COND			:	IN STD_LOGIC; -- attached to LSB of D_BUS and used as condition for coniditional jump
			COMP_EN				:	OUT STD_LOGIC; -- enable/disable comparator component
			COMP_OE				:	OUT STD_LOGIC; -- enable/disable outputs of comparator on the shared data bus
			COMP_SEL			:	OUT STD_LOGIC; -- select which byte will be loaded into the comparator 
			SPEC_REG_WR_N		:	OUT STD_LOGIC; -- special register not write enable
			SPEC_REG_RE_N		:	OUT STD_LOGIC; -- special register not read enable
			ARITH_EN			:	OUT STD_LOGIC; -- enable/disable adder component
			ARITH_OE			:	OUT STD_LOGIC; -- enable/disable outputs of the adder on the shared data bus
			ARITH_SEL			:	OUT STD_LOGIC; -- select which byte will be loaded into the adder 
			RESET_N				:	IN STD_LOGIC; -- reset input (connected to button(0))
			RESET_INSTR_NUMBER	:	OUT STD_LOGIC; -- reset instruction number to "00000000"
			SET_INSTR_NUMBER	:	OUT STD_LOGIC; -- set instruction number to whatever is on the data bus
			INSTR				:	IN 	STD_LOGIC_VECTOR(3 DOWNTO 0); -- the current instruction
			INSTR_EN			:	OUT STD_LOGIC; -- enable/disable the instruction reader component
			INSTR_OE			:	OUT STD_LOGIC; -- enable/disable the outputs (instruction byte 2) on the shared data bus
			SEL_ADDR			:	OUT STD_LOGIC; -- select the address source for WR_ADDR of the register bank
			REG_CPY_N			:	OUT STD_LOGIC; -- select copy/output mode of the register
			REG_WR_N			:	OUT	STD_LOGIC; -- enable/disable register writing
			REG_RE_N			:	OUT	STD_LOGIC; -- enable/disable register reading
			REG_PR_N			:	OUT	STD_LOGIC; -- preset all register bits to '1'
			REG_CL_N			:	OUT STD_LOGIC; -- clear all register bits to '0'
			DISP_EN				:	OUT STD_LOGIC; -- enable/disable the 7-segment display unit
			DISP_BYTE_SELECT	:	OUT	STD_LOGIC; -- select which 7-segment pair to display on
			DISP_PWR			:	OUT	STD_LOGIC; -- power the display unit on/off			
			INCR_INSTR_NUMBER_NE:	OUT	STD_LOGIC; -- increment the current instruction number (active on negative edge)			
			CLK_IN				:	IN STD_LOGIC -- clock input (use cpu clock)
		);
END CONTROLLER_FSM;

ARCHITECTURE STRUCTURE OF CONTROLLER_FSM IS
BEGIN
END STRUCTURE;
