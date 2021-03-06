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
	
	--OP CODE DEFINITIONS
	constant wr : std_logic_vector (3 downto 0) := "0000";
	constant cp : std_logic_vector (3 downto 0) := "0001";
	constant d0 : std_logic_vector (3 downto 0) := "0010";
	constant d1 : std_logic_vector (3 downto 0) := "0011";
	constant ad : std_logic_vector (3 downto 0) := "0100";
	constant eq : std_logic_vector (3 downto 0) := "0101";
	constant ju : std_logic_vector (3 downto 0) := "0110";
	constant cj : std_logic_vector (3 downto 0) := "0111";
	constant no : std_logic_vector (3 downto 0) := "1111";
	
	--STATE VARIABLES
	--THE DIFFERENT STATES THAT IT COULD BE IN
	type states is(rst, rs, wr1, cp1, d01, d11, ad1, ad2, ad3, ad4, eq1, eq2, eq3, eq4, ju1, cj1, cj2, no1);
	--THE CURRENT STATE OF THE STATE MACHINE
	signal cs : states := rs;

BEGIN
	process(clk_in, reset_n)
	begin
		if reset_n = '1' then
			if clk_in'event and clk_in = '1' then
			
			--ASSIGN DO THOTHING VALUES BEFORE NEXT STATE IS CHOSEN
					comp_sel <= '0';
					reset_instr_number <= '0';
					reg_re_n <= '1';
					comp_en <= '0';
					set_instr_number <= '0';
					reg_pr_n <= '1';
					comp_oe <= '0';
					incr_instr_number_ne <= '0';
					reg_cl_n <= '1';
					spec_reg_wr_n <= '1';
					instr_en <= '0';
					disp_en <= '0';
					spec_reg_re_n <= '1';
					instr_oe <= '0';
					disp_byte_select <= '0';
					arith_sel <= '0';
					sel_addr <= '1';
					disp_pwr <= '0';
					arith_en <= '0';
					reg_cpy_n <= '1';
					arith_oe <= '0';
					reg_wr_n <= '1';
			
			--OVERLYING CASE CHECKING NEXT CASE LOGIC
				case cs is
					when rs => --WHEN IN THE READ STATE CHECK THE INSTRUCTION ON WHAT TO DO NEXT
							case instr is
								when wr =>	-- IF THE WRITE INSTRUCTION IS GIVEN
													cs <= wr1; 	 
																instr_oe <= '1'; 
																reg_wr_n <= '0'; 
																incr_instr_number_ne <= '1'; 
								
								
								when cp =>			--WHEN THE COPY INSTRUCTION IS GIVEN 
													cs <= cp1; 	 
																instr_oe <= '1'; 
																reg_wr_n <= '0'; 
																reg_re_n <= '0'; 
																reg_cpy_n <= '0'; 
																sel_addr <= '0'; 
																incr_instr_number_ne <= '1'; 
								
								
								when d0 => 			--WHEN THE DISPLAY 0 
													cs <= d01; 	 
																reg_re_n <= '0';
																sel_addr <= '0';
																disp_en <= '1';
																disp_pwr <= '1';
																disp_byte_select <= '0';
																incr_instr_number_ne <= '1'; 
								
								
								when d1 =>			--WHEN DISPLAY 1 
													cs <= d11; 	 
																incr_instr_number_ne <= '1'; 
																reg_re_n <= '0';
																sel_addr <= '0';
																disp_en <= '1';
																disp_pwr <= '1';
																disp_byte_select <= '1';
								
								
								when ad =>			--WHEN ADD INSTRUCTION IS GIVEN 
													cs <= ad1; 
																sel_addr <= '0';
																reg_re_n <= '0';
																arith_en <= '1';
																arith_sel <= '0';
								
								
								when eq =>			 --WHEN EQUATE
													cs <= eq1; 
																sel_addr <= '0';
																reg_re_n <= '0';
																comp_en <= '1';
																comp_sel <= '0'; 
																
								
								when ju =>			--WHEN JUMP  
													cs <= ju1;  
																instr_oe <= '1';
																set_instr_number <= '1';
																
							
								when cj =>			--WHEN CONDITIONAL JUMP -------------------------- DOES NOT WORK PROPERLY
													cs <= cj1;
																if jump_cond = '1' then
																	sel_addr <= '0';
																	reg_re_n <= '0';
																	
																else
																	cs <= no1;
																end if;
																
																
								when no => 			cs <= no1;	--WHEN THE NO INSTRUCTION IS GIVEN
																incr_instr_number_ne <= '1';
																
																
								when others =>		cs <= rs; 	-- WHEN ANY OTHER INSTRUCTION IS GIVEN 
																instr_en <= '1';
																incr_instr_number_ne <= '1';
																
								end case;
								
								
								--WHEN IN THE ADD STATE GO TO ADD2 STATE
					when ad1 => 	cs <= ad2; 		instr_oe <= '1';
													spec_reg_wr_n <= '0';
											
											
								--WHEN IN THE ADD2 STATE GO TO THE ADD3 STATE			
					when ad2 => 	cs <= ad3;		spec_reg_re_n <= '0';
													reg_re_n <= '0';
													arith_en <= '1';
													arith_sel <= '1';
											
											
								--WHEN IN THE ADD3 STATE GO TO THE ADD4 STATE			
					when ad3 => 	cs <= ad4;		arith_oe <= '1';
													reg_wr_n <= '0';
													incr_instr_number_ne <= '1';
					
					
								--WHEN IN THE EQUATE STATE GO TO THE EQUATE2 STATE
					when eq1 => 	cs <= eq2; 		instr_oe <= '1';
													spec_reg_wr_n <= '0';
											
								
								--WHEN IN THE EQUATE2 STATE GO TO THE EQUATE 3 STATE			
					when eq2 => 	cs <= eq3;		spec_reg_re_n <= '0';
													reg_re_n <= '0';
													comp_en <= '1';
													comp_sel <= '1';
											
								
								--WHEN IN THE EQUATE3 STATE GO TO THE EQUATE4 STATE			
					when eq3 => 	cs <= eq4;		comp_oe <= '1';
													reg_wr_n <= '0';
													incr_instr_number_ne <= '1';
											
								
								--WHEN IN THE CONDITIONAL JUMP STATE GO TO THE CONDITIONAL JUMP2 STATE -------------------- DOES NOT WROK
					when cj1 => 				
								if jump_cond = '1' then
									cs <= cj2; 		set_instr_number <= '1';
													sel_addr <= '0';
													instr_oe <= '1';
								else
									cs <= no1;		incr_instr_number_ne <= '1';
								end if;
											
								
								--WHEN IN ANY OTHER STATE GO TO THE READ STATE
					when others => 	cs <= rs; 		instr_en <= '1';
													spec_reg_wr_n <= '0';
												
					
				end case;
			end if;
		elsif reset_n = '0' then 
			cs <= rst; 			
						--ASSIGN THE RESET VALUES
								comp_sel <= '0';
								reset_instr_number <= '1'; -- THIS AND
								reg_re_n <= '1';
								comp_en <= '0';
								set_instr_number <= '0';
								reg_pr_n <= '1';
								comp_oe <= '0';
								incr_instr_number_ne <= '0';
								reg_cl_n <= '0';			-- THIS ARE DIFFERENT
								spec_reg_wr_n <= '1';
								instr_en <= '0';
								disp_en <= '0';
								spec_reg_re_n <= '1';
								instr_oe <= '0';
								disp_byte_select <= '0';
								arith_sel <= '0';
								sel_addr <= '1';
								disp_pwr <= '0';
								arith_en <= '0';
								reg_cpy_n <= '1';
								arith_oe <= '0';
								reg_wr_n <= '1';
								
		end if;
	end process;
END STRUCTURE;



--		comp_sel <= '0';
--		reset_instr_number <= '0';
--		reg_re_n <= '1';
--		comp_en <= '0';
--		set_instr_number <= '0';
--		reg_pr_n <= '1';
--		comp_oe <= '0';
--		incr_instr_number_ne <= '0';
--		reg_cl_n <= '1';
--		spec_reg_wr_n <= '1';
--		instr_en <= '0';
--		disp_en <= '0';
--		spec_reg_re_n <= '1';
--		instr_oe <= '0';
--		disp_byte_select <= '0';
--		arith_sel <= '0';
--		sel_addr <= '1';
--		disp_pwr <= '0';
--		arith_en <= '0';
--		reg_cpy_n <= '1';
--		arith_oe <= '0';
--		reg_wr_n <= '1';

