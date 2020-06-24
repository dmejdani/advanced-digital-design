library ieee;
use ieee.std_logic_1164.all;

entity XilinxIntro is
  
  port (
    switches : in  std_logic_vector(7 downto 0);
    buttons : in  std_logic_vector(3 downto 0);
    leds : out std_logic_vector(7 downto 0));

end XilinxIntro;

architecture simple of XilinxIntro is

begin  -- simple

  leds <= "00000000" when buttons(0)='1' else
          "11111111" when buttons(1)='1' else
          switches;

end simple;

architecture simple2 of XilinxIntro is

begin  -- simple2

  leds <= "11111111" when buttons(1)='1' else
          "00000000" when buttons(0)='1' else
          switches;
 

end simple2;
