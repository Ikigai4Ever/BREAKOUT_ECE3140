-- Combined Top-Level VHDL for VGA and Fibonacci Display
--
-- Integrates VGA image generation with Fibonacci computation and 7-segment display
--
-- Author: Based on work by Tyler McCormick and extended
-- Date: 2025-04-08

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test is
    Port (
        -- Clocks and control
        CLK        : in  STD_LOGIC;
        KEY0       : in  STD_LOGIC; -- active-low reset/control
		  KEY1 		 : in  STD_LOGIC;
		  
        ChA        : in  STD_LOGIC; -- CLK on RE
        ChB        : in  STD_LOGIC; -- DT on RE

        -- 7-Segment Display
        HEX0       : out STD_LOGIC_VECTOR(6 downto 0);
        HEX1       : out STD_LOGIC_VECTOR(6 downto 0);
        HEX2       : out STD_LOGIC_VECTOR(6 downto 0);
        HEX3       : out STD_LOGIC_VECTOR(6 downto 0);
        HEX4       : out STD_LOGIC_VECTOR(6 downto 0);
        HEX5       : out STD_LOGIC_VECTOR(6 downto 0);

        -- VGA Outputs
        h_sync_m   : out STD_LOGIC;
        v_sync_m   : out STD_LOGIC;
        red_m      : out STD_LOGIC_VECTOR(7 downto 0);
        green_m    : out STD_LOGIC_VECTOR(7 downto 0);
        blue_m     : out STD_LOGIC_VECTOR(7 downto 0)
    );
end test;

architecture Behavioral of test is

    constant paddle_movl  : integer := -100;
    constant paddle_movr  : integer := 100;

    -- Fibonacci Signals
    signal fib0, fib1 : unsigned(31 downto 0) := (others => '0');
    signal clk_div    : integer := 0;
    signal tick       : std_logic := '0';
    signal tick_pulse : std_logic := '0';

    constant CLK_FREQ      : integer := 50000000; -- 50 MHz
    constant FORWARD_TICKS : integer := CLK_FREQ;
    constant REVERSE_TICKS : integer := CLK_FREQ * 4 / 10;

    -- VGA Signals
    signal pll_out_clk : std_logic;
    signal dispEn      : std_logic;
    signal rowSignal   : integer;
    signal colSignal   : integer;

    -- Paddle Position from Rotary Encoder
    signal RE_Val       : integer := 0;
	signal prevA	    : STD_LOGIC := '0';
	signal prevB        : STD_LOGIC := '0';
    signal ChA_clean    : STD_LOGIC := '0';
    signal ChB_clean    : STD_LOGIC := '0';
	 
    constant DEBOUNCE_DELAY : integer := 5; -- Reduced debounce delay for responsiveness
    signal debounce_counter : integer := 0;
    signal rate_limit_counter : integer := 0;
    constant RATE_LIMIT : integer := 1; -- Reduced rate limit for smoother operation
	 

    -- 7-segment decoder
    function to_7seg(d : integer) return std_logic_vector is
        variable seg : std_logic_vector(6 downto 0);
    begin
        case d is
            when 0 => seg := "1000000";
            when 1 => seg := "1111001";
            when 2 => seg := "0100100";
            when 3 => seg := "0110000";
            when 4 => seg := "0011001";
            when 5 => seg := "0010010";
            when 6 => seg := "0000010";
            when 7 => seg := "1111000";
            when 8 => seg := "0000000";
            when 9 => seg := "0010000";
            when others => seg := "1111111";
        end case;
        return seg;
    end function;

    -- VGA Components
    component vga_pll_25_175
        port (
            inclk0 : in  STD_LOGIC := '0';
            c0     : out STD_LOGIC
        );
    end component;

    component vga_controller
        port (
            pixel_clk : in  STD_LOGIC;
            reset_n   : in  STD_LOGIC;
            h_sync    : out STD_LOGIC;
            v_sync    : out STD_LOGIC;
            disp_ena  : out STD_LOGIC;
            column    : out INTEGER;
            row       : out INTEGER;
            n_blank   : out STD_LOGIC;
            n_sync    : out STD_LOGIC
        );
    end component;

    component hw_image_generator
        port (
            disp_ena : in  STD_LOGIC;
            row      : in  INTEGER;
            column   : in  INTEGER;
            RE_Val   : in  integer;
            red      : out STD_LOGIC_VECTOR(7 downto 0);
            green    : out STD_LOGIC_VECTOR(7 downto 0);
            blue     : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

begin


--Rotary encoder process with debouncing, rate limiting, and clamping
--Rotary encoder process with optimized debouncing and rate limiting
process(CLK)
begin
    if rising_edge(CLK) then
        if KEY1 = '0' then
            encoder_value <= paddle_start_x;
            prevA <= '0';
        else
            -- Detect rising edge on ChA
            if (prevA = '0') and (ChA_clean = '1') then
                -- Determine direction using ChB
                if ChB_clean = '0' then  -- Clockwise
                    if (encoder_value < paddle_movr) and ((encoder_value + paddle_length) < border_right) then
                        encoder_value <= encoder_value + mov_speed;  -- Adjust movement speed
                    end if;
                else  -- Counter-clockwise
                    if (encoder_value > paddle_movl) and ((encoder_value - paddle_length) > border_left)  then
                        encoder_value <= encoder_value - mov_speed;
                    end if;
                end if;
            end if; 
            prevA <= ChA_clean;
        end if;
    end if;
end process;

    -- Fibonacci Display
    process(fib0)
    begin
        display_number(fib0, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    end process;

    -- VGA Signal Routing
    U1: vga_pll_25_175 port map(CLK, pll_out_clk);
    U2: vga_controller port map(pll_out_clk, '1', h_sync_m, v_sync_m, dispEn, colSignal, rowSignal, open, open);
    U3: hw_image_generator port map(dispEn, rowSignal, colSignal, RE_Val, red_m, green_m, blue_m);

    -- Debouncers for the rortary encoder signals
    debounce_ChA: entity work.Debounce
        port map (
            clk   => CLK,
            noisy => ChA,
            clean => ChA_clean
        );

    debounce_ChB: entity work.Debounce
        port map (
            clk   => CLK,
            noisy => ChB,
            clean => ChB_clean
        );

end Behavioral;  
