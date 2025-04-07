--      Name: Ty Ahrens 
--      Date: 3/30/2025
--      Purpose: Description of the paddle for the final project

library IEEE;
use IEEE.std_logic_1164.all;


entity paddle is
    generic(pos : integer := 0);

    port(ChannelA, ChannelB : IN std_logic;
         middlePixel, rightPixel, leftPixel : OUT std_logic_vector(7 downto 0));
         
end paddle;

architecture behavior of paddle is 

begin
    movePaddle : process(ChannelA){

    }

end behavior;