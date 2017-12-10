----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:08:36 11/15/2017 
-- Design Name: 
-- Module Name:    dibuja - Behavioral 
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

entity pajaro is
	 Generic ( Nbit : integer := 10;
				  posx : integer := 100;
				  posy : integer := 200);
    Port ( --clk : in STD_LOGIC;
			  --reset : in STD_LOGIC;
			  --boton : in STD_LOGIC;
			  --enable : in STD_LOGIC;		--Pulso cuando avanza una pantalla (O3V)
			  eje_x : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
           RED_int : out  STD_LOGIC_VECTOR (2 downto 0);
           GREEN_int : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE_int : out  STD_LOGIC_VECTOR (1 downto 0));
end pajaro;

architecture Behavioral of pajaro is
	--constant MAX: integer := max_x+max_y;
	--signal cuenta_actual, cuenta_prox: integer range MAX downto 0;

begin
	
--	sinc: process(clk, reset)
--	begin
--		if(reset='1') then
--			cuenta_actual <= 0;
--			imagen_actual <= 0;
--		elsif(rising_edge(clk)) then
--			cuenta_actual <= cuenta_prox;
--			imagen_actual <= imagen_prox;
--		end if;
--	end process;

--	comb: process(cuenta_actual, imagen_actual, enable)
--	begin
--		cuenta_prox <= cuenta_actual;
--		imagen_prox <= imagen_actual;
--
--		if(enable='1' and cuenta_actual>=MAX) then
--				cuenta_prox <= 0;
--				if(imagen_actual = 3) then
--					imagen_prox <= 0;
--				else
--					imagen_prox <= imagen_actual+1;
--				end if;
--		elsif(enable='1') then
--			cuenta_prox <= cuenta_actual+3;
--		end if;
--
--	end process;
	
	dibuja: process(eje_x, eje_y)
	begin
		--Colores a 0 en general
		RED_int<="000";
		GREEN_int<="000";
		BLUE_int<="00";
		
		--Dibujamos el cuadrado en rojo
		if(unsigned(eje_x)>=posx and unsigned(eje_x)<=posx+32 and
			unsigned(eje_y)>=posy and unsigned(eje_y)<=posy+32) then
			RED_int<="111";
		end if;
	
	end process;

end Behavioral;

