--Name: Ty Ahrens 
--Date: 4/13/2025
--Purpose: Generate an image for the blocks, paddle, and border

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity hw_image_generator is
    port (
        disp_ena        : in  STD_LOGIC;
        row             : in  INTEGER;
        column          : in  INTEGER;
	    encoder_value   : in  INTEGER;
        delay_done      : in  STD_LOGIC;
        SW1             : in STD_LOGIC;
        red             : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
        green           : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
        blue            : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0')
    );
end hw_image_generator;

architecture behavior of hw_image_generator is

    constant block_start_x : integer := 25;
    constant block_start_y : integer := 100;
    constant block_width   : integer := 37;
    constant block_height  : integer := 10;
    constant block_width_spacing : integer := 5;
    constant block_height_spacing : integer := 5; 


	constant paddle_top     : integer := 450;
    constant paddle_bottom  : integer := 460;
    constant paddle_left    : integer := 290;
    constant paddle_right   : integer := 350;
	constant paddle_width   : integer := 60;

    constant ball_top       : integer := 237;
    constant ball_bottom    : integer := 243;
    constant ball_left      : integer := 317;
    constant ball_right     : integer := 323;

    
    signal ball_top_range : integer range -225 to 234 := 0;
    signal ball_left_range : integer range -305 to 299 := 0;

    signal quad1  : STD_LOGIC;
    signal quad2  : STD_LOGIC;
    signal quad3  : STD_LOGIC;
    signal quad4  : STD_LOGIC;


    constant border_width  : integer := 15;
    constant BORDER_TOP   : integer := 0 + border_width; 
    constant BORDER_LEFT  : integer := -2 + border_width;
    constant BORDER_RIGHT : integer := 635 - border_width;

    constant row1_top    : integer := block_start_y;
    constant row1_bottom : integer := row1_top + block_height;
    constant row2_top    : integer := row1_bottom + block_height_spacing;
    constant row2_bottom : integer := row2_top + block_height;
    constant row3_top    : integer := row2_bottom + block_height_spacing;
    constant row3_bottom : integer := row3_top + block_height;
    constant row4_top    : integer := row3_bottom + block_height_spacing;
    constant row4_bottom : integer := row4_top + block_height;
    constant row5_top    : integer := row4_bottom + block_height_spacing;
    constant row5_bottom : integer := row5_top + block_height;
    constant row6_top    : integer := row5_bottom + block_height_spacing;
    constant row6_bottom : integer := row6_top + block_height;
    constant row7_top    : integer := row6_bottom + block_height_spacing;
    constant row7_bottom : integer := row7_top + block_height;
    constant row8_top    : integer := row7_bottom + block_height_spacing;
    constant row8_bottom : integer := row8_top + block_height;

    -- Row array constants for FOR loop
    type row_array is array(0 to 7) of integer;
    constant row_tops : row_array := (
        row1_top, row2_top, row3_top, row4_top,
        row5_top, row6_top, row7_top, row8_top
    );
    constant row_bottoms : row_array := (
        row1_bottom, row2_bottom, row3_bottom, row4_bottom,
        row5_bottom, row6_bottom, row7_bottom, row8_bottom
    );

    constant column1_left   : integer := block_start_x;
    constant column1_right  : integer := column1_left + block_width;
    constant column2_left   : integer := column1_right + block_width_spacing;
    constant column2_right  : integer := column2_left + block_width;
    constant column3_left   : integer := column2_right + block_width_spacing;
    constant column3_right  : integer := column3_left + block_width;
    constant column4_left   : integer := column3_right + block_width_spacing;
    constant column4_right  : integer := column4_left + block_width;
    constant column5_left   : integer := column4_right + block_width_spacing;
    constant column5_right  : integer := column5_left + block_width;
    constant column6_left   : integer := column5_right + block_width_spacing;
    constant column6_right  : integer := column6_left + block_width;
    constant column7_left   : integer := column6_right + block_width_spacing;
    constant column7_right  : integer := column7_left + block_width;
    constant column8_left   : integer := column7_right + block_width_spacing;
    constant column8_right  : integer := column8_left + block_width;
    constant column9_left   : integer := column8_right + block_width_spacing;
    constant column9_right  : integer := column9_left + block_width;
    constant column10_left  : integer := column9_right + block_width_spacing;
    constant column10_right : integer := column10_left + block_width;
    constant column11_left  : integer := column10_right + block_width_spacing;
    constant column11_right : integer := column11_left + block_width;
    constant column12_left  : integer := column11_right + block_width_spacing;
    constant column12_right : integer := column12_left + block_width;
    constant column13_left  : integer := column12_right + block_width_spacing;
    constant column13_right : integer := column13_left + block_width;
    constant column14_left  : integer := column13_right + block_width_spacing;
    constant column14_right : integer := column14_left + block_width;

    -- Column arrary constants for FOR loop
    type column_array is array(0 to 13) of integer;
    constant column_lefts : column_array := (
        column1_left, column2_left, column3_left, column4_left,
        column5_left, column6_left, column7_left, column8_left,
        column9_left, column10_left, column11_left, column12_left,
        column13_left, column14_left
    );
    constant column_rights : column_array := (
        column1_right, column2_right, column3_right, column4_right,
        column5_right, column6_right, column7_right, column8_right,
        column9_right, column10_right, column11_right, column12_right,
        column13_right, column14_right
        );
	 

begin	 	 

    process(disp_ena, delay_done)
    begin
        if disp_ena = '1' then
            if SW1 = '0' then 
                ball_top_range <= 0;
                ball_left_range <= 0;
                quad1 <= '1';
            else 
                if quad1 = '1' then
                    ball_left_range <= ball_left_range + 1;
                    ball_top_range  <= ball_top_range - 1;
                elsif quad2 = '1' then
                    ball_left_range <= ball_left_range - 1;
                    ball_top_range  <= ball_top_range - 1;
                elsif quad3 = '1' then
                    ball_left_range <= ball_left_range - 1;
                    ball_top_range  <= ball_top_range + 1;
                elsif quad4 = '1' then
                    ball_left_range <= ball_left_range + 1;
                    ball_top_range  <= ball_top_range + 1;
                else 
                    ball_left_range <= ball_left_range + 1;
                    ball_top_range  <= ball_top_range + 1;
                end if;
            end if;
        end if;
    end process;


    process(disp_ena, row, column, encoder_value)
        variable paddle_posL : integer;
        variable paddle_posR : integer;

        variable ball_posL  : integer;
        variable ball_posR  : integer;
        variable ball_posT  : integer;
        variable ball_posB  : integer;

    begin
        ball_posL := ball_left + ball_left_range;
        ball_posT := ball_top + ball_top_range;

        -- Default color to black
        red   <= X"00";
        green <= X"00";
        blue  <= X"00"; 

        if disp_ena = '1' then            -- Paddle position based on encoder_value
            paddle_posL := encoder_value - paddle_width / 2;
            paddle_posR := encoder_value + paddle_width / 2;

            ball_posR := ball_posL + 6;
            ball_posB := ball_posT + 6;

            -- Paddle coloring (White)
            if row >= paddle_top and row <= paddle_bottom and column >= paddle_posL  and column <= paddle_posR then
                red   <= X"FF";
                green <= X"FF";
                blue  <= X"FF";  
            -- Border coloring (White)
            elsif row <= BORDER_TOP or column <= BORDER_LEFT or column >= BORDER_RIGHT then
                red   <= X"FF";
                green <= X"FF";
                blue  <= X"FF";
            else 
                if row >= ball_posT and row <= ball_posB and column >= ball_posL and column <= ball_posR then
                    red   <= "11111111";
                    green <= "11111111";
                    blue  <= "11111111";
                end if;

                -- Loop over rows and columns
                for row_idx in 0 to 7 loop
                    for col_idx in 0 to 13 loop
                        if row >= row_tops(row_idx) and row <= row_bottoms(row_idx) and
                           column >= column_lefts(col_idx) and column <= column_rights(col_idx) then
                                red <= X"FF"; green <= X"FF"; blue <= X"FF";  -- Bright white
                           end if;
                    end loop;
                end loop;
            end if;
        end if;
    end process;
end behavior;
