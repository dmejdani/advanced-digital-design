library ieee;
use ieee.std_logic_1164.all;

-- definitions of the input and output signals in entity
entity preamble_det is
    port(
        clk: in std_logic;
        data_in: in std_logic;
        match: out std_logic
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
    process(state_reg, data_in)
    begin
        case state_reg is
            when idle =>
                if data_in='1' then
                    state_next <= s11;
                else
                    state_next <= idle;
                end if;
            when s11 =>
                if data_in='0' then
                    state_next <= s01;
                else
                    state_next <= idle;
                end if;
            when s01 =>
                if data_in='1' then
                    state_next <= s12;
                else
                    state_next <= idle;
                end if;
            when s12 =>
                if data_in='0' then
                    state_next <= s02;
                else
                    state_next <= idle;
                end if;
            when s02 =>
                if data_in='1' then
                    state_next <= s13;
                else
                    state_next <= idle;
                end if;
            when s13 =>
                if data_in='0' then
                    state_next <= s03;
                else
                    state_next <= idle;
                end if;
            when s03 =>
                if data_in='1' then
                    state_next <= s14;
                else
                    state_next <= idle;
                end if;
            when s14 =>
                if data_in='0' then
                    state_next <= s04;
                else
                    state_next <= idle;
                end if;
            when s04 =>
                state_next <= idle;
        end case;
    end process;
    
    -- Moore output logic
    -- Only dependent on the state
    process(state_reg)
    begin
        match <= '0'; -- default value
        -- setting the Moore output in the states
        case state_reg is
            when idle =>
            when s11 =>
            when s01 =>
            when s12 =>
            when s02 =>
            when s13 =>
            when s03 =>
            when s14 =>
            when s04 =>
                match<='1';
        end case;
    end process;
end detection_arch;