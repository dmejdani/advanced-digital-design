library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is 								-- entitiy definition
	port(
		clk, reset 	: in std_logic;				-- input signal
		q			: out std_logic_vector (2 downto 0) -- output
	);
end counter;

architecture arch of counter is 				-- architecture definition
	signal r_reg : std_logic_vector(2 downto 0) ; 		-- internal signal
	signal r_next : std_logic_vector(2 downto 0) ;		-- internal signal
begin
	-- register
	process (clk, reset) 						-- implementing the register
	begin
		if (reset='1') then
			r_reg <= (others=>'0');				-- reseting to 000
		elsif (clk'event and clk='1') then
			r_reg <= r_next;
		end if ;
	end process;
	--next state logic (incrementer)												
	r_next <=									-- implementing the counter
		"000" when r_reg="100" else
		"001" when r_reg="000" else
		"010" when r_reg="001" else
		"011" when r_reg="010" else
		"100";
	-- output logic
	q <= r_reg;				-- output counter
end arch ;