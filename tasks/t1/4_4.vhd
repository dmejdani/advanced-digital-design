library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is 							-- entity definition
	port(
		a 	: in std_logic_vector(7 downto 0);	-- input signal a
		b 	: in std_logic_vector(7 downto 0);  -- input signal b
		agtb: out std_logic 					-- output signal
		);
end comparator;

architecture cmp_arch of comparator is  		-- architecture of comparator
	begin
		agtb <=  								-- comparing only single bits
			'1' when a(7) > b(7) else 			-- taking into account if they 
			'0' when a(7) < b(7) else 			-- equal as well -> agtb = 0
			'1' when a(6) > b(6) else
			'0' when a(6) < b(6) else
			'1' when a(5) > b(5) else
			'0' when a(5) < b(5) else
			'1' when a(4) > b(4) else
			'0' when a(4) < b(4) else
			'1' when a(3) > b(3) else
			'0' when a(3) < b(3) else
			'1' when a(2) > b(2) else
			'0' when a(2) < b(2) else
			'1' when a(1) > b(1) else
			'0' when a(1) < b(1) else
			'1' when a(0) > b(0) else
			'0' when a(0) < b(0) else
			'0';
end cmp_arch;
