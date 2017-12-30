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
				  pos_x : integer := 100;
				  alto : integer := 32;
				  impulso : integer := 35);
    Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
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
	signal pos_y, p_pos_y : unsigned (Nbit-1 downto 0);
	signal vel_y, p_vel_y : unsigned (Nbit-1 downto 0);
	signal subir, p_subir : STD_LOGIC;
	
	constant MAXY: unsigned := to_unsigned(480, Nbit);
	constant gravedad: unsigned := to_unsigned(1, Nbit);

begin
	
	sinc: process(clk, reset)
	begin
		if(reset='1') then
			pos_y <= to_unsigned(0, Nbit);
			vel_y <= to_unsigned(0, Nbit);
			subir <= '0';
			estado_actual <= reposo;
		elsif(rising_edge(clk)) then
			estado_actual <= estado_proximo;
			pos_y <= p_pos_y;
			vel_y <= p_vel_y;
			subir <= p_subir;
		end if;
	end process;

	comb:process(estado_actual, botonSubir, finPantalla, pos_y, vel_y, subir, enable_gravedad)
	begin
		estado_proximo <= estado_actual;
		p_pos_y <= pos_y;
		p_vel_y <= vel_y;
		p_subir <= subir;
		
		case estado_actual is
			when reposo =>
				if (botonSubir = '1') then -- añadir muerte
					estado_proximo <= actualizarArriba;
				elsif (finPantalla = '1' AND pos_y /= MAXY) then -- definir maxy, posy señal
					estado_proximo <= actualizarY;
				end if;
			when actualizarArriba =>
				p_subir <= '1'; -- crear señal (flag)
				estado_proximo <= reposo2; -- antiguo esperarBoton cambiar nombre
			when reposo2 =>
				if (finPantalla = '1' AND pos_y /= MAXY) then -- definir maxy, posy señal
					estado_proximo <= actualizarY;
				end if;
			when actualizarY =>
				if (subir = '1' AND pos_y >= impulso) then -- no se sale de la pantalla
					p_pos_y <= pos_y - impulso;
					p_subir <= '0';
				elsif (subir = '1' AND pos_y < impulso) then
					p_pos_y <= (others => '0');
					p_subir <= '0';
				elsif (subir = '0' AND pos_y + alto + vel_y < MAXY) then --p`ñrdtlque se hunda un poco
					p_pos_y <= pos_y + vel_y;
				else
					p_pos_y <= MAXY - alto;
				end if;
				estado_proximo <= actualizarV;
			when actualizarV =>
				if (subir = '1') then
					p_vel_y <= (others => '0');
				elsif (contador > 20) then
					p_vel_y <= vel_y + gravedad;
					p_contador <= (others => '0');
				end if;
				
				if (botonSubir = '1') then
					estado_proximo <= reposo2;
				else
					estado_proximo <= reposo;
				end if;
			end case;
		end process;
		
	contador: process
	begin
		if (O3V = '1') then
			p_contador <= contador + 1;
		else
			p_contador <= contador;
		end if;
	end process;
					
	dibuja: process(eje_x, eje_y, pos_y)
	begin
		--Colores a 0 en general
		RED_int<="000";
		GREEN_int<="000";
		BLUE_int<="00";
		
		--Dibujamos el cuadrado en rojo
		if(unsigned(eje_x)>=pos_x and unsigned(eje_x)<=pos_x+32 and
			unsigned(eje_y)>=pos_y and unsigned(eje_y)<=pos_y+32) then
			RED_int<="111";
		end if;
	
	end process;

end Behavioral;

