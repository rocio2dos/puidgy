<<<<<<< HEAD
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:22:58 11/15/2017 
-- Design Name: 
-- Module Name:    VGA_Driver - Behavioral 
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

entity Flappy is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  botonSubir : in STD_LOGIC;
           VS : out  STD_LOGIC;
           HS : out  STD_LOGIC;
           R : out  STD_LOGIC_VECTOR (2 downto 0);
           G : out  STD_LOGIC_VECTOR (2 downto 0);
           B : out  STD_LOGIC_VECTOR (1 downto 0));
end Flappy;

architecture Behavioral of Flappy is
	
	------------------------ COMPONENTES ---------------------------
	----- Divisor de frecuencia
	component frec_pixel
		Port (clk : in STD_LOGIC;
				reset : in STD_LOGIC;
				clk_pixel : out STD_LOGIC);
	end component;

	----- Contador
	component contador
		 Generic ( Nbit : integer);
		 Port ( clk : in  STD_LOGIC;
				  reset : in  STD_LOGIC;
				  enable : in  STD_LOGIC;
				  resets : in STD_LOGIC;
				  cuenta : out  STD_LOGIC_VECTOR (Nbit-1 downto 0));
	end component;

	----- Comparador
	component comparador
		 Generic ( Nbit : integer;
					  End_of_Screen : integer;
					  Start_of_Pulse : integer;
					  End_Of_Pulse : integer;
					  End_Of_Line : integer);
		 Port ( clk : in  STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
				  O1 : out  STD_LOGIC;
				  O2 : out  STD_LOGIC;
				  O3 : out  STD_LOGIC);
	end component;

	----- Pajaro
	component pajaro
		Generic ( Nbit : integer;
					 pos_x : integer;
				    tam_pajaro : integer);
		Port ( clk : in STD_LOGIC;
				 reset : in STD_LOGIC;
				 botonSubir : in STD_LOGIC;
 			    finPantalla : in STD_LOGIC;
				 muerte : in STD_LOGIC;
				 eje_x : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
				 eje_y : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
				 RED : out  STD_LOGIC_VECTOR (2 downto 0);
				 GREEN : out  STD_LOGIC_VECTOR (2 downto 0);
				 BLUE : out  STD_LOGIC_VECTOR (1 downto 0));
	end component;

	----- Columna
	component columna is
		 Generic ( Nbit : integer;
				  ancho_col : integer;
				  pos_y_gap : integer;
				  tam_gap : integer;
				  primera_posicion : integer;
				  MAX_X : integer);				-- Ancho de la pantalla
		 Port ( clk : in STD_LOGIC;
				  reset : in STD_LOGIC;
				  finPantalla : in STD_LOGIC;		-- Pulso cuando avanza una pantalla (O3V)
				  eje_x : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
				  eje_y : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
				  salida_permitida: in STD_LOGIC;
				  permitir_salida: out STD_LOGIC;
				  muerte : in STD_LOGIC;
				  RED : out  STD_LOGIC_VECTOR (2 downto 0);
				  GREEN : out  STD_LOGIC_VECTOR (2 downto 0);
				  BLUE : out  STD_LOGIC_VECTOR (1 downto 0));
	end component;

	----- Gestor del juego
	component gestor
    Generic ( Nbit : integer );
    Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  R_pajaro : in  STD_LOGIC_VECTOR (2 downto 0);
           G_pajaro : in  STD_LOGIC_VECTOR (2 downto 0);
           B_pajaro : in  STD_LOGIC_VECTOR (1 downto 0);
           R_columna1 : in  STD_LOGIC_VECTOR (2 downto 0);
           G_columna1 : in  STD_LOGIC_VECTOR (2 downto 0);
           B_columna1 : in  STD_LOGIC_VECTOR (1 downto 0);
			  R_columna2 : in  STD_LOGIC_VECTOR (2 downto 0);
           G_columna2 : in  STD_LOGIC_VECTOR (2 downto 0);
           B_columna2 : in  STD_LOGIC_VECTOR (1 downto 0);
			  R_columna3 : in  STD_LOGIC_VECTOR (2 downto 0);
           G_columna3 : in  STD_LOGIC_VECTOR (2 downto 0);
           B_columna3 : in  STD_LOGIC_VECTOR (1 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
           R_final : out  STD_LOGIC_VECTOR (2 downto 0);
           G_final : out  STD_LOGIC_VECTOR (2 downto 0);
           B_final : out  STD_LOGIC_VECTOR (1 downto 0);
			  muerte : out STD_LOGIC
		);
	end component;

	----- Generador de color
	component gen_color
		Port ( 
			blank_h : in STD_LOGIC;
			blank_v : in STD_LOGIC;
			RED_int : in STD_LOGIC_VECTOR (2 downto 0);
			GREEN_int : in STD_LOGIC_VECTOR (2 downto 0);
			BLUE_int : in STD_LOGIC_VECTOR (1 downto 0);
			RED : out STD_LOGIC_VECTOR (2 downto 0);
			GREEN : out STD_LOGIC_VECTOR (2 downto 0);
			BLUE : out STD_LOGIC_VECTOR (1 downto 0)
		);
	end component;

	
	------------------------ SEÑALES ---------------------------
	--Simulacion
	--constant alto_pantalla: integer := 4;
	--constant ancho_pantalla: integer := 9;
	--constant Nbit_ejes: integer := 5;

	--Señales de los ejes x e y
	constant alto_pantalla: integer := 479;
	constant ancho_pantalla: integer := 639;
	constant Nbit_ejes: integer := 11;
	signal eje_x, eje_y: STD_LOGIC_VECTOR(Nbit_ejes-1 downto 0);
	
	--Señales de los contadores y comparadores
	signal blank_h, blank_v: STD_LOGIC;
	signal end_line_h, end_line_v: STD_LOGIC;
	signal enable_cont_h, enable_cont_v: STD_LOGIC;
	
	--Señales internas de color (conexión gestor->gen_color)
	signal RED_int, GREEN_int: STD_LOGIC_VECTOR(2 downto 0);
	signal BLUE_int: STD_LOGIC_VECTOR(1 downto 0);
	
	signal RED_pajaro, GREEN_pajaro: STD_LOGIC_VECTOR(2 downto 0);
	signal BLUE_pajaro: STD_LOGIC_VECTOR(1 downto 0);
	
	signal RED_columna1, GREEN_columna1: STD_LOGIC_VECTOR(2 downto 0);
	signal BLUE_columna1: STD_LOGIC_VECTOR(1 downto 0);
	
	signal RED_columna2, GREEN_columna2: STD_LOGIC_VECTOR(2 downto 0);
	signal BLUE_columna2: STD_LOGIC_VECTOR(1 downto 0);
	
	signal RED_columna3, GREEN_columna3: STD_LOGIC_VECTOR(2 downto 0);
	signal BLUE_columna3: STD_LOGIC_VECTOR(1 downto 0);
	
	--Señales de control del juego
	signal muerte : STD_LOGIC;
	signal salida_permitida_12 : STD_LOGIC;
	signal salida_permitida_23 : STD_LOGIC;
	signal salida_permitida_31 : STD_LOGIC;

begin

	------------------ INSTANCIAS DE COMPONENTES ---------------------
	fpixel: frec_pixel
		Port Map (
			clk => clk,
			reset => reset,
			clk_pixel => enable_cont_h
		);
		
	cont_h: contador
		Generic map( 
			Nbit => Nbit_ejes
		)
		Port map( 
			clk => clk,
			reset => reset,
			enable => enable_cont_h,
			resets => end_line_h,
			cuenta => eje_x
		);

	enable_cont_v <= enable_cont_h and end_line_h;
	cont_v: contador
		Generic map( 
			Nbit => Nbit_ejes
		)
		Port map( 
			clk => clk,
			reset => reset,
			enable => enable_cont_v,
			resets => end_line_v,
			cuenta => eje_y
		);

	comp_h: comparador
		Generic map( 
			Nbit => Nbit_ejes,
			End_of_Screen => ancho_pantalla,
			Start_of_Pulse => ancho_pantalla+16,
			End_Of_Pulse => ancho_pantalla+16+96,
			End_Of_Line => ancho_pantalla+16+96+48
			--Start_of_Pulse => ancho_pantalla+1,
			--End_Of_Pulse => ancho_pantalla+1+3,
			--End_Of_Line => ancho_pantalla+1+3+5
		)
		Port map( 
			clk => clk,
			reset => reset,
			data => eje_x,
			O1 => blank_h,
			O2 => HS,
			O3 => end_line_h
		);
		
	comp_v: comparador
		Generic map( 
			Nbit => Nbit_ejes,
			End_of_Screen => alto_pantalla,
			Start_of_Pulse => alto_pantalla+10,
			End_Of_Pulse => alto_pantalla+10+2,
			End_Of_Line => alto_pantalla+10+2+29
			--Start_of_Pulse => alto_pantalla+1,
			--End_Of_Pulse => alto_pantalla+1+2,
			--End_Of_Line => alto_pantalla+1+2+3
		)
		Port map( 
			clk => clk,
			reset => reset,
			data => eje_y,
			O1 => blank_v,
			O2 => VS,
			O3 => end_line_v
		);

	bird: pajaro
		Generic map(
			Nbit => Nbit_ejes,
			pos_x => 100,
			tam_pajaro => 63
		)
		Port map( 
			clk => clk,
			reset => reset,
			botonSubir => botonSubir,
			finPantalla => end_line_v,
			muerte => muerte,
			eje_x => eje_x,
			eje_y => eje_y,
			RED => RED_pajaro,
			GREEN => GREEN_pajaro,
			BLUE => BLUE_pajaro
		);
		
	columna1: columna
		 Generic map ( 
			Nbit => Nbit_ejes,
			ancho_col => 64,
			pos_y_gap => 250,
			tam_gap => 200,
			primera_posicion => 704,
			MAX_X => ancho_pantalla
		 )
		 Port map( 
			clk => clk,
			reset => reset,
			finPantalla => end_line_v,
			muerte => muerte,
			salida_permitida => salida_permitida_31,
			permitir_salida => salida_permitida_12,
			eje_x => eje_x,
			eje_y => eje_y,
			RED => RED_columna1,
			GREEN => GREEN_columna1,
			BLUE => BLUE_columna1
		);
		
	columna2: columna
		 Generic map ( 
			Nbit => Nbit_ejes,
			ancho_col => 64,
			pos_y_gap => 200,
			tam_gap => 200,
			primera_posicion => 992,
			MAX_X => ancho_pantalla
		 )
		 Port map( 
			clk => clk,
			reset => reset,
			finPantalla => end_line_v,
			muerte => muerte,
			salida_permitida => salida_permitida_12,
			permitir_salida => salida_permitida_23,
			eje_x => eje_x,
			eje_y => eje_y,
			RED => RED_columna2,
			GREEN => GREEN_columna2,
			BLUE => BLUE_columna2
		);
		
	columna3: columna
		 Generic map ( 
			Nbit => Nbit_ejes,
			ancho_col => 64,
			pos_y_gap => 150,
			tam_gap => 200,
			primera_posicion => 1280,
			MAX_X => ancho_pantalla
		 )
		 Port map( 
			clk => clk,
			reset => reset,
			finPantalla => end_line_v,
			muerte => muerte,
			salida_permitida => salida_permitida_23,
			permitir_salida => salida_permitida_31,
			eje_x => eje_x,
			eje_y => eje_y,
			RED => RED_columna3,
			GREEN => GREEN_columna3,
			BLUE => BLUE_columna3
		);
		
	manager: gestor
		Generic map ( 
			Nbit => Nbit_ejes
		)
		Port map (
			clk => clk,
			reset => reset,
			R_pajaro => RED_pajaro,
         G_pajaro => GREEN_pajaro,
			B_pajaro => BLUE_pajaro,
			R_columna1 => RED_columna1,
			G_columna1 => GREEN_columna1,
			B_columna1 => BLUE_columna1,
			R_columna2 => RED_columna2,
			G_columna2 => GREEN_columna2,
			B_columna2 => BLUE_columna2,
			R_columna3 => RED_columna3,
			G_columna3 => GREEN_columna3,
			B_columna3 => BLUE_columna3,
			eje_y => eje_y,
			R_final => RED_int,
			G_final => GREEN_int,
			B_final => BLUE_int,
			muerte => muerte
		);
		
	gen: gen_color
		Port map (		
			blank_h => blank_h,
			blank_v => blank_v,
			RED_int => RED_int,
			GREEN_int => GREEN_int,
			BLUE_int => BLUE_int,
			RED => R,
			GREEN => G,
			BLUE => B
		);

end Behavioral;

=======
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:22:58 11/15/2017 
-- Design Name: 
-- Module Name:    VGA_Driver - Behavioral 
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

entity Flappy is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  botonSubir : in STD_LOGIC;
           VS : out  STD_LOGIC;
           HS : out  STD_LOGIC;
           R : out  STD_LOGIC_VECTOR (2 downto 0);
           G : out  STD_LOGIC_VECTOR (2 downto 0);
           B : out  STD_LOGIC_VECTOR (1 downto 0));
end Flappy;

architecture Behavioral of Flappy is
	
	------------------------ COMPONENTES ---------------------------
	----- Divisor de frecuencia
	component frec_pixel
		Port (clk : in STD_LOGIC;
				reset : in STD_LOGIC;
				clk_pixel : out STD_LOGIC);
	end component;

	----- Contador
	component contador
		 Generic ( Nbit : integer);
		 Port ( clk : in  STD_LOGIC;
				  reset : in  STD_LOGIC;
				  enable : in  STD_LOGIC;
				  resets : in STD_LOGIC;
				  cuenta : out  STD_LOGIC_VECTOR (Nbit-1 downto 0));
	end component;

	----- Comparador
	component comparador
		 Generic ( Nbit : integer;
					  End_of_Screen : integer;
					  Start_of_Pulse : integer;
					  End_Of_Pulse : integer;
					  End_Of_Line : integer);
		 Port ( clk : in  STD_LOGIC;
				  reset : in  STD_LOGIC;
				  data : in  STD_LOGIC_VECTOR(Nbit-1 downto 0);
				  O1 : out  STD_LOGIC;
				  O2 : out  STD_LOGIC;
				  O3 : out  STD_LOGIC);
	end component;

	----- Pajaro
	component pajaro
		Generic ( Nbit : integer;
					 pos_x : integer;
				    tam_pajaro : integer);
		Port ( clk : in STD_LOGIC;
				 reset : in STD_LOGIC;
				 botonSubir : in STD_LOGIC;
 			    finPantalla : in STD_LOGIC;
				 muerte : in STD_LOGIC;
				 eje_x : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
				 eje_y : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
				 RED : out  STD_LOGIC_VECTOR (2 downto 0);
				 GREEN : out  STD_LOGIC_VECTOR (2 downto 0);
				 BLUE : out  STD_LOGIC_VECTOR (1 downto 0));
	end component;

	----- Columna
	component columna is
		 Generic ( Nbit : integer;
					  ancho_col : integer;
					  pos_y_gap : integer;
					  tam_gap : integer;
					  MAX_X : integer);
		 Port ( clk : in STD_LOGIC;
				  reset : in STD_LOGIC;
				  finPantalla : in STD_LOGIC;		--Pulso cuando avanza una pantalla (O3V)
				  muerte : in STD_LOGIC;
				  eje_x : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
				  eje_y : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
				  RED : out  STD_LOGIC_VECTOR (2 downto 0);
				  GREEN : out  STD_LOGIC_VECTOR (2 downto 0);
				  BLUE : out  STD_LOGIC_VECTOR (1 downto 0));
	end component;

	----- Gestor del juego
	component gestor
    Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  R_pajaro : in  STD_LOGIC_VECTOR (2 downto 0);
           G_pajaro : in  STD_LOGIC_VECTOR (2 downto 0);
           B_pajaro : in  STD_LOGIC_VECTOR (1 downto 0);
           R_columna : in  STD_LOGIC_VECTOR (2 downto 0);
           G_columna : in  STD_LOGIC_VECTOR (2 downto 0);
           B_columna : in  STD_LOGIC_VECTOR (1 downto 0);
           R_final : out  STD_LOGIC_VECTOR (2 downto 0);
           G_final : out  STD_LOGIC_VECTOR (2 downto 0);
           B_final : out  STD_LOGIC_VECTOR (1 downto 0);
			  muerte : out STD_LOGIC
		);
	end component;

	----- Generador de color
	component gen_color
		Port ( 
			blank_h : in STD_LOGIC;
			blank_v : in STD_LOGIC;
			RED_int : in STD_LOGIC_VECTOR (2 downto 0);
			GREEN_int : in STD_LOGIC_VECTOR (2 downto 0);
			BLUE_int : in STD_LOGIC_VECTOR (1 downto 0);
			RED : out STD_LOGIC_VECTOR (2 downto 0);
			GREEN : out STD_LOGIC_VECTOR (2 downto 0);
			BLUE : out STD_LOGIC_VECTOR (1 downto 0)
		);
	end component;

	
	------------------------ SEÑALES ---------------------------
	--Simulacion
	--constant alto_pantalla: integer := 4;
	--constant ancho_pantalla: integer := 9;
	--constant Nbit_ejes: integer := 5;

	--Señales de los ejes x e y
	constant alto_pantalla: integer := 479;
	constant ancho_pantalla: integer := 639;
	constant Nbit_ejes: integer := 10;
	signal eje_x, eje_y: STD_LOGIC_VECTOR(Nbit_ejes-1 downto 0);
	
	--Señales de los contadores y comparadores
	signal blank_h, blank_v: STD_LOGIC;
	signal end_line_h, end_line_v: STD_LOGIC;
	signal enable_cont_h, enable_cont_v: STD_LOGIC;
	
	--Señales internas de color (conexión gestor->gen_color)
	signal RED_int, GREEN_int: STD_LOGIC_VECTOR(2 downto 0);
	signal BLUE_int: STD_LOGIC_VECTOR(1 downto 0);
	
	signal RED_pajaro, GREEN_pajaro: STD_LOGIC_VECTOR(2 downto 0);
	signal BLUE_pajaro: STD_LOGIC_VECTOR(1 downto 0);
	
	signal RED_columna, GREEN_columna: STD_LOGIC_VECTOR(2 downto 0);
	signal BLUE_columna: STD_LOGIC_VECTOR(1 downto 0);
	
	--Señales de control del juego
	signal muerte : STD_LOGIC;

begin

	------------------ INSTANCIAS DE COMPONENTES ---------------------
	fpixel: frec_pixel
		Port Map (
			clk => clk,
			reset => reset,
			clk_pixel => enable_cont_h
		);
		
	cont_h: contador
		Generic map( 
			Nbit => Nbit_ejes
		)
		Port map( 
			clk => clk,
			reset => reset,
			enable => enable_cont_h,
			resets => end_line_h,
			cuenta => eje_x
		);

	enable_cont_v <= enable_cont_h and end_line_h;
	cont_v: contador
		Generic map( 
			Nbit => Nbit_ejes
		)
		Port map( 
			clk => clk,
			reset => reset,
			enable => enable_cont_v,
			resets => end_line_v,
			cuenta => eje_y
		);

	comp_h: comparador
		Generic map( 
			Nbit => Nbit_ejes,
			End_of_Screen => ancho_pantalla,
			Start_of_Pulse => ancho_pantalla+16,
			End_Of_Pulse => ancho_pantalla+16+96,
			End_Of_Line => ancho_pantalla+16+96+48
			--Start_of_Pulse => ancho_pantalla+1,
			--End_Of_Pulse => ancho_pantalla+1+3,
			--End_Of_Line => ancho_pantalla+1+3+5
		)
		Port map( 
			clk => clk,
			reset => reset,
			data => eje_x,
			O1 => blank_h,
			O2 => HS,
			O3 => end_line_h
		);
		
	comp_v: comparador
		Generic map( 
			Nbit => Nbit_ejes,
			End_of_Screen => alto_pantalla,
			Start_of_Pulse => alto_pantalla+10,
			End_Of_Pulse => alto_pantalla+10+2,
			End_Of_Line => alto_pantalla+10+2+29
			--Start_of_Pulse => alto_pantalla+1,
			--End_Of_Pulse => alto_pantalla+1+2,
			--End_Of_Line => alto_pantalla+1+2+3
		)
		Port map( 
			clk => clk,
			reset => reset,
			data => eje_y,
			O1 => blank_v,
			O2 => VS,
			O3 => end_line_v
		);

	bird: pajaro
		Generic map(
			Nbit => Nbit_ejes,
			pos_x => 100,
			tam_pajaro => 63
		)
		Port map( 
			clk => clk,
			reset => reset,
			botonSubir => botonSubir,
			finPantalla => end_line_v,
			muerte => muerte,
			eje_x => eje_x,
			eje_y => eje_y,
			RED => RED_pajaro,
			GREEN => GREEN_pajaro,
			BLUE => BLUE_pajaro
		);
		
	col: columna
		 Generic map ( 
			Nbit => Nbit_ejes,
			ancho_col => 64,
			pos_y_gap => 128,
			tam_gap => 170,
			MAX_X => ancho_pantalla
		 )
		 Port map( 
			clk => clk,
			reset => reset,
			finPantalla => end_line_v,
			muerte => muerte,
			eje_x => eje_x,
			eje_y => eje_y,
			RED => RED_columna,
			GREEN => GREEN_columna,
			BLUE => BLUE_columna
		);
		
	manager: gestor
		Port map (
			clk => clk,
			reset => reset,
			R_pajaro => RED_pajaro,
         G_pajaro => GREEN_pajaro,
			B_pajaro => BLUE_pajaro,
			R_columna => RED_columna,
			G_columna => GREEN_columna,
			B_columna => BLUE_columna,
			R_final => RED_int,
			G_final => GREEN_int,
			B_final => BLUE_int,
			muerte => muerte
		);
		
	gen: gen_color
		Port map (		
			blank_h => blank_h,
			blank_v => blank_v,
			RED_int => RED_int,
			GREEN_int => GREEN_int,
			BLUE_int => BLUE_int,
			RED => R,
			GREEN => G,
			BLUE => B
		);

end Behavioral;

>>>>>>> 48053a99182101cc0a582997154526fc92c50df7
