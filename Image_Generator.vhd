--Name: Ty Ahrens 
--Date: 4/13/2025
--Purpose: Generate an image for the blocks, paddle, and border

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity hw_image_generator is
    port (
        disp_ena        : in  STD_LOGIC;
		CLK				: in  STD_LOGIC;
        row             : in  INTEGER;
        column          : in  INTEGER;
		encoder_value   : in  INTEGER;
        delay_done      : in  STD_LOGIC;
        SW1             : in  STD_LOGIC;
		  led0, led1, led2, led3 : out STD_LOGIC;
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

    signal quad1  : STD_LOGIC := '0';
    signal quad2  : STD_LOGIC := '0';
    signal quad3  : STD_LOGIC := '1';
    signal quad4  : STD_LOGIC := '0';
	 signal quad1t  : STD_LOGIC := '0';
    signal quad2t  : STD_LOGIC := '0';
    signal quad3t  : STD_LOGIC := '0';
    signal quad4t  : STD_LOGIC := '0';
	signal paddle_collision : STD_LOGIC := '0';
    signal borderl_collision : STD_LOGIC := '0';
    signal bordert_collision : STD_LOGIC := '0';
    signal borderr_collision : STD_LOGIC := '0';
    signal block_collision   : STD_LOGIC_VECTOR(111 downto 0) := (OTHERS => '0');
    signal index : integer := 0;
    signal gen_idx : integer := 0;
    signal score1 : integer range 0 to 999 := 0;
    signal score2 : integer range 0 to 999 := 0;
    signal ball_count_p1 : integer range 0 to 5 := 5;
    signal ball_count_p2 : integer range 0 to 5 := 5;
    signal block_col_true : STD_LOGIC := '0';
	signal prev_col_idx : integer := 1;
    signal paddle_posL : integer;
    signal paddle_posR : integer;
	signal ball_posL  : integer;
    signal ball_posR  : integer;
    signal ball_posT  : integer;
    signal ball_posB  : integer;

    signal block_colb_true : STD_LOGIC := '0';
	signal block_coll_true : STD_LOGIC := '0';
	signal block_colr_true : STD_LOGIC := '0';
	signal block_colt_true : STD_LOGIC := '0';

    signal ball_prevL, ball_prevR, ball_prevT, ball_prevB : integer;




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

    --Score Text Area for Player 1
	constant score1_top         : integer := row1_top - 45;
	constant score1_bottom      : integer := row1_top - 5;
	constant score1_huns_left   : integer := column2_left + 4;
	constant score1_huns_right  : integer := column2_right - 4;
	constant score1_tens_left   : integer := column3_left + 4;
	constant score1_tens_right  : integer := column3_right - 4;
	constant score1_ones_left   : integer := column4_left + 4;
	constant score1_ones_right  : integer := column4_right - 4;
	
	--Score Text Area for Player 2
	constant score2_top         : integer := row1_top - 45;
	constant score2_bottom      : integer := row1_top - 5;
	constant score2_huns_left   : integer := column10_left + 4;
	constant score2_huns_right  : integer := column10_right - 4;
	constant score2_tens_left   : integer := column11_left + 4;
	constant score2_tens_right  : integer := column11_right - 4;
	constant score2_ones_left   : integer := column12_left + 4;
	constant score2_ones_right  : integer := column12_right - 4;
	
	--Ball Count Text Area Player 1
	constant ball_count1_top    : integer := border_top + 5;
	constant ball_count1_bottom : integer := border_top + 45;
	constant ball_count1_left   : integer := column1_left + 4;
	constant ball_count1_right  : integer := column1_right - 4;
	
	--Ball Count Text Area Player 2
	constant ball_count2_top    : integer := border_top + 5;
	constant ball_count2_bottom : integer := border_top + 45;
	constant ball_count2_left   : integer := column9_left + 4;
	constant ball_count2_right  : integer := column9_right - 4;

    function draw_digit(digit : in integer; row_index : in integer; col_index : in integer) return boolean is
        variable p : boolean := false;
      begin
        case digit is
      
          when 0 =>
            if (
              (row_index >= 0 and row_index <= 5 and col_index >= 0 and col_index <= 29) or -- top
              (row_index >= 34 and row_index <= 39 and col_index >= 0 and col_index <= 29) or -- bottom
              (col_index >= 0 and col_index <= 5 and row_index >= 0 and row_index <= 39) or -- left
              (col_index >= 24 and col_index <= 29 and row_index >= 0 and row_index <= 39) -- right
            ) then
              p := true;
            end if;
      
          when 1 =>
            if (
              (col_index >= 24 and col_index <= 29 and row_index >= 0 and row_index <= 39)
            ) then
              p := true;
            end if;
      
          when 2 =>
            if (
              (row_index >= 0 and row_index <= 5 and col_index >= 0 and col_index <= 29) or -- top
              (row_index >= 17 and row_index <= 22 and col_index >= 0 and col_index <= 29) or -- mid
              (row_index >= 34 and row_index <= 39 and col_index >= 0 and col_index <= 29) or -- bottom
              (col_index >= 24 and col_index <= 29 and row_index >= 0 and row_index <= 22) or -- top-right
              (col_index >= 0 and col_index <= 5 and row_index >= 17 and row_index <= 39) -- bottom-left
            ) then
              p := true;
            end if;
      
          when 3 =>
            if (
              (row_index >= 0 and row_index <= 5 and col_index >= 0 and col_index <= 29) or
              (row_index >= 17 and row_index <= 22 and col_index >= 0 and col_index <= 29) or
              (row_index >= 34 and row_index <= 39 and col_index >= 0 and col_index <= 29) or
              (col_index >= 24 and col_index <= 29 and row_index >= 0 and row_index <= 39)
            ) then
              p := true;
            end if;
      
          when 4 =>
            if (
              (col_index >= 0 and col_index <= 5 and row_index >= 0 and row_index <= 22) or
              (col_index >= 24 and col_index <= 29 and row_index >= 0 and row_index <= 39) or
              (row_index >= 17 and row_index <= 22 and col_index >= 0 and col_index <= 29)
            ) then
              p := true;
            end if;
      
          when 5 =>
            if (
              (row_index >= 0 and row_index <= 5 and col_index >= 0 and col_index <= 29) or
              (row_index >= 17 and row_index <= 22 and col_index >= 0 and col_index <= 29) or
              (row_index >= 34 and row_index <= 39 and col_index >= 0 and col_index <= 29) or
              (col_index >= 0 and col_index <= 5 and row_index >= 0 and row_index <= 22) or
              (col_index >= 24 and col_index <= 29 and row_index >= 17 and row_index <= 39)
            ) then
              p := true;
            end if;
      
          when 6 =>
            if (
              (row_index >= 0 and row_index <= 5 and col_index >= 0 and col_index <= 29) or
              (row_index >= 17 and row_index <= 22 and col_index >= 0 and col_index <= 29) or
              (row_index >= 34 and row_index <= 39 and col_index >= 0 and col_index <= 29) or
              (col_index >= 0 and col_index <= 5 and row_index >= 0 and row_index <= 39) or
              (col_index >= 24 and col_index <= 29 and row_index >= 17 and row_index <= 39)
            ) then
              p := true;
            end if;
      
          when 7 =>
            if (
              (row_index >= 0 and row_index <= 5 and col_index >= 0 and col_index <= 29) or
              (col_index >= 24 and col_index <= 29 and row_index >= 0 and row_index <= 39)
            ) then
              p := true;
            end if;
      
          when 8 =>
            if (
              (row_index >= 0 and row_index <= 5 and col_index >= 0 and col_index <= 29) or
              (row_index >= 17 and row_index <= 22 and col_index >= 0 and col_index <= 29) or
              (row_index >= 34 and row_index <= 39 and col_index >= 0 and col_index <= 29) or
              (col_index >= 0 and col_index <= 5 and row_index >= 0 and row_index <= 39) or
              (col_index >= 24 and col_index <= 29 and row_index >= 0 and row_index <= 39)
            ) then
              p := true;
            end if;
      
          when 9 =>
            if (
              (row_index >= 0 and row_index <= 5 and col_index >= 0 and col_index <= 29) or
              (row_index >= 17 and row_index <= 22 and col_index >= 0 and col_index <= 29) or
              (row_index >= 34 and row_index <= 39 and col_index >= 0 and col_index <= 29) or
              (col_index >= 0 and col_index <= 5 and row_index >= 0 and row_index <= 22) or
              (col_index >= 24 and col_index <= 29 and row_index >= 0 and row_index <= 39)
            ) then
              p := true;
            end if;
      
          when others =>
            p := false;
      
        end case;
      
        return p;
      end function;

begin	 	 

    process(paddle_collision, delay_done, borderl_collision, borderr_collision, bordert_collision, block_colb_true, block_colt_true, block_coll_true, block_colr_true)
    begin
            if rising_edge(delay_done) then
                if SW1 = '0' then 
                    ball_top_range <= ball_top_range;
                    ball_left_range <= ball_left_range;
                    quad1 <= quad1;
                    quad2 <= quad2;
                    quad3 <= quad3;
                    quad4 <= quad4;
                elsif (paddle_collision = '1') and (quad3 = '1') then
                        quad1 <= '0';
                        quad2 <= '1';
                        quad3 <= '0';
                        quad4 <= '0'; 
                elsif (paddle_collision = '1') and (quad4 = '1') then
                        quad1 <= '1';
                        quad2 <= '0';
                        quad3 <= '0';
                        quad4 <= '0'; 
                elsif ((borderl_collision = '1') and (quad3 = '1')) then
                    quad1 <= '0';
                    quad2 <= '0';
                    quad3 <= '0';
                    quad4 <= '1';
                elsif ((borderl_collision = '1') and (quad2 = '1')) then
                    quad1 <= '1';
                    quad2 <= '0';
                    quad3 <= '0';
                    quad4 <= '0';
                elsif ((borderr_collision = '1') and (quad4 = '1')) then
                    quad1 <= '0';
                    quad2 <= '0';
                    quad3 <= '1';
                    quad4 <= '0';
                elsif ((borderr_collision = '1') and (quad1 = '1')) then
                    quad1 <= '0';
                    quad2 <= '1';
                    quad3 <= '0';
                    quad4 <= '0';
                elsif ((bordert_collision = '1') and (quad1 = '1')) then
                    quad1 <= '0';
                    quad2 <= '0';
                    quad3 <= '0';
                    quad4 <= '1';
                elsif ((bordert_collision = '1') and (quad2 = '1')) then
                    quad1 <= '0';
                    quad2 <= '0';
                    quad3 <= '1';
                    quad4 <= '0';
                else 
                    if quad1 = '1' then
                        ball_left_range <= ball_left_range + 1;
                        ball_top_range  <= ball_top_range - 1;
                        quad2 <= '0';
                        quad3 <= '0';
                        quad4 <= '0';
                    elsif quad2 = '1' then
                        ball_left_range <= ball_left_range - 1;
                        ball_top_range  <= ball_top_range - 1;
                        quad1 <= '0';
                        quad3 <= '0';
                        quad4 <= '0';
                    elsif quad3 = '1' then
                        ball_left_range <= ball_left_range - 1;
                        ball_top_range  <= ball_top_range + 1;
                        quad1 <= '0';
                        quad2 <= '0';
                        quad4 <= '0';
                    elsif quad4 = '1' then
                        ball_left_range <= ball_left_range + 1;
                        ball_top_range  <= ball_top_range + 1;
                        quad1 <= '0';
                        quad2 <= '0';
                        quad3 <= '0';
                    else 
                        ball_left_range <= ball_left_range;
                        ball_top_range  <= ball_top_range;
                        quad1 <= quad1;
                        quad2 <= quad2;
                        quad3 <= quad3;
                        quad4 <= quad4;
                    end if;
					end if;
					       -- Block collision detection
                           
        for row_idx in 0 to 7 loop
            for col_idx in 0 to 13 loop

                if block_collision((row_idx * 14) + col_idx) = '0' then
                    -- Bottom collision (ball hits top of block)
                    if ball_posT <= row_bottoms(row_idx) and ball_posT >= row_tops(row_idx) and
                       ball_posR >= column_lefts(col_idx) and ball_posL <= column_rights(col_idx) then
							  block_collision((row_idx * 14) + col_idx) <= '1';
							  score1 <= score1 + 1;

							  if (quad1 = '1') then
								  quad1 <= '0';
								  quad2 <= '0';
								  quad3 <= '0';
								  quad4 <= '1';
								  --score1 <= score1 + 1;
							  elsif(quad2 = '1') then
								  quad1 <= '0';
								  quad2 <= '0';
								  quad3 <= '1';
								  quad4 <= '0';
								  --score1 <= score1 + 1;
								end if;
                        block_collision((row_idx * 14) + col_idx) <= '1';
                    -- Top collision (ball hits bottom of block)
                    elsif ball_posB >= row_tops(row_idx) and ball_posB <= row_bottoms(row_idx) and
                          ball_posR >= column_lefts(col_idx) and ball_posL <= column_rights(col_idx) then
								  block_collision((row_idx * 14) + col_idx) <= '1';
								if (quad3 = '1') then
										  quad1 <= '0';
										  quad2 <= '1';
										  quad3 <= '0';
										  quad4 <= '0';
										  --score1 <= score1 + 1;
								elsif (quad4 = '1') then
										  quad1 <= '1';
										  quad2 <= '0';
										  quad3 <= '0';
										  quad4 <= '0';
										  --score1 <= score1 + 1;
								end if;
								block_collision((row_idx * 14) + col_idx) <= '1';
                    -- Left side collision
                    elsif ball_posR >= column_lefts(col_idx) and ball_posR <= column_rights(col_idx) and
                          ball_posB >= row_tops(row_idx) and ball_posT <= row_bottoms(row_idx) then
								  block_collision((row_idx * 14) + col_idx) <= '1';
								if (quad1 = '1') then
								  quad1 <= '0';
								  quad2 <= '1';
								  quad3 <= '0';
								  quad4 <= '0';
								  --score1 <= score1 + 1;
								elsif (quad4 = '1') then
								  quad1 <= '0';
								  quad2 <= '0';
								  quad3 <= '1';
								  quad4 <= '0';
								  --score1 <= score1 + 1;
								 end if;
                        block_collision((row_idx * 14) + col_idx) <= '1';
                    -- Right side collision
                    elsif ball_posL <= column_rights(col_idx) and ball_posL >= column_lefts(col_idx) and
                          ball_posB >= row_tops(row_idx) and ball_posT <= row_bottoms(row_idx) then
								  block_collision((row_idx * 14) + col_idx) <= '1';
								if (quad2 = '1') then
									  quad1 <= '1';
									  quad2 <= '0';
									  quad3 <= '0';
									  quad4 <= '0';
									  --score1 <= score1 + 1;
								elsif (quad3 = '1') then
									  quad1 <= '0';
									  quad2 <= '0';
									  quad3 <= '0';
									  quad4 <= '1'; 
									  --score1 <= score1 + 1;
								end if;
                    end if;
                end if;
            end loop;
        end loop;
	
            end if;
    end process;
	 
	 
	     process(disp_ena, row, column, encoder_value, CLK)
         variable hundreds1, tens1, ones1 : integer;
         variable hundreds2, tens2, ones2 : integer;
         variable digit_row, digit_col    : integer;
		
    begin
	 	 --if rising_edge(CLK) then
	     -- Default color to black
        red   <= X"00";
        green <= X"00";
        blue  <= X"00"; 
		  

        if disp_ena = '1' then            -- Paddle position based on encoder_value
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
				end if;
            
            -- Display Score
            hundreds1 := (score1 / 100);
            tens1     := ((score1 / 10) mod 10);
            ones1		 := (score1 mod 10);
            
            hundreds2 := (score2 / 100);
            tens2     := ((score2 / 10) mod 10);
            ones2		 := (score2 mod 10);
            
            --Hundreds Player 1
            if (row >= score1_top and row <= score1_bottom) then
            if (column >= score1_huns_left and column <= score1_huns_right) then
            digit_row := row - score1_top;
            digit_col := column - score1_huns_left;
            if draw_digit(hundreds1, digit_row, digit_col) then
                red   <= X"9D";
                green <= X"00";
                blue  <= X"FF";
                end if;
            end if;
            end if;
            
            --Tens Player 1
            if (row >= score1_top and row <= score1_bottom) then
                if (column >= score1_tens_left and column <= score1_tens_right) then
                    digit_row := row - score1_top;
                    digit_col := column - score1_tens_left;
                    if draw_digit(tens1, digit_row, digit_col) then
                        red   <= X"9D";
                        green <= X"00";
                        blue  <= X"FF";
                    end if;
                end if;
            end if;
            
            --Ones Player 1
            if (row >= score1_top and row <= score1_bottom) then
                if (column >= score1_ones_left and column <= score1_ones_right) then
                    digit_row := row - score1_top;
                    digit_col := column - score1_ones_left;
                    if draw_digit(ones1, digit_row, digit_col) then
                        red   <= X"9D";
                        green <= X"00";
                        blue  <= X"FF";
                    end if;
                end if;
            end if;
            
            --Hundreds Player 2
            if (row >= score2_top and row <= score2_bottom) then
            if (column >= score2_huns_left and column <= score2_huns_right) then
            digit_row := row - score2_top;
            digit_col := column - score2_huns_left;
            if draw_digit(hundreds2, digit_row, digit_col) then
                        red   <= X"FF";
                        green <= X"DF";
                        blue  <= X"00";
                end if;
            end if;
            end if;
            
            --Tens Player 2
            if (row >= score2_top and row <= score2_bottom) then
                if (column >= score2_tens_left and column <= score2_tens_right) then
                    digit_row := row - score2_top;
                    digit_col := column - score2_tens_left;
                    if draw_digit(tens2, digit_row, digit_col) then
                        red   <= X"FF";
                        green <= X"DF";
                        blue  <= X"00";
                    end if;
                end if;
            end if;
            
            --Ones Player 2
            if (row >= score2_top and row <= score2_bottom) then
                if (column >= score2_ones_left and column <= score2_ones_right) then
                    digit_row := row - score2_top;
                    digit_col := column - score2_ones_left;
                    if draw_digit(ones2, digit_row, digit_col) then
                        red   <= X"FF";
                        green <= X"DF";
                        blue  <= X"00";
                    end if;
                end if;
            end if;
            
            --Ball Count Player 1
            if (row >= ball_count1_top and row <= ball_count1_bottom) then
                if (column >= ball_count1_left and column <= ball_count1_right) then
                    digit_row := row - ball_count1_top;
                    digit_col := column - ball_count1_left;
                    if draw_digit(ball_count_p1, digit_row, digit_col) then
                        red   <= X"9D";
                        green <= X"00";
                        blue  <= X"FF";
                    end if;
                end if;
            end if;
            
            --Ball Count Player 2
            if (row >= ball_count2_top and row <= ball_count2_bottom) then
                if (column >= ball_count2_left and column <= ball_count2_right) then
                    digit_row := row - ball_count2_top;
                    digit_col := column - ball_count2_left;
                    if draw_digit(ball_count_p2, digit_row, digit_col) then
                        red   <= X"FF";
                        green <= X"DF";
                        blue  <= X"00";
                    end if;
                end if;
            end if;

                -- Loop over rows and columns
                for row_idx in 0 to 7 loop
                    for col_idx in 0 to 13 loop
                        if row >= row_tops(row_idx) and row <= row_bottoms(row_idx) and
                           column >= column_lefts(col_idx) and column <= column_rights(col_idx) and block_collision(((row_idx * 14) + col_idx)) = '0' then
                                red <= X"FF"; green <= X"FF"; blue <= X"FF";  -- Bright white
                        end if;
                    end loop;
                end loop;
            --end if;
		  
		  end if;
    end process;
	 
	process(CLK)

begin
    if rising_edge(CLK) then
        -- Cache positions
        paddle_posL <= encoder_value - paddle_width / 2;
        paddle_posR <= encoder_value + paddle_width / 2;

        ball_posL <= ball_left + ball_left_range;
        ball_posT <= ball_top + ball_top_range;
        ball_posR <= ball_posL + 6;
        ball_posB <= ball_posT + 6;

        -- Collision detection
        if ball_posB = paddle_top and ball_posR >= paddle_posL and ball_posL <= paddle_posR then
            paddle_collision <= '1';
        else
            paddle_collision <= '0';
        end if;

        if ball_posL = BORDER_LEFT then
            borderl_collision <= '1';
        else
            borderl_collision <= '0';
        end if;

        if ball_posR = BORDER_RIGHT then
            borderr_collision <= '1';
        else
            borderr_collision <= '0';
        end if;

        if ball_posT = BORDER_TOP then
            bordert_collision <= '1';
        else
            bordert_collision <= '0';
        end if;
		end if;


  
end process;
end behavior;