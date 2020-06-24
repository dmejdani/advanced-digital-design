library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- entity declaration for repetetive subtraction
entity zero_count is
    port(
        -- inputs
        clk, reset: in std_logic;
        start: in std_logic;
        a_in: in std_logic_vector(7 downto 0);
        -- outputs
        ready: out std_logic;
        n_out: out std_logic_vector(7 downto 0)
    );
end zero_count;

-- architecture of the entity
architecture count_arch of zero_count is 
    -- states
    type state_type is (Idle, Load, Count);
    signal state_reg, state_next: state_type;
    -- check signals
    signal a_is_1, a_shifted_is_1, idx_is_0: std_logic;
    -- register signals
    signal a_reg, n_reg, idx_reg: unsigned(7 downto 0);
    -- signal after the multiplexers
    signal a_next, n_next, idx_next: unsigned(7 downto 0);
    -- after operation
    signal a_shifted, n_p1, idx_m1: unsigned(7 downto 0);
begin
    -- control path: state register
    process(clk, reset)
    begin
        if reset='1' then
            state_reg <= idle;
        elsif (clk'event and clk='1') then 
            state_reg <= state_next;
        end if;
    end process;
    -- control path : next-state /output logic
    process(state_reg, start, a_is_1, a_shifted_is_1, idx_is_0)
    begin
        case state_reg is
            when Idle =>
                if start='1' then
                    state_next <= Load;
                else
                    state_next <= Idle;
                end if;
            when Load =>
                -- if it starts with 1
                if (a_is_1='1') then
                    state_next <= Idle;
                else
                    state_next <= Count;
                end if;
            when Count =>
                -- if a 1 is found or if the number is already covered
                if (a_shifted_is_1='1' or idx_is_0='1') then
                    state_next <= Idle;
                else
                    state_next <= Count;
                end if;
        end case;
    end process;
    -- control path: output logic
    -- output ready and error when in the right state
    ready <= '1' when state_reg=Idle else '0';
    -- data path: data register
    process(clk, reset)
    begin 
        -- reseting everything
        if reset='1' then 
            a_reg <= (others=>'0');
            n_reg <= (others=>'0');
            idx_reg <= (others=>'0');
        -- updating the registers
        elsif (clk'event and clk='1') then 
            a_reg <= a_next;
            n_reg <= n_next;
            idx_reg <= idx_next;
        end if;
    end process;
    -- data path: routing multiplexer
    process(state_reg, a_reg, n_reg, idx_reg, a_shifted, n_p1, idx_m1)
    begin
        -- controlling the multiplexers
        case state_reg is
            when Idle =>
                a_next <= a_reg;
                n_next <= n_reg;
                idx_next <= idx_reg;
            when Load =>
                -- loading input as unsinged
                a_next <= unsigned(a_in);
                -- starting n to 0
                n_next <= (others=>'0');
                idx_next <= "00001000";
            when Count =>
                -- left shift a for an efficient implementation
                a_next <= a_shifted;
                n_next <= n_p1;
                idx_next <= idx_m1;
        end case;
    end process;
    --data path: functional units
    -- performing the arithmetic operations
    -- left shifting a_reg, to have an efficient implementation
    a_shifted <= a_reg(7 downto 1) & '1';
    n_p1 <= n_reg + 1; -- adding to n
    idx_m1 <= idx_reg - 1; -- removing from index
    --data path: status
    -- signals for cheching the inputs
    a_is_1 <= '1' when a_in(7)='1' else '0'; -- if a starts with 1
    a_shifted_is_1 <= '1' when a_shifted(7)='1' else '0'; -- if the shifted starts with 1
    idx_is_0 <= '1' when idx_m1="00000000" else '0'; -- if the number is already covered
    --data path: output
    n_out <= std_logic_vector(n_reg); -- output the number of zeros
end count_arch;
