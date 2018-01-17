----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:59:27 11/07/2017 
-- Design Name: 
-- Module Name:    div_frec - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity frec_pixel is
	Port (clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			clk_pixel : out STD_LOGIC);
end frec_pixel;

architecture Behavioral of frec_pixel is
	signal fpixel, p_fpixel: std_logic;
begin
	clk_pixel <= fpixel;

	p_fpixel <= not fpixel;
	
	--Proceso síncrono: (con reset asíncrono)
	sinc: process(clk,reset)
	begin
		if (reset='1') then
			fpixel<='0';
		elsif (rising_edge(clk)) then
			fpixel<=p_fpixel;
		end if;
	end process;

end Behavioral;

