library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;		

entity seg_ctrl is
  port(
    gclk     : in  std_logic;                    -- Global clock input, 50MHz
    rst      : in  std_logic;                    -- Global reset input
    switches : in std_logic_vector(7 downto 0);  -- Input switches
    segments : out std_logic_vector(6 downto 0); -- Segment control
    an_sel   : out std_logic_vector(3 downto 0)  -- Anode control
    );
end seg_ctrl;


architecture rtl of seg_ctrl is

  -- A 15 bit counter
  signal count : unsigned(14 downto 0);
  signal position : unsigned(1 downto 0);
  signal digit : std_logic_vector(3 downto 0);

begin

  -- Clock divider
  process (gclk, rst)
  begin
    if gclk='1' and gclk'event then
      if rst='1' then                   -- Is this a synchronous or an
         count <= (others=>'0');        -- asynchronous reset?
      else
         count <= count+1;
      end if;
	end if;
  end process;	
	
  -- Anode decode circuitry
  position <= count(14 downto 13);

  with position select
  an_sel <=
    "1000" when "00",
    "0100" when "01",
    "0010" when "10",
    "0001" when others;

  with position select
  digit <= 
    switches(7 downto 4) when "00",
    switches(3 downto 0) when "01",
    switches(7 downto 4) and switches(3 downto 0) when "10",
    switches(7 downto 4) or switches(3 downto 0) when others;

  with digit select
  segments <= 
    "0000001" when "0000",
    "1001111" when "0001",
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
    "0111000" when others;

end rtl;