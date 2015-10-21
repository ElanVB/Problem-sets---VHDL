-- author: R.D. Beyers
-- updated on 29/04/2015
-- STELLENBOSCH UNIVERSITY

LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY DE0 IS
	-- port definition of the DE0 board. These ports correspond with 
	-- the components on the board that are connected to the actual pins of the FPGA chip
	PORT
	(		
		CLOCK_50 : IN STD_LOGIC; -- 50MHz in-circuit clock
		LEDG : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- the 10 green LEDs on the DE0 board
		SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- the 10 switches on the DE0 board
		BUTTON : IN STD_LOGIC_VECTOR(0 TO 2);  -- the 3 buttons on the DE0 board
		HEX0_D : OUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display (right)
		HEX1_D : OUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display
		HEX2_D : OUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display
		HEX3_D : OUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display (left)
		-- inputs and outputs of the flash memory chip
		FL_BYTE_N : INOUT STD_LOGIC;
		FL_CE_N : OUT STD_LOGIC;
		FL_OE_N : OUT STD_LOGIC;
		FL_RST_N : INOUT STD_LOGIC;
		FL_RY : INOUT STD_LOGIC;
		FL_WE_N : INOUT STD_LOGIC;
		FL_WP_N : INOUT STD_LOGIC;
		FL_DQ15_AM1 : INOUT STD_LOGIC;
		-- PS2 port
		PS2_KBCLK : IN STD_LOGIC;
		PS2_KBDAT : IN STD_LOGIC;
		PS2_MSCLK : IN STD_LOGIC;
		PS2_MSDAT : IN STD_LOGIC;
		-- UART
		UART_RXD : IN STD_LOGIC;
		UART_TXD : IN STD_LOGIC;
		UART_RTS : IN STD_LOGIC;
		UART_CTS : IN STD_LOGIC;
		-- SD card reader
		SD_CLK : IN STD_LOGIC;
		SD_CMD : IN STD_LOGIC;
		SD_DAT0 : IN STD_LOGIC;
		SD_DAT3 : IN STD_LOGIC;
		SD_WP_N : IN STD_LOGIC;
		-- the (not included on board) LCD display
		LCD_RW : IN STD_LOGIC;
		LCD_RS : IN STD_LOGIC;
		LCD_EN : IN STD_LOGIC;
		LCD_BLON : IN STD_LOGIC;
		-- VGA port
		VGA_HS : IN STD_LOGIC;
		VGA_VS : IN STD_LOGIC;
		-- 7-segment display points
		HEX0_DP : INOUT STD_LOGIC;
		HEX1_DP : INOUT STD_LOGIC;
		HEX2_DP : INOUT STD_LOGIC;
		HEX3_DP : INOUT STD_LOGIC;
		-- DRAM memory chip
		DRAM_CAS_N : IN STD_LOGIC;
		DRAM_CS_N : IN STD_LOGIC;
		DRAM_CLK : IN STD_LOGIC;
		DRAM_CKE : IN STD_LOGIC;
		DRAM_BA_0 : IN STD_LOGIC;
		DRAM_BA_1 : IN STD_LOGIC;
		DRAM_LDQM : IN STD_LOGIC;
		DRAM_UDQM : IN STD_LOGIC;
		DRAM_RAS_N : IN STD_LOGIC;
		DRAM_WE_N : IN STD_LOGIC;
		-- another clock source
		CLOCK_50_2 : IN STD_LOGIC;
		-- two more inputs/outputs of the flash memory chip
		FL_ADDR : OUT STD_LOGIC_VECTOR(21 DOWNTO 0);
		FL_DQ : INOUT STD_LOGIC_VECTOR(14 DOWNTO 0);
		-- GPIOs
		GPIO0_D : INOUT STD_LOGIC_VECTOR(0 TO 31);
		GPIO0_CLKIN : IN STD_LOGIC_VECTOR(0 TO 1);
		GPIO0_CLKOUT : IN STD_LOGIC_VECTOR(0 TO 1);
		GPIO1_CLKIN : IN STD_LOGIC_VECTOR(0 TO 1);
		GPIO1_CLKOUT : IN STD_LOGIC_VECTOR(0 TO 1);
		GPIO1_D : IN STD_LOGIC_VECTOR(0 TO 31);
		-- LCD (not included on board)
		LCD_DATA : IN STD_LOGIC_VECTOR(0 TO 7);
		-- VGA port
		VGA_G : IN STD_LOGIC_VECTOR(0 TO 3);
		VGA_R : IN STD_LOGIC_VECTOR(0 TO 3);
		VGA_B : IN STD_LOGIC_VECTOR(0 TO 3);
		-- DRAM signals
		DRAM_DQ : IN STD_LOGIC_VECTOR(0 TO 15);
		DRAM_ADDR : IN STD_LOGIC_VECTOR(0 TO 12)
	);
END DE0;

ARCHITECTURE structure OF DE0 IS
	-- ***************************** MAIN ARCHITECTURE COMPONENT DECLARATIONS *******************************
	-- component that reads the program instructions
	COMPONENT INSTRUCTION_READER
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
	END COMPONENT;
	-- component that displays bytes on the 7-segment displays
	COMPONENT SEG_DISPLAY
		PORT 
		(	-- seg_display inputs
			NIB0		:	IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- lower nibble of data to be displayed
			NIB1		:	IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- upper nibble of data to be displayed		
			BYTE_SELECT	:	IN STD_LOGIC; -- selects the first two or last two 7-seg displays to display the byte
			EN			:	IN STD_LOGIC; -- enables the display component
			PWR			:	IN STD_LOGIC; -- set the power on ('1') or off ('0') of the display
		
			-- port mapping to 7-segment displays
			HEX0_D 		: 	OUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display (far right)
			HEX1_D 		: 	OUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display (middle right)
			HEX2_D 		: 	OUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display (middle left)
			HEX3_D 		: 	OUT STD_LOGIC_VECTOR(0 TO 6);  -- the LEDs of the 7-segment display (far left)
			
			RESET_N		:	IN STD_LOGIC; -- reset
			CLK_IN		:	IN STD_LOGIC -- clock input, use cpu clock as source
		);
	END COMPONENT;
	-- component that implements the register bank
	COMPONENT REGISTER_BANK
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
	END COMPONENT;
	-- component that implements the finite state machine that controls the processor
	COMPONENT CONTROLLER_FSM
		PORT
		(
			JUMP_COND			:	IN STD_LOGIC; -- attached to LSB of D_BUS and used as condition for coniditional jump
			COMP_EN				:	OUT STD_LOGIC; -- enable/disable component
			COMP_OE				:	OUT STD_LOGIC; -- enable/disable outputs on the shared data bus
			COMP_SEL			:	OUT STD_LOGIC; -- select which byte will be loaded
			SPEC_REG_WR_N		:	OUT STD_LOGIC; -- special register not write enable
			SPEC_REG_RE_N		:	OUT STD_LOGIC; -- special register not read enable
			ARITH_EN			:	OUT STD_LOGIC; -- enable/disable component
			ARITH_OE			:	OUT STD_LOGIC; -- enable/disable outputs on the shared data bus
			ARITH_SEL			:	OUT STD_LOGIC; -- select which byte will be loaded
			RESET_N				:	IN STD_LOGIC; -- reset input (connected to button(0))
			RESET_INSTR_NUMBER	:	OUT STD_LOGIC; -- reset instruction number to "00000000"
			SET_INSTR_NUMBER	:	OUT STD_LOGIC; -- set instruction number to whatever is on the data bus
			INSTR				:	IN 	STD_LOGIC_VECTOR(3 DOWNTO 0); -- the current instruction
			INSTR_EN			:	OUT STD_LOGIC; -- enable/disable the instruction reader component
			INSTR_OE			:	OUT STD_LOGIC; -- enable/disable the outputs (instruction byte 2) on the shared data bus
			SEL_ADDR			:	OUT STD_LOGIC; -- select the address source for WR_ADDR of the register bank
			REG_CPY_N			:	OUT STD_LOGIC; -- select copy/output mode of the register
			REG_WR_N			:	OUT	STD_LOGIC; -- enable/disable writing
			REG_RE_N			:	OUT	STD_LOGIC; -- enable/disable reading
			REG_PR_N			:	OUT	STD_LOGIC; -- preset all bits to '1'
			REG_CL_N			:	OUT STD_LOGIC; -- clear all bits to '0'
			DISP_EN				:	OUT STD_LOGIC; -- enable/disable the 7-segment display unit
			DISP_BYTE_SELECT	:	OUT	STD_LOGIC; -- select which 7-segment pair to display on
			DISP_PWR			:	OUT	STD_LOGIC; -- power the display unit on/off			
			INCR_INSTR_NUMBER_NE:	OUT	STD_LOGIC; -- increment the current instruction number (active on negative edge)			
			CLK_IN				:	IN STD_LOGIC -- clock input (use cpu clock)
		);
	END COMPONENT;
	-- component that generates the clock for the processor
	COMPONENT CLK_SOURCE
		PORT
		(
			CLOCK_50	:	IN STD_LOGIC; -- the 50 MHz clock source on the DE0 board
			CPU_CLK		:	OUT STD_LOGIC -- the cpu clock source
		);
	END COMPONENT;
	-- component that performs arithmetic (addition/subtraction)
	COMPONENT ADDER
		PORT
		(
			SEL			:	IN  STD_LOGIC; -- select which byte will be loaded
			EN			:	IN 	STD_LOGIC; -- enable/disable the adder
			CLK_N		:	IN  STD_LOGIC; -- clock input
			OE			:	IN	STD_LOGIC; -- enable/disable outputs on the shared data bus
			DATA		:	INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);	-- the data inputs/outputs
			D_BUS_LIVE	:	IN STD_LOGIC -- detect whetheror not the shared data bus is being used
		);
	END COMPONENT;
	-- component that implements a 1-byte register
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
	-- component that performs a is equal comparison
	COMPONENT COMPARATOR IS
		PORT
		(
			SEL			:	IN  STD_LOGIC; -- select which byte will be loaded
			EN			:	IN 	STD_LOGIC; -- enable/disable the comparator
			CLK_N		:	IN  STD_LOGIC; -- clock input
			OE			:	IN	STD_LOGIC; -- enable/disable outputs on the shared data bus
			DATA		:	INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);	-- the data inputs/outputs
			D_BUS_LIVE	:	IN STD_LOGIC -- detect whetheror not the shared data bus is being used
		);
	END COMPONENT;
	-- ******************************** MAIN ARCHITECTURE SIGNALS *********************************************
	-- signal to detect if D_BUS is live (driven by other component)
	SIGNAL D_BUS_LIVE				:	STD_LOGIC; -- = '1' means a component has its outputs enabled on the shared data bus

	-- clock signals
	SIGNAL CPU_CLK					:	STD_LOGIC; -- cpu clock signal
	
	-- busses (8 bits)
	SIGNAL INSTR_BYTE1				: 	STD_LOGIC_VECTOR(7 DOWNTO 0); -- first byte of 16-bit instruction
	SIGNAL INSTR_NUMBER				:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- current instruction number (program counter)	
	SIGNAL D_BUS					:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- shared data bus (8 bits)
	SIGNAL SPEC_REG_Q				:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	-- busses (4 bits)
	SIGNAL REG_RE_ADDR				:	STD_LOGIC_VECTOR(3 DOWNTO 0); -- register bank read address bus
	SIGNAL REG_WR_ADDR				:	STD_LOGIC_VECTOR(3 DOWNTO 0); -- register bank write address bus
	
	-- control signals for instruction reader	
	SIGNAL SET_INSTR_NUMBER			:	STD_LOGIC; -- jump to instruction
	SIGNAL RESET_INSTR_NUMBER		:	STD_LOGIC; -- jump to beginning of program	
	SIGNAL RESET_N					:	STD_LOGIC; -- reset
	SIGNAL INSTR_EN					:	STD_LOGIC; -- enable instruction reader
	SIGNAL INSTR_OE					:	STD_LOGIC; -- enabel output of instruction reader (tri-state outputs)
	SIGNAL INCR_INSTR_NUMBER_NE		:	STD_LOGIC; -- increment instruction number on negative edge
	
	-- control signals for register bank
	SIGNAL SEL_ADDR					:	STD_LOGIC; -- select register bank address source
	SIGNAL REG_CPY_N				:	STD_LOGIC; -- register bank mode: NOT copy 
	SIGNAL REG_WR_N					:	STD_LOGIC; -- register bank mode: NOT write
	SIGNAL REG_RE_N					:	STD_LOGIC; -- register bank mode: NOT read
	SIGNAL REG_PR_N					:	STD_LOGIC; -- register bank mode: NOT preset
	SIGNAL REG_CL_N					:	STD_LOGIC; -- register bank mode: NOT clear
	
	-- control signals for 7-segment display
	SIGNAL DISP_EN					:	STD_LOGIC; -- enable 7-segment display
	SIGNAL DISP_BYTE_SEL			: 	STD_LOGIC; -- select 7-segment display pair (MSB or LSB on board)
	SIGNAL DISP_PWR					:	STD_LOGIC; -- set power on or off for 7-segment display
	
	-- control signals for adder
	SIGNAL ARITH_EN					:	STD_LOGIC; -- enable/disable component
	SIGNAL ARITH_OE					:	STD_LOGIC; -- enable/disable outputs on the shared data bus
	SIGNAL ARITH_SEL				:	STD_LOGIC; -- select which byte will be loaded
	
	-- control signals for special register
	SIGNAL SPEC_REG_WR_N			:	STD_LOGIC; -- NOT write to special register
	SIGNAL SPEC_REG_RE_N			:	STD_LOGIC; -- NOT read from special register
	
	-- control signals for comparator
	SIGNAL COMP_EN					:	STD_LOGIC; -- enable/disable component
	SIGNAL COMP_OE					:	STD_LOGIC; -- enable/disable outputs on the shared data bus
	SIGNAL COMP_SEL					:	STD_LOGIC; -- select which byte will be loaded
BEGIN

	-- ******************************* MAIN ARCHITECTURE COMPONENT INSTANTIATION *****************************
	-- instantiate an instrunction_reader component
	instr0:	INSTRUCTION_READER PORT MAP (INSTR_NUMBER => INSTR_NUMBER, INCR_INSTR_NUMBER_NE => INCR_INSTR_NUMBER_NE, SET_INSTR_NUMBER => SET_INSTR_NUMBER,
		CLK_IN => CPU_CLK, RESET_N => RESET_N, INSTR_BYTE1 => INSTR_BYTE1, INSTR_BYTE2 => D_BUS, CLOCK_50 => CLOCK_50, RESET_INSTR_NUMBER => RESET_INSTR_NUMBER,
		FL_BYTE_N => FL_BYTE_N, FL_CE_N => FL_CE_N, FL_OE_N => FL_OE_N, EN => INSTR_EN, 
		FL_RST_N => FL_RST_N, FL_RY => FL_RY, FL_WE_N => FL_WE_N, FL_WP_N => FL_WP_N, 
		FL_DQ15_AM1 => FL_DQ15_AM1, FL_ADDR => FL_ADDR, FL_DQ => FL_DQ, OE => INSTR_OE, D_BUS_LIVE => (COMP_OE OR ARITH_OE OR (NOT REG_RE_N AND REG_CPY_N)));
	
	-- instantiate a register_bank component
	bank0: REGISTER_BANK PORT MAP (D => D_BUS, CPY_N => REG_CPY_N, RE_ADDR => REG_RE_ADDR, WR_ADDR => REG_WR_ADDR, 
		WR_N => REG_WR_N, RE_N => REG_RE_N, CLK_N => CPU_CLK, PR_N => REG_PR_N, CL_N => REG_CL_N, Q => D_BUS, D_BUS_LIVE => (COMP_OE OR ARITH_OE OR INSTR_OE));
		
	-- instantiate a 2-byte 7-segment display
	disp0: SEG_DISPLAY PORT MAP (NIB0 => D_BUS(3 DOWNTO 0), NIB1 => D_BUS(7 DOWNTO 4), 
		BYTE_SELECT => DISP_BYTE_SEL, EN => DISP_EN, PWR => DISP_PWR, HEX0_D => HEX0_D,
		HEX1_D => HEX1_D, HEX2_D => HEX2_D, HEX3_D => HEX3_D, CLK_IN => CPU_CLK, RESET_N => RESET_N);
	
	-- instantiate a controller finite state machine
	contr0: CONTROLLER_FSM PORT MAP (JUMP_COND => D_BUS(0), RESET_N => RESET_N, INSTR => INSTR_BYTE1(7 DOWNTO 4), SET_INSTR_NUMBER => SET_INSTR_NUMBER, 
		INSTR_EN => INSTR_EN, INSTR_OE => INSTR_OE,	SEL_ADDR => SEL_ADDR, REG_CPY_N	=> REG_CPY_N, REG_WR_N => REG_WR_N, 
		REG_RE_N => REG_RE_N, REG_PR_N => REG_PR_N,	REG_CL_N => REG_CL_N, DISP_EN => DISP_EN, DISP_BYTE_SELECT => DISP_BYTE_SEL, 
		DISP_PWR => DISP_PWR, INCR_INSTR_NUMBER_NE => INCR_INSTR_NUMBER_NE, CLK_IN => CPU_CLK, RESET_INSTR_NUMBER => RESET_INSTR_NUMBER,
		ARITH_EN => ARITH_EN, ARITH_OE => ARITH_OE, ARITH_SEL => ARITH_SEL, SPEC_REG_WR_N => SPEC_REG_WR_N, SPEC_REG_RE_N => SPEC_REG_RE_N,
		COMP_EN => COMP_EN, COMP_OE => COMP_OE, COMP_SEL => COMP_SEL);
		
	-- instantiate a register for the special register
	specreg0: BYTE_REGISTER PORT MAP (D => D_BUS, EN => NOT SPEC_REG_WR_N, OE => NOT SPEC_REG_RE_N, CLK_N => CPU_CLK, 
		CL_N => RESET_N, PR_N => '1', Q => SPEC_REG_Q);
	
	-- instantiate arithmetic component
	arith0: ADDER PORT MAP (SEL => ARITH_SEL, EN => ARITH_EN, CLK_N => CPU_CLK, OE => ARITH_OE,
		DATA => D_BUS, D_BUS_LIVE => (COMP_OE OR INSTR_OE OR (NOT REG_RE_N AND REG_CPY_N)));
		
	-- instantiate comparator component
	comp0: COMPARATOR PORT MAP (SEL => COMP_SEL, EN => COMP_EN, CLK_N => CPU_CLK, OE => COMP_OE, 
		DATA => D_BUS, D_BUS_LIVE => (INSTR_OE OR ARITH_OE OR (NOT REG_RE_N AND REG_CPY_N)));
	
	-- instantiate a CPU clock source
	clk0: CLK_SOURCE PORT MAP (CLOCK_50 => CLOCK_50, CPU_CLK => CPU_CLK);	
	
	-- ****************************** OTHER SIGNAL/PORT ASSIGNMENTS ******************************************
    LEDG(9) <= CPU_CLK; -- show the clock level on LED 9
    LEDG(8) <= INCR_INSTR_NUMBER_NE; -- show when the instruction counter is incremented on LED 8
	LEDG(7 DOWNTO 0) <= INSTR_NUMBER; -- show the current instruction number in unsigned binary on LEDs 7 through 0
	RESET_N <= BUTTON(0); -- reset button (press to activate)
		
	REG_RE_ADDR <= INSTR_BYTE1(3 DOWNTO 0) WHEN SEL_ADDR = '0' ELSE SPEC_REG_Q(3 DOWNTO 0); -- select between the 
		-- lower nibble of the first instruction byte and the lower nibble of the special register for register bank read address
	REG_WR_ADDR <= INSTR_BYTE1(3 DOWNTO 0) WHEN SEL_ADDR = '1' ELSE D_BUS(3 DOWNTO 0); -- select between the 
		-- lower nibble of the first instruction byte and the shared data bus for register bank write address

END structure;

