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
			  botonSubir : in STD_LOGIC;
			  finPantalla : in STD_LOGIC;		--Pulso cuando avanza una pantalla (O3V)
			  eje_x : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
           RED_int : out  STD_LOGIC_VECTOR (2 downto 0);
           GREEN_int : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE_int : out  STD_LOGIC_VECTOR (1 downto 0));
end pajaro;

architecture Behavioral of pajaro is

	type estado is (reposo, actualizarArriba, reposo2, actualizarY, actualizarV);
	signal estado_actual, estado_proximo : estado;
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

	comb:process(estado_actual, botonSubir, finPantalla)
	begin
		estado_proximo <= estado_actual;
		case estado_actual is
			when reposo =>
				if (boton = '1') then -- añadir muerte
					estado_proximo <= actualizarArriba;
				elsif (finPantalla = '1' AND posy /= MAXY) -- definir maxy, posy señal
					estado_proximo <= actualizarY;
				end if;
			when actualizarArriba =>
				subir <= '1'; -- crear señal (flag)
				estado_proximo <= reposo2; -- antiguo esperarBoton cambiar nombre
			when reposo2 =>
				if (finPantalla = '1' AND posy /= MAXY) then -- definir maxy, posy señal
					estado_proximo <= actualizarY;
				end if;
			when actualizarY =>
				if (subir = '1' AND pos_y >= vel_y) then -- no se sale de la pantalla
					p_pos_y <= pos_y - vel_y;
					subir <= '0'
				elsif (subir = '1' AND pos_y < vel_y)
					p_pos_y <= 0;
					subir <= '0'
				elsif (subir = '0' AND pos_y + alto + vel_y < MAXY) -- hacer que se hunda un poco
					p_pos_y <= pos_y + vel_y;
				else
					p_pos_y <= MAXY - alto;
				end if;
					
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

