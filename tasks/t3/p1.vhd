library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- entity declaration for repetetive subtraction
entity rep_sub is
    port(
        -- inputs
        clk, reset: in std_logic;
        start: in std_logic;
        y_in, d_in: in std_logic_vector(7 downto 0);
        -- outputs
        ready, error_out: out std_logic;
        q_out, r_out: out std_logic_vector(7 downto 0)
    );
end rep_sub;


-- architecture of the entity
architecture rep_sub_arch of rep_sub is 
    -- states
    type state_type is (Idle, Zero, Load, Operation, Done, Error);
    signal state_reg, state_next: state_type;
    -- check input signals
    signal ystd, yinstdin, y_is_0, d_is_0: std_logic;
    -- register signals
    signal y_reg, d_reg, q_reg, r_reg: unsigned(7 downto 0);
    -- signal after the multiplexers
    signal y_next, d_next, q_next, r_next: unsigned(7 downto 0);
    -- after operation
    signal y, q: unsigned(7 downto 0);
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
    process(state_reg, start, ystd, yinstdin, y_is_0, d_is_0)
    begin
        case state_reg is
            when Idle =>
                if start='1' then
                    -- goto Error if d_in is 0
                    if (d_is_0='1') then
                        state_next <= Error;
                    -- goto Zero if y_in is 0
                    elsif (y_is_0='1') then
                        state_next <= Zero;
                    else
                        state_next <= Load;
                    end if;
                else
                    state_next <= Idle;
                end if;
            when Zero => 
                state_next <= Idle;
            when Load =>
                -- if y smaller than d goto Done
                if (yinstdin='1') then
                    state_next <= Done;
                else
                    state_next <= Operation;
                end if;
            when Operation =>
                -- if y smaller than d goto Done
                if (ystd='1') then
                    state_next <= Done;
                else
                    state_next <= Operation;
                end if;
            when Done =>
                state_next <= Idle;
            when Error =>
                state_next <= Idle;
        end case;
    end process;
    -- control path: output logic
    -- output ready and error when in the right state
    ready <= '1' when state_reg=Idle else '0';
    error_out <= '1' when state_reg=Error else '0';
    -- data path: data register
    process(clk, reset)
    begin 
        -- reseting everything
        if reset='1' then 
            y_reg <= (others=>'0');
            d_reg <= (others=>'0');
            q_reg <= (others=>'0');
            r_reg <= (others=>'0');
        -- updating the registers
        elsif (clk'event and clk='1') then 
            y_reg <= y_next;
            d_reg <= d_next;
            q_reg <= q_next;
            r_reg <= r_next;
        end if;
    end process;
    -- data path: routing multiplexer
    process(state_reg, y_reg, d_reg, q_reg, r_reg, y_in, d_in, y, q)
    begin
        -- controlling the multiplexers
        case state_reg is
            when Idle =>
                y_next <= y_reg;
                d_next <= d_reg;
                q_next <= q_reg;
                r_next <= r_reg;
            when Zero =>
                y_next <= y_reg;
                d_next <= d_reg;
                q_next <= (others=>'0');
                r_next <= (others=>'0');
            when Load =>
                y_next <= unsigned(y_in);
                d_next <= unsigned(d_in);
                q_next <= (others=>'0');
                r_next <= (others=>'0');
            when Operation =>
                y_next <= y;
                d_next <= d_reg;
                q_next <= q;
                r_next <= r_reg;
            when Done =>
                y_next <= y_reg;
                d_next <= d_reg;
                q_next <= q_reg;
                r_next <= y_reg;
            when Error =>
                y_next <= y_reg;
                d_next <= d_reg;
                q_next <= q_reg;
                r_next <= r_reg;
        end case;
    end process;     
    --data path: functional units
    -- performing the arithmetic operations
    y <= y_reg - d_reg;
    q <= q_reg + 1;
    --data path: status
    -- signals for cheching the inputs
    ystd <= '1' when y < d_reg else '0';
    yinstdin <= '1' when y_in < d_in else '0';
    y_is_0 <= '1' when y_in="00000000" else '0';
    d_is_0 <= '1' when d_in="00000000" else '0';
    --data path: output
    q_out <= std_logic_vector(q_reg);
    r_out <= std_logic_vector(r_reg);
end rep_sub_arch;
