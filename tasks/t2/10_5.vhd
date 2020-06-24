library ieee;
use ieee.std_logic_1164.all;

-- definitions of the input and output signals in entity
entity preamble_det is
    port(
        clk: in std_logic;
        start: in std_logic;
        data_out: out std_logic
    );
end preamble_det;

-- definition of the architecture 
architecture detection_arch of preamble_det is 
    -- defining the states
    type mc_state_type is 
        (idle, s11, s01, s12, s02, s13, s03, s14, s04);
    signal state_reg, state_next: mc_state_type;
begin
    -- state register
    -- assigning next state, no reset as the question does not have it
    process(clk)
    begin
        if (clk'event and clk='1') then 
            state_reg <= state_next;
        end if;
    end process;
    
    
    -- next-state logic
    -- next state depending on the current state and the input signals
    process(state_reg, start)
    begin
        case state_reg is
            when idle =>
                if start='1' then
                    state_next <= s11;              -- go to read1 state
                else
                    state_next <= idle;                   -- go to idle state
                end if;
            when s11 =>
                state_next <= s01;
            when s01 =>
                state_next <= s12;
            when s12 =>
                state_next <= s02;
            when s02 =>
                state_next <= s13;
            when s13 =>
                state_next <= s03;
            when s03 =>
                state_next <= s14;
            when s14 =>
                state_next <= s04;
            when s04 =>
                state_next <= idle;
        end case;
    end process;
    
    -- Moore output logic
    -- Only dependent on the state
    process(state_reg)
    begin
        data_out <= '0'; -- default value
        -- setting the Moore output in the states, when idle output is 0
        case state_reg is
            when idle =>
            when s11 =>
                data_out <= '1';
            when s01 =>
            when s12 =>
                data_out <= '1';
            when s02 =>
            when s13 =>
                data_out <= '1';
            when s03 =>
            when s14 =>
                data_out <= '1';
            when s04 =>
        end case;
    end process;
end detection_arch;