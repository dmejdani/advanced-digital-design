library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is 								-- entitiy definition
	port(
		clk, reset 	: in std_logic;				-- input signal
		q			: out std_logic_vector (3 downto 0) -- output
	);
end counter;

architecture arch of counter is 				-- architecture definition
	signal r_reg : unsigned (3 downto 0) ; 		-- internal signal
	signal r_next : unsigned (3 downto 0) ;		-- internal signal
begin
	-- register
	process (clk, reset) 						-- implementing the register
	begin
		if (reset='1') then
			r_reg <= "0011";					-- reseting to 0011
		elsif (clk'event and clk='1') then
			r_reg <= r_next;
		end if ;
	end process;
	--next state logic (incrementer)
												-- implementing the counter
												-- reseting when it reaches 12
												-- or when invalid
	r_next <=
		"0011" when r_reg="1100" or r_reg="1101" or 
					r_reg="1110" or r_reg="1111" or
					r_reg="0000" or r_reg="0001" or 
					r_reg="0010" else
		r_reg + 1;
	-- output logic
	q <= std_logic_vector(r_reg);				-- output counter
end arch ;