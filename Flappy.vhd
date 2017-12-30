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
	
	component frec_pixel
		Port (clk : in STD_LOGIC;
				reset : in STD_LOGIC;
				clk_pixel : out STD_LOGIC);
	end component;
	
	component contador
		 Generic ( Nbit : integer);
		 Port ( clk : in  STD_LOGIC;
				  reset : in  STD_LOGIC;
				  enable : in  STD_LOGIC;
				  resets : in STD_LOGIC;
				  cuenta : out  STD_LOGIC_VECTOR (Nbit-1 downto 0));
	end component;

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

	component pajaro
		Generic ( Nbit : integer;
					 pos_x : integer;
				    alto : integer);
		Port ( clk : in STD_LOGIC;
				 reset : in STD_LOGIC;
				 botonSubir : in STD_LOGIC;
 			    finPantalla : in STD_LOGIC;
				 eje_x : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
				 eje_y : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
				 RED_int : out  STD_LOGIC_VECTOR (2 downto 0);
				 GREEN_int : out  STD_LOGIC_VECTOR (2 downto 0);
				 BLUE_int : out  STD_LOGIC_VECTOR (1 downto 0));
	end component;

	component gen_color
		Port ( 
			blank_h : in STD_LOGIC;
			blank_v : in STD_LOGIC;
			RED_in : in STD_LOGIC_VECTOR (2 downto 0);
			GREEN_in : in STD_LOGIC_VECTOR (2 downto 0);
			BLUE_in : in STD_LOGIC_VECTOR (1 downto 0);
			RED : out STD_LOGIC_VECTOR (2 downto 0);
			GREEN : out STD_LOGIC_VECTOR (2 downto 0);
			BLUE : out STD_LOGIC_VECTOR (1 downto 0)
		);
	end component;
	
	--Simulacion
	--constant alto: integer := 4;
	--constant ancho: integer := 9;
	--constant Nbit_ejes: integer := 5;

	--Señales de los ejes x e y
	constant alto: integer := 479;
	constant ancho: integer := 639;
	constant Nbit_ejes: integer := 10;
	signal eje_x, eje_y: STD_LOGIC_VECTOR(Nbit_ejes-1 downto 0);
	
	--Señales de los contadores y comparadores
	signal blank_h, blank_v: STD_LOGIC;
	signal end_line_h, end_line_v: STD_LOGIC;
	signal enable_cont_h, enable_cont_v: STD_LOGIC;
	
	--Señales internas de color (conexión dibuja->gen_color)
	signal RED_int, GREEN_int: STD_LOGIC_VECTOR(2 downto 0);
	signal BLUE_int: STD_LOGIC_VECTOR(1 downto 0);
	
	--Señal enable del bloque pajaro
	signal enable_g: STD_LOGIC;

begin
	fpixel: frec_pixel
		Port Map (
			clk => clk,
			reset => reset,
			clk_pixel => enable_cont_h
		);
		
	contador_g: contador_digito
		Port map(
			clk => clk,
			reset => reset,
			O3V => end_line_v,
			enable_gravedad => enable_g
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
			End_of_Screen => ancho,
			Start_of_Pulse => ancho+16,
			End_Of_Pulse => ancho+16+96,
			End_Of_Line => ancho+16+96+48
			--Start_of_Pulse => ancho+1,
			--End_Of_Pulse => ancho+1+3,
			--End_Of_Line => ancho+1+3+5
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
			End_of_Screen => alto,
			Start_of_Pulse => alto+10,
			End_Of_Pulse => alto+10+2,
			End_Of_Line => alto+10+2+29
			--Start_of_Pulse => alto+1,
			--End_Of_Pulse => alto+1+2,
			--End_Of_Line => alto+1+2+3
		)
		Port map( 
			clk => clk,
			reset => reset,
			data => eje_y,
			O1 => blank_v,
			O2 => VS,
			O3 => end_line_v
		);

	--enable_g <= end_line_v;		--O3V
	puidgy: pajaro
		Generic map(
			Nbit => Nbit_ejes,
			pos_x => 100,
			alto => 32
		)
		Port map( 
			clk => clk,
			reset => reset,
			botonSubir => botonSubir,
			finPantalla => end_line_v,
			eje_x => eje_x,
			eje_y => eje_y,
			RED_int => RED_int,
			GREEN_int => GREEN_int,
			BLUE_int => BLUE_int
		);	

	gen: gen_color
		Port map ( 
			blank_h => blank_h,
			blank_v => blank_v,
			RED_in => RED_int,
			GREEN_in => GREEN_int,
			BLUE_in => BLUE_int,
			RED => R,
			GREEN => G,
			BLUE => B
		);

end Behavioral;

