library ieee;
use ieee.std_logic_1164.all;

-- definitions of the input and output signals in entity
entity mem_ctrl is
    port(
        clk, reset: in std_logic;
        mem, rw, burst: in std_logic;
        oe, we, we_me: out std_logic
    );
end mem_ctrl;

-- definition of the architecture 
architecture efficient_arch of mem_ctrl is 
    -- defining the states
    type mc_state_type is 
        (idle, read1, read2, read3, read4, write);
    signal state_reg, state_next: mc_state_type;
begin
    -- state register
    -- reset and assigning next state
    process(clk, reset)
    begin
        if (reset='1') then 
            state_reg <= idle;
        elsif (clk'event and clk='1') then 
            state_reg <= state_next;
        end if;
    end process;
    
    
    -- next-state logic
    -- next state depending on the current state and the input signals
    process(state_reg, mem, rw, burst)
    begin
        case state_reg is
            when idle =>
                if mem='1' then
                    if rw='1' then 
                        state_next <= read1;              -- go to read1 state
                    else
                        state_next <= write;              -- go to write state
                    end if;
                else
                    state_next <= idle;                   -- go to idle state
                end if;
            when write =>
                if mem='1' then
                    if rw='1' then
                        state_next <= read1;              -- go to read1 state
                    else
                        state_next <= write;               -- go to write state
                    end if;
                else
                    state_next <= idle;                   -- go to idle state
                end if;
            when read1 => 
                if mem='1' then
                    if rw='0' then
                        state_next <= write;              -- go to write state
                    else
                        if burst='1' then
                            state_next <= read2;          -- go to read2 state
                        else
                            state_next <= read1;          -- go to read1 state
                        end if;
                    end if;
                else
                    state_next <= idle;                  -- go to idle state
                end if;
            when read2 =>
                state_next <= read3;                     -- go to read3 state
            when read3 =>
                state_next <= read4;                     -- go to read4 state
            when read4 =>
                if mem='1' then
                    if rw='0' then
                        state_next <= write;             -- go to write state
                    else
                        state_next <= read1;             -- go to read1 state
                    end if;
                else
                    state_next <= idle;                  -- go to idle state
                end if;
        end case;
    end process;
    
    -- Moore output logic
    -- Only dependent on the state
    process(state_reg)
    begin
        we <= '0'; -- default value
        oe <= '0'; -- default value
        -- setting the Moore output in the states, when idle both outputs are 0
        case state_reg is
            when idle =>
            when write =>
                we <= '1';
            when read1 =>
                oe <= '1';
            when read2 =>
                oe <= '1';
            when read3 =>
                oe <= '1';
            when read4 =>
                oe <= '1';
        end case;
    end process;
    
    -- Mealy output logic
    -- dependent on the state and the input signals
    process(state_reg, mem, rw)
    begin
        we_me <= '0'; -- default value
        -- setting Mealy output
        case state_reg is
            when idle =>
                if (mem='1') and (rw='0') then
                    we_me <= '1';
                end if;
            when write =>
                if (mem='1') and (rw='0') then
                    we_me <= '1';
                end if;
            when read1 =>
                if (mem='1') and (rw='0') then
                    we_me <= '1';
                end if;
            when read2 =>
            when read3 => 
            when read4 => 
                if (mem='1') and (rw='0') then
                    we_me <= '1';
                end if;
        end case;
    end process;
end efficient_arch;