<<<<<<< HEAD
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
	 Generic ( Nbit : integer;
				  pos_x : integer ;
				  tam_pajaro : integer);			--Alto del pajaro (64x64)
    Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  botonSubir : in STD_LOGIC;
			  finPantalla : in STD_LOGIC;		--Pulso cuando avanza una pantalla (O3V)
			  eje_x : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
			  muerte : in STD_LOGIC;
           RED : out  STD_LOGIC_VECTOR (2 downto 0);
           GREEN : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE : out  STD_LOGIC_VECTOR (1 downto 0));
end pajaro;

architecture Behavioral of pajaro is

	-- Declaración de tipos
	type estado is (
		reposo, 
		actualizarArriba, 
		reposo2, 
		actualizarY, 
		actualizarV
	);
	
	-- Señales máquina de estados
	signal estado_actual, estado_proximo : estado;
	signal pos_y, p_pos_y : unsigned (Nbit-1 downto 0);
	signal vel_y, p_vel_y : unsigned (Nbit-1 downto 0);
	signal vel_subida, p_vel_subida : unsigned (Nbit-1 downto 0);
	signal contador, p_contador : unsigned (Nbit-1 downto 0);
	
	-- Señales lectura de memoria
	signal dir_mem, p_dir_mem : STD_LOGIC_VECTOR(11 downto 0);
	signal dato_mem : STD_LOGIC_VECTOR(2 downto 0);
	signal cont_mem, p_cont_mem : STD_LOGIC;
	
	-- Constantes
	constant MAX_Y: unsigned := to_unsigned(450, Nbit);
	constant gravedad: unsigned := to_unsigned(3, Nbit);
	constant vely_inicial :unsigned := to_unsigned(1, Nbit);
	constant posy_inicial : unsigned(Nbit-1 downto 0) := (others=>'0');
	
	-- Memoria ROM con el dibujo del pájaro (4096 direcciones)
	component mempajaro
		port (
			clka : IN STD_LOGIC;
			addra : IN STD_LOGIC_VECTOR(11 downto 0);
			douta : OUT STD_LOGIC_VECTOR(2 downto 0)
		);
	end component;

begin
	
	------ Instancias de componentes
	rom : mempajaro
	port map (
		clka => clk,
		addra => dir_mem,
		douta => dato_mem
	);


	-------- PROCESO SÍNCRONO ---------------------------
	sinc: process(clk, reset)
	begin
		if(reset='1') then
			pos_y <= posy_inicial;
			vel_y <= vely_inicial;
			vel_subida <= (others=>'0');
			contador <= (others => '0');
			estado_actual <= reposo;
			dir_mem <= (others => '0');
			cont_mem <= '0';
		elsif(rising_edge(clk)) then
			estado_actual <= estado_proximo;
			pos_y <= p_pos_y;
			vel_y <= p_vel_y;
			vel_subida <= p_vel_subida;
			contador <= p_contador;
			dir_mem <= p_dir_mem;
			cont_mem <= p_cont_mem;
		end if;
	end process;


	-------- PROCESO COMBINACIONAL - MÁQUINA DE ESTADOS DEL PÁJARO ------------------
	comb: process(estado_actual, botonSubir, finPantalla, pos_y, vel_y, contador, muerte, vel_subida)
	begin
		estado_proximo <= estado_actual;
		p_pos_y <= pos_y;
		p_vel_y <= vel_y;
		p_vel_subida <= vel_subida;
		p_contador <= contador;
		
		case estado_actual is
			when reposo =>
				if (muerte = '0' AND botonSubir = '1') then -- si no hay muerte
					estado_proximo <= actualizarArriba;
				elsif (finPantalla = '1' AND pos_y /= MAX_Y) then -- si llega abajo de la pantalla ya solo se puede subir
					estado_proximo <= actualizarY;
				end if;
			
			when actualizarArriba =>
				p_vel_subida <= to_unsigned(8, Nbit); -- damos una velocidad de subida
				p_vel_y <= (others => '0'); -- eliminamos la velocidad de bajada
				estado_proximo <= reposo2;
			
			when reposo2 =>
				if (finPantalla = '1' AND pos_y /= MAX_Y) then -- esperamos a fin de pantalla
					estado_proximo <= actualizarY;
				end if;
			
			when actualizarY =>
				-- CONTADOR --
				if (contador > 5) then -- siempre que estemos aqui es porque se ha terminado una pantalla luego aumentamos el contador
					p_contador <= (others => '0');
				else
					p_contador <= contador + 1;
				end if;
				
				-- POSICION --
				if (vel_subida > 0 AND pos_y >= vel_subida) then -- no se sale de la pantalla
					p_pos_y <= pos_y - vel_subida;
				elsif (vel_subida > 0 AND pos_y < vel_subida) then -- si el impulso hiciese salir al pajaro de la pantalla lo ponemos en la posicion 0
					p_pos_y <= posy_inicial;
				elsif (vel_subida = 0 AND pos_y + tam_pajaro + vel_y < MAX_Y) then -- ANADIR QUE SE HUNDA
					p_pos_y <= pos_y + vel_y;
				else
					p_pos_y <= MAX_Y - tam_pajaro; -- el pajaro se situa abajo de la pantalla
				end if;
				
				-- ESTADO --
				estado_proximo <= actualizarV;
				
			when actualizarV =>
				-- VELOCIDAD --
				if (vel_subida > 0 AND contador = 5) then
					if (vel_subida > gravedad) then
						p_vel_subida <= vel_subida - gravedad; -- no se vuelve a subir hasta que se pulse otra vez el boton
					elsif (vel_subida <= gravedad) then
						p_vel_subida <= (others => '0');
					end if;
				elsif (contador = 5) then -- solo aumentamos la velocidad cuando contamos 20 pantallas (disminuye velocidad de caida)
					p_vel_y <= vel_y + gravedad;			
				end if;
				
				-- ESTADO --
				if (botonSubir = '1') then
					estado_proximo <= reposo2; -- estado que evita que se suba manteniendo pulsado el boton
				else
					estado_proximo <= reposo;
				end if;
				
			end case;
			
		end process;					


	-------- PROCESO COMBINACIONAL - DIBUJO DEL PÁJARO ----------------------
	dibuja: process(eje_x, eje_y, pos_y, dir_mem, dato_mem, cont_mem)
	begin
		--Colores a 0 en general
		RED<="000";
		GREEN<="000";
		BLUE<="00";
		
		p_dir_mem <= dir_mem;
		p_cont_mem <= cont_mem;
		
		--Dibujamos el cuadrado en rojo
--		if(unsigned(eje_x)>=pos_x and unsigned(eje_x)<=pos_x+32 and
--			unsigned(eje_y)>=pos_y and unsigned(eje_y)<=pos_y+32) then
--			RED<="111";
--		end if;

		if( (unsigned(eje_x)>=pos_x and unsigned(eje_x)<=pos_x+tam_pajaro) 
			and (unsigned(eje_y)>=pos_y and unsigned(eje_y)<=pos_y+tam_pajaro) ) then
			
			-- Contador de lectura de memoria (leemos cada 2 pulsos de reloj)
			p_cont_mem <= not cont_mem;
			if(cont_mem = '1') then
				p_dir_mem <= std_logic_vector(unsigned(dir_mem) + 1);
			end if;
			
			-- Conversión de color de 3 bits a 8
			if( dato_mem="011" ) then			--Cyan: mandamos color de fondo
				RED<="000";
				GREEN<="000";
				BLUE<="00";
			elsif( dato_mem = "000" ) then	--Negro: mandamos gris
				RED<="000";
				GREEN<="001";
				BLUE<="01";
			else
				if( dato_mem(0)='1' ) then		-- Azul a 1
					BLUE<="11";
				end if;
				if( dato_mem(1)='1' ) then		-- Verde a 1
					GREEN<="111";
				end if;
				if( dato_mem(2)='1' ) then		-- Rojo a 1
					RED<="111";
				end if;
			end if;
		end if;

	end process;

end Behavioral;

=======
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
	 Generic ( Nbit : integer;
				  pos_x : integer ;
				  tam_pajaro : integer);			--Alto del pajaro (64x64)
    Port ( clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  botonSubir : in STD_LOGIC;
			  finPantalla : in STD_LOGIC;		--Pulso cuando avanza una pantalla (O3V)
			  eje_x : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
           eje_y : in  STD_LOGIC_VECTOR (Nbit-1 downto 0);
			  muerte : in STD_LOGIC;
           RED : out  STD_LOGIC_VECTOR (2 downto 0);
           GREEN : out  STD_LOGIC_VECTOR (2 downto 0);
           BLUE : out  STD_LOGIC_VECTOR (1 downto 0));
end pajaro;

architecture Behavioral of pajaro is

	-- Declaración de tipos
	type estado is (
		reposo, 
		actualizarArriba, 
		reposo2, 
		actualizarY, 
		actualizarV
	);
	
	-- Señales máquina de estados
	signal estado_actual, estado_proximo : estado;
	signal pos_y, p_pos_y : unsigned (Nbit-1 downto 0);
	signal vel_y, p_vel_y : unsigned (Nbit-1 downto 0);
	signal vel_subida, p_vel_subida : unsigned (Nbit-1 downto 0);
	signal contador, p_contador : unsigned (Nbit-1 downto 0);
	
	-- Señales lectura de memoria
	signal dir_mem, p_dir_mem : STD_LOGIC_VECTOR(11 downto 0);
	signal dato_mem : STD_LOGIC_VECTOR(2 downto 0);
	signal cont_mem, p_cont_mem : STD_LOGIC;
	
	-- Constantes
	constant MAX_Y: unsigned := to_unsigned(480, Nbit);
	constant gravedad: unsigned := to_unsigned(3, Nbit);
	constant vely_inicial :unsigned := to_unsigned(1, Nbit);
	constant posy_inicial : unsigned(Nbit-1 downto 0) := (others=>'0');
	
	-- Memoria ROM con el dibujo del pájaro (4096 direcciones)
	component mempajaro
		port (
			clka : IN STD_LOGIC;
			addra : IN STD_LOGIC_VECTOR(11 downto 0);
			douta : OUT STD_LOGIC_VECTOR(2 downto 0)
		);
	end component;

begin
	
	------ Instancias de componentes
	rom : mempajaro
	port map (
		clka => clk,
		addra => dir_mem,
		douta => dato_mem
	);


	-------- PROCESO SÍNCRONO ---------------------------
	sinc: process(clk, reset)
	begin
		if(reset='1') then
			pos_y <= posy_inicial;
			vel_y <= vely_inicial;
			vel_subida <= (others=>'0');
			contador <= (others => '0');
			estado_actual <= reposo;
			dir_mem <= (others => '0');
			cont_mem <= '0';
		elsif(rising_edge(clk)) then
			estado_actual <= estado_proximo;
			pos_y <= p_pos_y;
			vel_y <= p_vel_y;
			vel_subida <= p_vel_subida;
			contador <= p_contador;
			dir_mem <= p_dir_mem;
			cont_mem <= p_cont_mem;
		end if;
	end process;


	-------- PROCESO COMBINACIONAL - MÁQUINA DE ESTADOS DEL PÁJARO ------------------
	comb: process(estado_actual, botonSubir, finPantalla, pos_y, vel_y, contador, muerte, vel_subida)
	begin
		estado_proximo <= estado_actual;
		p_pos_y <= pos_y;
		p_vel_y <= vel_y;
		p_vel_subida <= vel_subida;
		p_contador <= contador;
		
		case estado_actual is
			when reposo =>
				if (muerte = '0' AND botonSubir = '1') then -- si no hay muerte
					estado_proximo <= actualizarArriba;
				elsif (finPantalla = '1' AND pos_y /= MAX_Y) then -- si llega abajo de la pantalla ya solo se puede subir
					estado_proximo <= actualizarY;
				end if;
			
			when actualizarArriba =>
				p_vel_subida <= to_unsigned(8, Nbit); -- damos una velocidad de subida
				p_vel_y <= (others => '0'); -- eliminamos la velocidad de bajada
				estado_proximo <= reposo2;
			
			when reposo2 =>
				if (finPantalla = '1' AND pos_y /= MAX_Y) then -- esperamos a fin de pantalla
					estado_proximo <= actualizarY;
				end if;
			
			when actualizarY =>
				-- CONTADOR --
				if (contador > 5) then -- siempre que estemos aqui es porque se ha terminado una pantalla luego aumentamos el contador
					p_contador <= (others => '0');
				else
					p_contador <= contador + 1;
				end if;
				
				-- POSICION --
				if (vel_subida > 0 AND pos_y >= vel_subida) then -- no se sale de la pantalla
					p_pos_y <= pos_y - vel_subida;
				elsif (vel_subida > 0 AND pos_y < vel_subida) then -- si el impulso hiciese salir al pajaro de la pantalla lo ponemos en la posicion 0
					p_pos_y <= posy_inicial;
				elsif (vel_subida = 0 AND pos_y + tam_pajaro + vel_y < MAX_Y) then -- ANADIR QUE SE HUNDA
					p_pos_y <= pos_y + vel_y;
				else
					p_pos_y <= MAX_Y - tam_pajaro; -- el pajaro se situa abajo de la pantalla
				end if;
				
				-- ESTADO --
				estado_proximo <= actualizarV;
				
			when actualizarV =>
				-- VELOCIDAD --
				if (vel_subida > 0 AND contador = 5) then
					if (vel_subida > gravedad) then
						p_vel_subida <= vel_subida - gravedad; -- no se vuelve a subir hasta que se pulse otra vez el boton
					elsif (vel_subida <= gravedad) then
						p_vel_subida <= (others => '0');
					end if;
				elsif (contador = 5) then -- solo aumentamos la velocidad cuando contamos 20 pantallas (disminuye velocidad de caida)
					p_vel_y <= vel_y + gravedad;			
				end if;
				
				-- ESTADO --
				if (botonSubir = '1') then
					estado_proximo <= reposo2; -- estado que evita que se suba manteniendo pulsado el boton
				else
					estado_proximo <= reposo;
				end if;
				
			end case;
			
		end process;					


	-------- PROCESO COMBINACIONAL - DIBUJO DEL PÁJARO ----------------------
	dibuja: process(eje_x, eje_y, pos_y, dir_mem, dato_mem, cont_mem)
	begin
		--Colores a 0 en general
		RED<="000";
		GREEN<="000";
		BLUE<="00";
		
		p_dir_mem <= dir_mem;
		p_cont_mem <= cont_mem;
		
		--Dibujamos el cuadrado en rojo
--		if(unsigned(eje_x)>=pos_x and unsigned(eje_x)<=pos_x+32 and
--			unsigned(eje_y)>=pos_y and unsigned(eje_y)<=pos_y+32) then
--			RED<="111";
--		end if;

		if( (unsigned(eje_x)>=pos_x and unsigned(eje_x)<=pos_x+tam_pajaro) 
			and (unsigned(eje_y)>=pos_y and unsigned(eje_y)<=pos_y+tam_pajaro) ) then
			
			-- Contador de lectura de memoria (leemos cada 2 pulsos de reloj)
			p_cont_mem <= not cont_mem;
			if(cont_mem = '1') then
				p_dir_mem <= std_logic_vector(unsigned(dir_mem) + 1);
			end if;
			
			-- Conversión de color de 3 bits a 8
			if( dato_mem="011" ) then			--Cyan: mandamos color de fondo
				RED<="000";
				GREEN<="000";
				BLUE<="00";
			elsif( dato_mem = "000" ) then	--Negro: mandamos gris
				RED<="000";
				GREEN<="001";
				BLUE<="01";
			else
				if( dato_mem(0)='1' ) then		-- Azul a 1
					BLUE<="11";
				end if;
				if( dato_mem(1)='1' ) then		-- Verde a 1
					GREEN<="111";
				end if;
				if( dato_mem(2)='1' ) then		-- Rojo a 1
					RED<="111";
				end if;
			end if;
		end if;

	end process;

end Behavioral;

>>>>>>> 48053a99182101cc0a582997154526fc92c50df7
