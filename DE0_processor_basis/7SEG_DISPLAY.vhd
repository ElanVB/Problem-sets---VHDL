-- author: R.D. Beyers
-- updated on 29/04/2015
-- STELLENBOSCH UNIVERSITY

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity that reads an instruction from flash memory
ENTITY SEG_DISPLAY IS
	PORT 
	(	-- seg_display inputs
		NIB0		:	IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- lower nibble of data to be displayed
		NIB1		:	IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- upper nibble of data to be displayed		
		BYTE_SELECT	:	IN STD_LOGIC; -- selects the first two or last two 7-seg displays to display the byte
		EN			:	IN STD_LOGIC; -- enables the display component
		PWR			:	IN STD_LOGIC; -- set the power on ('1') or off ('0') of the display
	
		-- port mapping to 7-segment displays
		HEX0_D 		: 	INOUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display (far right)
		HEX1_D 		: 	INOUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display (middle right)
		HEX2_D 		: 	INOUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display (middle left)
		HEX3_D 		: 	INOUT STD_LOGIC_VECTOR(0 TO 6);  -- the LEDs of the 7-segment display (far left)
		
		RESET_N		:	IN STD_LOGIC; -- reset
		CLK_IN		:	IN STD_LOGIC -- clock input, use cpu clock as source
	);
END SEG_DISPLAY;

ARCHITECTURE STRUCTURE OF SEG_DISPLAY IS
	COMPONENT	D_FLIPFLOP
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
	SIGNAL HEX0D	:	STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111";	
	SIGNAL HEX1D	:	STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111";
	SIGNAL HEX0Q	:	STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111";
	SIGNAL HEX1Q	:	STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111";
	SIGNAL HEX2Q	:	STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111";
	SIGNAL HEX3Q	:	STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111";
	SIGNAL PWR_ON	:	STD_LOGIC;	
BEGIN

	ff0: D_FLIPFLOP PORT MAP (D => PWR, EN => EN, OE => '1', CLK_N => CLK_IN, PR_N => '1', CL_N => RESET_N, Q => PWR_ON);
	
	PROCESS (CLK_IN,PWR_ON,RESET_N,HEX0Q,HEX1Q,HEX2Q,HEX3Q)
	BEGIN
		IF PWR_ON = '1' THEN
			HEX0_D <= HEX0Q;
			HEX1_D <= HEX1Q;
			HEX2_D <= HEX2Q;
			HEX3_D <= HEX3Q;
		ELSE
			HEX0_D <= "1111111";
			HEX1_D <= "1111111";
			HEX2_D <= "1111111";
			HEX3_D <= "1111111";		
		END IF;
		IF RESET_N = '0' THEN
			HEX0Q <= "1111111";
			HEX1Q <= "1111111";
			HEX2Q <= "1111111";
			HEX3Q <= "1111111";		
		ELSIF CLK_IN'EVENT AND CLK_IN = '0' THEN		
			IF EN = '1' THEN
				IF BYTE_SELECT = '0' THEN
					HEX0Q <= HEX0D;
					HEX1Q <= HEX1D;
				ELSIF BYTE_SELECT = '1' THEN
					HEX2Q <= HEX0D;
					HEX3Q <= HEX1D;
				END IF;
			END IF;
		END IF;
		
	END PROCESS;

	WITH NIB0(3 DOWNTO 0) SELECT 
		HEX0D <= NOT "1111110" WHEN "0000",
			   NOT "0110000" WHEN "0001",
		      "0010010" when "0010",
			  "0000110" when "0011",
			  "1001100" when "0100",
			  "0100100" when "0101",
			  "0100000" when "0110",
			  "0001111" when "0111",
			  "0000000" when "1000",
			  "0000100" when "1001",
			  "0001000" when "1010",
			  "1100000" when "1011",
			  "0110001" when "1100",
			  "1000010" when "1101",
			  "0110000" when "1110",
			  "0111000" when "1111";
			  
	WITH NIB1(3 DOWNTO 0) SELECT 
		HEX1D <= NOT "1111110" WHEN "0000",
			   NOT "0110000" WHEN "0001",
		      "0010010" when "0010",
			  "0000110" when "0011",
			  "1001100" when "0100",
			  "0100100" when "0101",
			  "0100000" when "0110",
			  "0001111" when "0111",
			  "0000000" when "1000",
			  "0000100" when "1001",
			  "0001000" when "1010",
			  "1100000" when "1011",
			  "0110001" when "1100",
			  "1000010" when "1101",
			  "0110000" when "1110",
			  "0111000" when "1111";
			  
END STRUCTURE;

