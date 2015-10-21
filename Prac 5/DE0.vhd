LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY altera;
use altera.altera_primitives_components.all;


ENTITY DE0 IS
	PORT
	(
		CLOCK_50 : IN STD_LOGIC; -- 50MHz in-circuit clock
		LEDG : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- the 10 green LEDs on the DE0 board
		SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- the 10 switches on the DE0 board
		BUTTON : IN STD_LOGIC_VECTOR(0 TO 2);  -- the 3 buttons on the DE0 board
		HEX0_D : INOUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display (right)
		HEX1_D : INOUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display
		HEX2_D : INOUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display
		HEX3_D : INOUT STD_LOGIC_VECTOR(0 TO 6); -- the LEDs of the 7-segment display (left)
		FL_BYTE_N : IN STD_LOGIC;
		FL_CE_N : IN STD_LOGIC;
		FL_OE_N : IN STD_LOGIC;
		FL_RST_N : IN STD_LOGIC;
		FL_RY : IN STD_LOGIC;
		FL_WE_N : IN STD_LOGIC;
		FL_WP_N : IN STD_LOGIC;
		FL_DQ15_AM1 : IN STD_LOGIC;
		PS2_KBCLK : IN STD_LOGIC;
		PS2_KBDAT : IN STD_LOGIC;
		PS2_MSCLK : IN STD_LOGIC;
		PS2_MSDAT : IN STD_LOGIC;
		UART_RXD : IN STD_LOGIC;
		UART_TXD : IN STD_LOGIC;
		UART_RTS : IN STD_LOGIC;
		UART_CTS : IN STD_LOGIC;
		SD_CLK : IN STD_LOGIC;
		SD_CMD : IN STD_LOGIC;
		SD_DAT0 : IN STD_LOGIC;
		SD_DAT3 : IN STD_LOGIC;
		SD_WP_N : IN STD_LOGIC;
		LCD_RW : IN STD_LOGIC;
		LCD_RS : IN STD_LOGIC;
		LCD_EN : IN STD_LOGIC;
		LCD_BLON : IN STD_LOGIC;
		VGA_HS : IN STD_LOGIC;
		VGA_VS : IN STD_LOGIC;
		HEX0_DP : IN STD_LOGIC;
		HEX1_DP : IN STD_LOGIC;
		HEX2_DP : IN STD_LOGIC;
		HEX3_DP : IN STD_LOGIC;
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
		CLOCK_50_2 : IN STD_LOGIC;
		FL_ADDR : IN STD_LOGIC_VECTOR(0 TO 21);
		FL_DQ : IN STD_LOGIC_VECTOR(0 TO 14);
		GPIO0_D : INOUT STD_LOGIC_VECTOR(0 TO 31);
		GPIO0_CLKIN : IN STD_LOGIC_VECTOR(0 TO 1);
		GPIO0_CLKOUT : IN STD_LOGIC_VECTOR(0 TO 1);
		GPIO1_CLKIN : IN STD_LOGIC_VECTOR(0 TO 1);
		GPIO1_CLKOUT : IN STD_LOGIC_VECTOR(0 TO 1);
		GPIO1_D : IN STD_LOGIC_VECTOR(0 TO 31);
		LCD_DATA : IN STD_LOGIC_VECTOR(0 TO 7);
		VGA_G : IN STD_LOGIC_VECTOR(0 TO 3);
		VGA_R : IN STD_LOGIC_VECTOR(0 TO 3);
		VGA_B : IN STD_LOGIC_VECTOR(0 TO 3);
		DRAM_DQ : IN STD_LOGIC_VECTOR(0 TO 15);
		DRAM_ADDR : IN STD_LOGIC_VECTOR(0 TO 12)
		);
END DE0;

ARCHITECTURE structure OF DE0 IS
		SIGNAL CLK: std_logic;
		signal counter: integer range 0 to 100 := 0;
BEGIN
	-- Number 1
	LEDG(0) <= NOT button(0);
	
	--Number 2
	LEDG(1) <= button(1) XOR button(0);
	
	--NUMBER 3
	flip1:dff PORT MAP(d => NOT button(0), clk => NOT button(1), clrn => button(2), prn => '1', q => LEDG(2));
	
	--NUMBER 4
	WITH SW(3 DOWNTO 0) SELECT
	HEX0_D <=	"0000001" WHEN "0000",
				"1001111" WHEN "0001",
				"0010010" WHEN "0010",
				"0000110" WHEN "0011",
				"1001100" WHEN "0100",
				"0100100" WHEN "0101",
				"0100000" WHEN "0110",
				"0001111" WHEN "0111",
				"0000000" WHEN "1000",
				"0001100" WHEN "1001",
				"0001000" WHEN "1010",
				"1100000" WHEN "1011",
				"0110001" WHEN "1100",
				"1000010" WHEN "1101",
				"0110000" WHEN "1110",
				"0111000" WHEN "1111";

	--NUMBER 5
	PROCESS(CLOCK_50)
		VARIABLE count: integer;
	BEGIN
		--count := 0;
		if CLOCK_50'event AND CLOCK_50 = '1' then
			if count = 25000000 then
				CLK <= NOT CLK;
				count := 0;
			end if;
			
			count := count + 1;
		end if;
	END PROCESS;
	LEDG(3) <= CLK;
	
	--NUMBER 6
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
		if SW(9) = '0'; then
			counter <= counter + 1;
		else
			counter <= counter - 1;
		end if;
			
			if counter = 100 then
				counter <= 0;
			end if;
		end if;

	end process;
	
	WITH (counter/10) SELECT
		HEX3_D <= "0000001" WHEN 0, 
				  "1001111" WHEN 1, 
				  "0010010" WHEN 2, 
			  	  "0000110" WHEN 3, 
			  	  "1001100" WHEN 4, 
			  	  "0100100" WHEN 5, 
			  	  "1100000" WHEN 6, 
			  	  "0001111" WHEN 7, 
			  	  "0000000" WHEN 8, 
			  	  "0001100" WHEN 9,
			  	  "1111111" when others;
			  
			  WITH (counter rem 10) SELECT
		HEX2_D <= "0000001" WHEN 0, 
				  "1001111" WHEN 1, 
				  "0010010" WHEN 2, 
			  	  "0000110" WHEN 3, 
			  	  "1001100" WHEN 4, 
			  	  "0100100" WHEN 5, 
			  	  "1100000" WHEN 6, 
			  	  "0001111" WHEN 7, 
			  	  "0000000" WHEN 8, 
			  	  "0001100" WHEN 9,
			  	  "1111111" when others;

			 
END structure;

--PROCESS(CLOCK_50)
--		VARIABLE count: integer;
--	BEGIN
--		count := 0;
--		if CLOCK_50'event then
--			if count = 50000000 then
--				CLK <= '0';
--				count := 0;
--			else
--				CLK <= '1';
--			end if;
--			
--			count := count + 1;
--		end if;
--		LEDG(1) <= CLK;
--	END PROCESS;
--END structure;


