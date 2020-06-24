library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity left_shift is 							-- entity definition
	port(
		a 	: in std_logic_vector(7 downto 0); 	-- input signal
		ctrl: in std_logic_vector(2 downto 0); 	-- control signal
		y	: out std_logic_vector(7 downto 0) 	-- output signal
		);
end left_shift;

architecture ls_arch of left_shift is 			-- architecture definition
	begin
		with ctrl select 						-- select statement for left shifting
		y <= 
			a when "000",						-- all the possible cases of ctrl
			a(6 downto 0) & "0" when "001",
			a(5 downto 0) & "00" when "010",
			a(4 downto 0) & "000" when "011",
			a(3 downto 0) & "0000" when "100",
			a(2 downto 0) & "00000" when "101",
			a(1 downto 0) & "000000" when "110",
			a(0) & "0000000" when others;
end ls_arch;			