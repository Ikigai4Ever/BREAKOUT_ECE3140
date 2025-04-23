--        NAME: Ty Ahrens
--        DATE: 4/23/25
-- DESCRIPTION: Active-Low 7-Segment Decoder (because the displays on the DE10-Lite are active low) 
--              Display letters are in reverse order from left to right
--              For example "1000000" is a '0' (GFEDCBA)

library IEEE;
use IEEE.std_logic_1164.all;

entity seg7_decoder is
    port(
        digit : IN integer; -- 4-bit binary input
        HEX : OUT std_logic_vector(6 downto 0)    -- seven segment output   
        );
end seg7_decoder;

architecture behavioral of seg7_decoder is

    --seven segment display is active low
    signal sevenSeg : std_logic_vector(6 downto 0) := "1111111";

begin 

		process (digit)
		begin
            --sevenSeg 0 to 9
            case digit is 
                when 0 =>
                    sevenSeg <= "1000000" ; -- 0
                when 1 =>
                    sevenSeg <= "1111001" ; -- 1
                when 2 =>
                    sevenSeg <= "0100100" ; -- 2
                when 3 =>
                    sevenSeg <= "0110000" ; -- 3
                when 4 =>
                    sevenSeg <= "0011001" ; -- 4
                when 5 =>
                    sevenSeg <= "0010010" ; -- 5
                when 6 =>
                    sevenSeg <= "0000010" ; -- 6
                when 7 =>
                    sevenSeg <= "1111000" ; -- 7
                when 8 =>
                    sevenSeg <= "0000000" ; -- 8
                when 9 =>
                    sevenSeg <= "0010000" ; -- 9
                when others =>
                    sevenSeg <= "1111111";  -- Blank
            END CASE;
    end process;
	-- address each segment to a bit in the sevenSeg vector
    HEX <= sevenSeg;
end behavioral;