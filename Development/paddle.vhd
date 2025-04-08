--      Name: Ty Ahrens 
--      Date: 3/30/2025
--      Purpose: Description of the paddle for the final project

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 


entity paddle is
    generic(pos : unsigned_integer := 0;     -- used for keeping the position of the leftmost pixel
            paddleWidth : std_logic_vector(7 downto 0) := "00011001");  -- paddle size is 25 pixels long  

    -- port IN: used for two different channels form rotary encoder
    -- port OUT: used for the left and right pixel positions to display on the VGA port
    port(ChannelA, ChannelB : IN std_logic;
         rightPixel, leftPixel : OUT std_logic_vector(7 downto 0));

end paddle;

architecture behavior of paddle is  

    --signal used to convert the position to a binary value instead of an integer for the display
    signal conv_pos : std_logic_vector(to_unsigned(pos, 7));

begin
    movePaddle : process(ChannelA)
    begin
        changeLocation : process(ChannelB)
        begin
            if (ChannelB = '1') then 
                pos <= pos + 1;
            elsif (ChannelB = '0') then 
                pos <= pos - 1; 
            end if;
        end process changeLocation;

    end process movePaddle;
end behavior;