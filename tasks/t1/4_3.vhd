library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity switch_ent is 							-- entity definition
	port(
		x	: in std_logic_vector(1 downto 0);  -- input signal
		ctrl: in std_logic_vector(1 downto 0);  -- control signal
		y 	: out std_logic_vector(1 downto 0)
		);
end switch_ent;


architecture sw_arch of switch_ent is 			-- architecture definition
	begin
		with ctrl select 						-- select statement for the switch
		y <= 
			x when "00",
			x(0) & x(1) when "01",
			x(0) & x(0) when "10",
			x(1) & x(1) when others;
end sw_arch;
