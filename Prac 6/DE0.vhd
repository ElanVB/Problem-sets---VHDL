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
		HEX2_DP : INOUT STD_LOGIC;
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
		SIGNAL CLK_s: std_logic;
		signal CLK_ms: std_logic;
		signal counter: integer range 0 to 9 := 0;
		signal counter_ms: integer range 0 to 9999 := 0;
		signal counter_ms2: integer range 0 to 9999 := 0;
		signal counter_p: integer range 0 to 9999 := 0;
		signal countNow: std_logic := '0';
		signal display: integer range 0 to 3 := 0;
BEGIN

--SECONDS CLOCK
PROCESS(CLOCK_50)
		VARIABLE count: integer := 0;
	BEGIN
		if CLOCK_50'event AND CLOCK_50 = '1' then
			if count = 25000000 then
				CLK_s <= NOT CLK_s;
				count := 0;
			end if;
			
			count := count + 1;
		end if;
	END PROCESS;
	--SECONDS CLOCK END
	
	--CENTI-SECONDS CLOCK
	PROCESS(CLOCK_50)
		VARIABLE count: integer := 0;
	BEGIN
		if CLOCK_50'event AND CLOCK_50 = '1' then
			if count = 250000 then
				CLK_ms <= NOT CLK_ms;
				count := 0;
			end if;
			
			count := count + 1;
		end if;
	END PROCESS;
	--CENTI-SECONDS CLOCK END
	
	
	
	process(clk_ms)
BEGIN
	--NUMBER 1
	if(SW(0) = '0' and SW(1) = '0') then 
			display <= 0;
		if(CLK_s'event and CLK_s = '1')then
			
			
			counter <= counter + 1;
			
			if(counter = 9) then
				counter <= 0;
			end if;
			end if;
			end if;
	--NUMBER 1 END
			
	--NUMBER 2
	if(SW(0) = '1' and SW(1) = '0') then
		display <= 1;
		if(button(2) = '0') then
			if(clk_ms'event and clk_ms = '1') then
				
				counter_ms <= counter_ms + 1;
				
				if(counter_ms = 9999) then
					counter_ms <= 0;
				end if;
			end if;
		end if;
		
		if(button(1) = '0') then
			counter_ms <= 0;
		end if;
	end if;
	--NUMBER 2 END
	
	--NUMBER 3
	if(sw(1) = '1' and sw(0) = '0') then
		display <= 2;
		if(button(2)'event and button(2) = '0') then
			counter_p <= counter_p + 1;
		end if; 

		if(button(1) = '0') then
			counter_p <= 0;
		end if;
	end if;
	--NUMBER 3 END
	
	--NUMBER 4
	if(SW(0) = '1' and SW(1) = '1') then
		display <= 3;
		
		if(button(2)'event and button(2) = '0') then
			countNow <= not countNow;
		end if;
		
		if(countNow = '1') then
			if(clk_ms'event and clk_ms = '1') then
				
				counter_ms2 <= counter_ms2 + 1;
				
				if(counter_ms2 = 9999) then
					counter_ms2 <= 0;
				end if;
			end if;
		end if;
		
		if(button(1) = '0') then
			counter_ms2 <= 0;
		end if;
	end if;
	--NUMBER 4 END
	end process;

--SET HEX DISPLAY
process(display)
begin

	if(display = 0) then --SET DISPLAY FOR NUMBER 1
		
		HEX2_DP <= '1';
		
		if(counter = 0) then
			HEX3_D <= "0000001";
			HEX2_D <= "0000001";
			HEX1_D <= "0000001";
			HEX0_D <= "0000001";
		elsif(counter = 1) then
			HEX3_D <= "1001111";
			HEX2_D <= "1001111";
			HEX1_D <= "1001111";
			HEX0_D <= "1001111";
		elsif(counter = 2) then
			HEX3_D <= "0010010";
			HEX2_D <= "0010010";
			HEX1_D <= "0010010";
			HEX0_D <= "0010010";
		elsif(counter = 3) then
			HEX3_D <= "0000110";
			HEX2_D <= "0000110";
			HEX1_D <= "0000110";
			HEX0_D <= "0000110";
		elsif(counter = 4) then
			HEX3_D <= "1001100";
			HEX2_D <= "1001100";
			HEX1_D <= "1001100";
			HEX0_D <= "1001100";
		elsif(counter = 5) then
			HEX3_D <= "0100100";
			HEX2_D <= "0100100";
			HEX1_D <= "0100100";
			HEX0_D <= "0100100";
		elsif(counter = 6) then
			HEX3_D <= "0100000";
			HEX2_D <= "0100000";
			HEX1_D <= "0100000";
			HEX0_D <= "0100000";
		elsif(counter = 7) then
			HEX3_D <= "0001111";
			HEX2_D <= "0001111";
			HEX1_D <= "0001111";
			HEX0_D <= "0001111";
		elsif(counter = 8) then
			HEX3_D <= "0000000";
			HEX2_D <= "0000000";
			HEX1_D <= "0000000";
			HEX0_D <= "0000000";
		else
			HEX3_D <= "0001100";
			HEX2_D <= "0001100";
			HEX1_D <= "0001100";
			HEX0_D <= "0001100";
		end if;
	elsif(display = 1) then --SET DISPLAY FOR NUMBER 2
		
		HEX2_DP <= '0';
		
		case (counter_ms/1000) is
					  WHEN 1 => HEX3_D <= "1001111"; 
					  WHEN 2 => HEX3_D <= "0010010";
					  WHEN 3 => HEX3_D <= "0000110";
					  WHEN 4 => HEX3_D <= "1001100";
					  WHEN 5 => HEX3_D <= "0100100";
					  WHEN 6 => HEX3_D <= "1100000";
					  WHEN 7 => HEX3_D <= "0001111";
					  WHEN 8 => HEX3_D <= "0000000";
					  WHEN 9 => HEX3_D <= "0001100";
					  when others => HEX3_D <= "0000001";
					 end case;
				  
		case (counter_ms/100 rem 10) is 
					  WHEN 1 => HEX2_D <= "1001111"; 
					  WHEN 2 => HEX2_D <= "0010010";
					  WHEN 3 => HEX2_D <= "0000110";
					  WHEN 4 => HEX2_D <= "1001100";
					  WHEN 5 => HEX2_D <= "0100100";
					  WHEN 6 => HEX2_D <= "1100000";
					  WHEN 7 => HEX2_D <= "0001111";
					  WHEN 8 => HEX2_D <= "0000000";
					  WHEN 9 => HEX2_D <= "0001100";
					  when others => HEX2_D <= "0000001";
					 end case;
					 
		case (counter_ms/10 rem 10) is 
					  WHEN 1 => HEX1_D <= "1001111"; 
					  WHEN 2 => HEX1_D <= "0010010";
					  WHEN 3 => HEX1_D <= "0000110";
					  WHEN 4 => HEX1_D <= "1001100";
					  WHEN 5 => HEX1_D <= "0100100";
					  WHEN 6 => HEX1_D <= "1100000";
					  WHEN 7 => HEX1_D <= "0001111";
					  WHEN 8 => HEX1_D <= "0000000";
					  WHEN 9 => HEX1_D <= "0001100";
					  when others => HEX1_D <= "0000001";
					 end case;
					 
		case (counter_ms rem 10) is
					  WHEN 1 => HEX0_D <= "1001111"; 
					  WHEN 2 => HEX0_D <= "0010010";
					  WHEN 3 => HEX0_D <= "0000110";
					  WHEN 4 => HEX0_D <= "1001100";
					  WHEN 5 => HEX0_D <= "0100100";
					  WHEN 6 => HEX0_D <= "1100000";
					  WHEN 7 => HEX0_D <= "0001111";
					  WHEN 8 => HEX0_D <= "0000000";
					  WHEN 9 => HEX0_D <= "0001100";
					  when others => HEX0_D <= "0000001";
					 end case;
	elsif(display = 2) then --SET DISPLAY FOR NUMBER 3

		HEX2_DP <= '1';
		
		case (counter_p/1000) is
					  WHEN 1 => HEX3_D <= "1001111"; 
					  WHEN 2 => HEX3_D <= "0010010";
					  WHEN 3 => HEX3_D <= "0000110";
					  WHEN 4 => HEX3_D <= "1001100";
					  WHEN 5 => HEX3_D <= "0100100";
					  WHEN 6 => HEX3_D <= "1100000";
					  WHEN 7 => HEX3_D <= "0001111";
					  WHEN 8 => HEX3_D <= "0000000";
					  WHEN 9 => HEX3_D <= "0001100";
					  when others => HEX3_D <= "0000001";
					 end case;
				  
		case (counter_p/100 rem 10) is 
					  WHEN 1 => HEX2_D <= "1001111"; 
					  WHEN 2 => HEX2_D <= "0010010";
					  WHEN 3 => HEX2_D <= "0000110";
					  WHEN 4 => HEX2_D <= "1001100";
					  WHEN 5 => HEX2_D <= "0100100";
					  WHEN 6 => HEX2_D <= "1100000";
					  WHEN 7 => HEX2_D <= "0001111";
					  WHEN 8 => HEX2_D <= "0000000";
					  WHEN 9 => HEX2_D <= "0001100";
					  when others => HEX2_D <= "0000001";
					 end case;
					 
		case (counter_p/10 rem 10) is 
					  WHEN 1 => HEX1_D <= "1001111"; 
					  WHEN 2 => HEX1_D <= "0010010";
					  WHEN 3 => HEX1_D <= "0000110";
					  WHEN 4 => HEX1_D <= "1001100";
					  WHEN 5 => HEX1_D <= "0100100";
					  WHEN 6 => HEX1_D <= "1100000";
					  WHEN 7 => HEX1_D <= "0001111";
					  WHEN 8 => HEX1_D <= "0000000";
					  WHEN 9 => HEX1_D <= "0001100";
					  when others => HEX1_D <= "0000001";
					 end case;
					 
		case (counter_p rem 10) is
					  WHEN 1 => HEX0_D <= "1001111"; 
					  WHEN 2 => HEX0_D <= "0010010";
					  WHEN 3 => HEX0_D <= "0000110";
					  WHEN 4 => HEX0_D <= "1001100";
					  WHEN 5 => HEX0_D <= "0100100";
					  WHEN 6 => HEX0_D <= "1100000";
					  WHEN 7 => HEX0_D <= "0001111";
					  WHEN 8 => HEX0_D <= "0000000";
					  WHEN 9 => HEX0_D <= "0001100";
					  when others => HEX0_D <= "0000001";
					 end case;

	elsif(display = 3) then --SET DISPLAY FOR NUMBER 4
	
	HEX2_DP <= '0';
	
	case (counter_ms2/1000) is
				  WHEN 1 => HEX3_D <= "1001111"; 
				  WHEN 2 => HEX3_D <= "0010010";
				  WHEN 3 => HEX3_D <= "0000110";
				  WHEN 4 => HEX3_D <= "1001100";
				  WHEN 5 => HEX3_D <= "0100100";
				  WHEN 6 => HEX3_D <= "1100000";
				  WHEN 7 => HEX3_D <= "0001111";
				  WHEN 8 => HEX3_D <= "0000000";
				  WHEN 9 => HEX3_D <= "0001100";
				  when others => HEX3_D <= "0000001";
				 end case;
			  
	case (counter_ms2/100 rem 10) is 
				  WHEN 1 => HEX2_D <= "1001111"; 
				  WHEN 2 => HEX2_D <= "0010010";
				  WHEN 3 => HEX2_D <= "0000110";
				  WHEN 4 => HEX2_D <= "1001100";
				  WHEN 5 => HEX2_D <= "0100100";
				  WHEN 6 => HEX2_D <= "1100000";
				  WHEN 7 => HEX2_D <= "0001111";
				  WHEN 8 => HEX2_D <= "0000000";
				  WHEN 9 => HEX2_D <= "0001100";
				  when others => HEX2_D <= "0000001";
				 end case;
				 
	case (counter_ms2/10 rem 10) is 
				  WHEN 1 => HEX1_D <= "1001111"; 
				  WHEN 2 => HEX1_D <= "0010010";
				  WHEN 3 => HEX1_D <= "0000110";
				  WHEN 4 => HEX1_D <= "1001100";
				  WHEN 5 => HEX1_D <= "0100100";
				  WHEN 6 => HEX1_D <= "1100000";
				  WHEN 7 => HEX1_D <= "0001111";
				  WHEN 8 => HEX1_D <= "0000000";
				  WHEN 9 => HEX1_D <= "0001100";
				  when others => HEX1_D <= "0000001";
				 end case;
				 
	case (counter_ms2 rem 10) is
				  WHEN 1 => HEX0_D <= "1001111"; 
				  WHEN 2 => HEX0_D <= "0010010";
				  WHEN 3 => HEX0_D <= "0000110";
				  WHEN 4 => HEX0_D <= "1001100";
				  WHEN 5 => HEX0_D <= "0100100";
				  WHEN 6 => HEX0_D <= "1100000";
				  WHEN 7 => HEX0_D <= "0001111";
				  WHEN 8 => HEX0_D <= "0000000";
				  WHEN 9 => HEX0_D <= "0001100";
				  when others => HEX0_D <= "0000001";
				 end case;
	
	end if;
	
end process;			  	  
END structure;


