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

entity columna is
	 Generic ( Nbit : integer := 10;
				  ancho_col : integer := 64;
				  pos_y_gap : integer := 200;
				  max_x : integer := 640);
	 Generic ( Nbit : integer;
				  ancho_col : integer;
				  pos_y_gap : integer;
				  tam_gap : integer;
				  MAX_X : integer);				-- Ancho de la pantalla
    Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  finPantalla : in STD_LOGIC;		--Pulso cuando avanza una pantalla (O3V)
			  finPantalla : in STD_LOGIC;		-- Pulso cuando avanza una pantalla (O3V)
			  eje_x : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
			  muerte : in STD_LOGIC;
           RED : out  STD_LOGIC_VECTOR (2 downto 0);
           GREEN : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE : out  STD_LOGIC_VECTOR (1 downto 0));
end columna;

architecture Behavioral of columna is
	
	-- Declaraci�n de tipos
	type estado is (
		reposo,
		mover_columna,
		reset_columna		
	);
	
	-- Se�ales
	signal estado_actual, estado_proximo : estado;
	signal pos_x, p_pos_x : unsigned (Nbit-1 downto 0);

	constant gap : unsigned := to_unsigned(128, Nbit);
	-- Constantes
	constant vel_x : unsigned := to_unsigned(3, Nbit);
	-- constant pos_x_inicial : unsigned := to_unsigned(max_x, Nbit) + to_unsigned(ancho_col, Nbit);
	constant pos_x_inicial : unsigned := to_unsigned(640+ancho_col, Nbit);
	
	constant pos_x_inicial : unsigned := to_unsigned(MAX_X+ancho_col, Nbit);

begin
	
	-------- PROCESO S�NCRONO ---------------------------
	sinc: process(clk, reset)
	begin
		if(reset='1') then
			estado_actual <= reposo;
			pos_x <= pos_x_inicial;
		elsif(rising_edge(clk)) then
			estado_actual <= estado_proximo;
			pos_x <= p_pos_x;
		end if;
	end process;


	-------- PROCESO COMBINACIONAL - M�QUINA DE ESTADOS DE LA COLUMNA ------------------
	comb: process(estado_actual, finPantalla, pos_x, muerte)
	begin
		estado_proximo <= estado_actual;
		p_pos_x <= pos_x;

		case estado_actual is
			when reposo => 
				if(muerte = '0' AND finPantalla='1') then
					estado_proximo <= mover_columna;
				end if;
					
			when mover_columna => 
				if(pos_x >= vel_x) then
					p_pos_x <= pos_x - vel_x;
					estado_proximo <= reposo;
				else
					p_pos_x <= (others=>'0');
					estado_proximo <= reset_columna;
				end if;				
				
			when reset_columna => 
				p_pos_x <= pos_x_inicial;
				estado_proximo <= reposo;
		end case;
	end process;


	-------- PROCESO COMBINACIONAL - DIBUJO DE LA COLUMNA ----------------------
	dibuja: process(eje_x, eje_y, pos_x)
	begin
		--Colores a 0 en general
		-- Colores a 0 en general
		RED<="000";
		GREEN<="000";
		BLUE<="00";
		
		--Dibujamos el cuadrado en rojo
		-- Dibujamos la columna en verde
		if((unsigned(eje_x)+ancho_col>=pos_x and unsigned(eje_x)<=pos_x) and 
			(unsigned(eje_y)<=pos_y_gap or unsigned(eje_y)>=pos_y_gap + gap)) then
			(unsigned(eje_y)<=pos_y_gap or unsigned(eje_y)>=pos_y_gap + tam_gap)) then
			GREEN<="111";
		end if;
	
end process;
	end process;

end Behavioral;

