	LIBRARY ieee;     
	use IEEE.std_logic_1164.all;
	use IEEE.STD_LOGIC_UNSIGNED.all;

	ENTITY BoothMul_TB is
	END BoothMul_TB;
	ARCHITECTURE TB of BoothMul_TB is
		SIGNAL clk :  STD_LOGIC := '0';
		SIGNAL rst:  STD_LOGIC := '1';
		SIGNAL X :  STD_LOGIC_VECTOR (3 DOWNTO 0);
		SIGNAL Y :  STD_LOGIC_VECTOR (3 DOWNTO 0);
		SIGNAL startMUL :  STD_LOGIC :='0';
		SIGNAL OUTR4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
		SIGNAL completeR4 :  STD_LOGIC;
	BEGIN
			--Unit Under Test Instantiation:
		UUT : ENTITY work.booth_multiplier generic map(bits=>4) PORT MAP (clk => clk, rst => rst, in1 => X,
		in2 => Y , start=> startMUL,
		out1 => OUTR4,completeR4=>completeR4);
		-- clk generation:
		clk <=  not clk after 10 ns;
		tb1 : process
		begin
			rst <= '0' after 80 ns;
			wait for 200 ns;startMUL <= '1'; X <= x"7";Y <= x"7";
			wait for 20 ns;startMUL <= '0'; 
			wait for 90 ns;startMUL <= '1'; X <= x"f";Y <= x"f";
			wait for 20 ns;startMUL <= '0'; 
			wait for 90 ns;startMUL <= '1'; X <= x"f";Y <= x"7";
			wait for 20 ns;startMUL <= '0'; 
			-- wait for 20 ns;xInput <= x"0003";wait for 20 ns;xInput <= x"0004";
			-- --changing the degree value in the middle of inpt application
			-- --this MUST NOT affect the calculation process
			-- Degree <= "0011";
			-- wait for 20 ns;xInput <= x"0005";wait for 20 ns;xInput <= x"0006";			
			-- wait for 20 ns;xInput <= x"0007";
			-- -- applying new set of data with a different degree
			-- Degree <= "0100"; 
			-- wait for 90 ns;Start <= '1'; wait for 20 ns; Start <= '0';
			-- wait for 20 ns;xInput <= x"0004";wait for 20 ns;xInput <= x"0003";
			-- wait for 20 ns;xInput <= x"0002";wait for 20 ns;xInput <= x"0001";
			
		   wait;
		end process;
	END TB ;
	
	
	

