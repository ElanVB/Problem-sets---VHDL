-- author: R.D. Beyers
-- updated on 29/04/2015
-- STELLENBOSCH UNIVERSITY

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity that reads an instruction from flash memory
ENTITY INSTRUCTION_READER IS
	PORT
	(	
		INSTR_NUMBER	 	:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- the current instruction number
		INCR_INSTR_NUMBER_NE:	IN STD_LOGIC; -- the current instruction number is incremented on the negative edge of this signal
		CLK_IN				:	IN STD_LOGIC; -- clk input of the instruction reader component
		INSTR_BYTE1			:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- the first instruction byte
		INSTR_BYTE2			:	INOUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- the second instruction byte
		OE					:	IN STD_LOGIC; -- enables/disables the output of the second instruction byte (tri-state) on the shared data bus
		EN					:	IN STD_LOGIC; -- enables/ disables the instruction reader component
		SET_INSTR_NUMBER	:	IN STD_LOGIC; -- causes the instruction reader to set the current instruction number to whatever is on the shared data bus
		RESET_INSTR_NUMBER	:	IN STD_LOGIC; -- signal causes the instruction reader to reset the current instruction number to "00000000"
		RESET_N				:	IN STD_LOGIC; -- signal causes the instruction reader to reset the current instruction number to "00000000" (different source from above)
		
		-- 50MHz in-circuit clock
		CLOCK_50 			: IN STD_LOGIC; -- the 50 MHz clock on the DE0 board
		 
		-- Flash memory ports
		FL_BYTE_N 			: 	OUT STD_LOGIC; -- sets the mode (byte/word) of the flash memory chip on the DE0 board
		FL_CE_N 			:	OUT STD_LOGIC; -- chip enable 
		FL_OE_N 			:	OUT STD_LOGIC; -- output enable 
		FL_RST_N 			:	OUT STD_LOGIC; -- hardware reset 
		FL_RY 				: 	IN STD_LOGIC; -- ready/busy output (INput here because it is read here)
		FL_WE_N 			: 	OUT STD_LOGIC; -- write enable 
		FL_WP_N 			: 	IN STD_LOGIC; -- hardware write protect 
		FL_DQ15_AM1 		: 	INOUT STD_LOGIC; -- data input/output in word mode, or LSB address input in byte mode
		FL_ADDR 			: 	OUT STD_LOGIC_VECTOR(21 DOWNTO 0); -- address inputs
		FL_DQ 				: 	INOUT STD_LOGIC_VECTOR(14 DOWNTO 0); -- data inputs/outputs
		
		D_BUS_LIVE			:	IN STD_LOGIC -- detect whetheror not the shared data bus is being used
	);
END INSTRUCTION_READER;

ARCHITECTURE STRUCTURE OF INSTRUCTION_READER IS
	SIGNAL DEFAULT_MEM_SECTOR	:	STD_LOGIC_VECTOR(13 DOWNTO 0);
	SIGNAL CURRENT_MEM_ADDR		:	STD_LOGIC_VECTOR(21 DOWNTO 0);
	SIGNAL MEM_CLK				:	STD_LOGIC;
	SIGNAL INSTR_NUMBER_SIG		:	STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL TEMP_BYTE1			: 	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL TEMP_BYTE2			:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL DO_RESET			:	STD_LOGIC; -- signal that can be activated either by RESET_N or RESET_INSTR_NUMBER
BEGIN
	-- Set the address to read from, consisting of the sector address and 
	-- the current instruction address.
	DEFAULT_MEM_SECTOR <= "00000000100000";
	CURRENT_MEM_ADDR(21 DOWNTO 8) <= DEFAULT_MEM_SECTOR(13 DOWNTO 0);
	CURRENT_MEM_ADDR(7 DOWNTO 0)  <= INSTR_NUMBER_SIG(7 DOWNTO 0);
	
	-- set-up the tri-state outputs
	INSTR_BYTE1 <= TEMP_BYTE1;
	INSTR_NUMBER <= INSTR_NUMBER_SIG;
	INSTR_BYTE2 <= TEMP_BYTE2 WHEN ((OE = '1') AND (D_BUS_LIVE = '0')) ELSE "ZZZZZZZZ";
	
	-- Set-up flash memory for reading from memory in byte-mode
	FL_WE_N <= '1';	
	FL_RST_N <= '1';
	FL_BYTE_N <= '0';
	
	-- Process to read flash memory
	PROCESS (MEM_CLK, CLK_IN)	
		VARIABLE CURR_STATE		:	INTEGER RANGE 1 TO 6 := 6;	
		VARIABLE MEM_ENABLED	:	STD_LOGIC := '0';
	BEGIN
		IF CLK_IN = '0' THEN
			MEM_ENABLED := '0';
		ELSIF CLK_IN'EVENT AND CLK_IN = '1' THEN
			IF MEM_ENABLED = '0' THEN
				MEM_ENABLED := '1';
			END IF;
		END IF;
		IF MEM_ENABLED = '0' THEN
			CURR_STATE := 1;			
		ELSIF MEM_CLK'EVENT AND MEM_CLK = '1' AND MEM_ENABLED = '1' THEN
			IF CURR_STATE = 1 THEN -- set address, enable chip, enable output, choose upper or lower byte
				CURR_STATE := 2;
				FL_ADDR <= CURRENT_MEM_ADDR;
				FL_CE_N <= '0';
				FL_OE_N <= '0';
				FL_DQ15_AM1 <= '0';
			ELSIF CURR_STATE = 2 THEN -- read byte
				CURR_STATE := 3;
				TEMP_BYTE2 <= FL_DQ(7 DOWNTO 0);
			ELSIF CURR_STATE = 3 THEN -- reset
				CURR_STATE := 4;
				FL_CE_N <= '1';
				FL_OE_N <= '1';
			ELSIF CURR_STATE = 4 THEN -- set address, enable chip, enable output, choose upper or lower byte
				CURR_STATE := 5;
				FL_ADDR <= CURRENT_MEM_ADDR;
				FL_CE_N <= '0';
				FL_OE_N <= '0';
				FL_DQ15_AM1 <= '1';
			ELSIF CURR_STATE = 5 THEN -- read byte
				CURR_STATE := 6;				
				TEMP_BYTE1 <= FL_DQ(7 DOWNTO 0);
			ELSE -- reset
				CURR_STATE := 6;
				FL_CE_N <= '1';
				FL_OE_N <= '1';
			END IF;
		END IF;
	END PROCESS;
	
	-- instruction increment/reset process
	PROCESS (RESET_N,RESET_INSTR_NUMBER,INCR_INSTR_NUMBER_NE,SET_INSTR_NUMBER,INSTR_BYTE2,INSTR_NUMBER_SIG)
		VARIABLE RESET_FLAG				:	STD_LOGIC;
		VARIABLE SET_INSTR_NUMBER_FLAG	:	STD_LOGIC;
		VARIABLE DO_RESET_INSTR			:	STD_LOGIC;
		VARIABLE DO_NORMAL_RESET		:	STD_LOGIC;
		VARIABLE NEXT_INSTR_NUMBER		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	BEGIN
		RESET_FLAG := DO_NORMAL_RESET OR DO_RESET_INSTR;
		IF SET_INSTR_NUMBER_FLAG = '1' THEN
			NEXT_INSTR_NUMBER := INSTR_BYTE2;
			INSTR_NUMBER_SIG <= NEXT_INSTR_NUMBER;
		ELSIF RESET_FLAG = '1' THEN			
			NEXT_INSTR_NUMBER := "00000000";
			INSTR_NUMBER_SIG <= NEXT_INSTR_NUMBER;
		ELSIF INCR_INSTR_NUMBER_NE'EVENT AND INCR_INSTR_NUMBER_NE = '0' THEN
			INSTR_NUMBER_SIG <= std_logic_vector(unsigned(INSTR_NUMBER_SIG) + 1);	
		END IF;
		IF NEXT_INSTR_NUMBER = "00000000" THEN
			RESET_FLAG := '0';
		END IF;
		IF DO_NORMAL_RESET = '1' THEN
			DO_NORMAL_RESET := '0';			
		ELSIF RESET_N = '0' THEN
			DO_NORMAL_RESET := '1';
		ELSIF RESET_N'EVENT AND RESET_N = '0' THEN
			DO_NORMAL_RESET := '1';
		END IF;
		IF DO_RESET_INSTR = '1' THEN
			DO_RESET_INSTR := '0';			
		ELSIF RESET_INSTR_NUMBER'EVENT AND RESET_INSTR_NUMBER = '1' THEN
			DO_RESET_INSTR := '1';
		END IF;
		IF INSTR_NUMBER_SIG = INSTR_BYTE2 THEN
			SET_INSTR_NUMBER_FLAG := '0';
		ELSIF SET_INSTR_NUMBER'EVENT AND SET_INSTR_NUMBER = '1' THEN
			SET_INSTR_NUMBER_FLAG := '1';
		END IF;		
	END PROCESS;
	
	-- Clock divider: 50 MHz to 5 MHz, Flash memory max clock speed is 20 MHz.
	PROCESS (CLOCK_50,EN)
		VARIABLE MEM_CLK_COUNT  :	INTEGER RANGE 0 TO 5;
	BEGIN
		IF CLOCK_50'EVENT AND CLOCK_50 = '1' AND EN = '1' THEN
			MEM_CLK_COUNT := MEM_CLK_COUNT + 1;
			IF MEM_CLK_COUNT = 5 THEN
				MEM_CLK_COUNT := 0;
				MEM_CLK <= NOT MEM_CLK;
			END IF;
		END IF;
	END PROCESS;
	
END STRUCTURE;

