<<<<<<< HEAD
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:14:38 01/12/2018 
-- Design Name: 
-- Module Name:    gestor - Behavioral 
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

entity gestor is
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
			  muerte : out STD_LOGIC);
end gestor;

architecture Behavioral of gestor is

signal muerte_aux, p_muerte_aux : STD_LOGIC;

begin

	muerte <= muerte_aux;

	sinc: process(clk, reset)
	begin
		if(reset='1') then
			muerte_aux <= '0';
		elsif(rising_edge(clk)) then
			muerte_aux <= p_muerte_aux;
		end if;
	end process;

	comb:process(R_pajaro, G_pajaro, B_pajaro, R_columna1, G_columna1, B_columna1,
		R_columna2, G_columna2, B_columna2, R_columna3, G_columna3, B_columna3, reset, muerte_aux, eje_y)
	begin
		
		p_muerte_aux <= muerte_aux;
		
		if (unsigned(eje_y) < 440) then
			R_final <= "000";
			G_final <= "111";
			B_final <= "11";
		else
			if ((unsigned(R_pajaro) > 0) OR (unsigned(G_pajaro) > 0) OR (unsigned(B_pajaro) > 0)) then
				p_muerte_aux <= '1';
			end if;
			R_final <= "100";
			G_final <= "010";
			B_final <= "00";
		end if;

		if (((unsigned(R_pajaro) > 0) OR (unsigned(G_pajaro) > 0) OR (unsigned(B_pajaro) > 0)) AND -- si el pajaro y la columna se pintan a la vez
			(((unsigned(R_columna1) > 0) OR (unsigned(G_columna1) > 0) OR (unsigned(B_columna1) > 0)) OR 
			((unsigned(R_columna2) > 0) OR (unsigned(G_columna2) > 0) OR (unsigned(B_columna2) > 0)) OR
			((unsigned(R_columna3) > 0) OR (unsigned(G_columna3) > 0) OR (unsigned(B_columna3) > 0)))) then
			p_muerte_aux <= '1';
			R_final <= R_pajaro;
			G_final <= G_pajaro;
			B_final <= B_pajaro;			
		elsif((unsigned(R_pajaro) > 0) OR (unsigned(G_pajaro) > 0) OR (unsigned(B_pajaro) > 0)) then -- el pajaro tiene prioridad
			R_final <= R_pajaro;
			G_final <= G_pajaro;
			B_final <= B_pajaro;
		elsif ((unsigned(R_columna1) > 0) OR (unsigned(G_columna1) > 0) OR (unsigned(B_columna1) > 0)) then
			R_final <= R_columna1;
			G_final <= G_columna1;
			B_final <= B_columna1;
		elsif ((unsigned(R_columna2) > 0) OR (unsigned(G_columna2) > 0) OR (unsigned(B_columna2) > 0)) then
			R_final <= R_columna2;
			G_final <= G_columna2;
			B_final <= B_columna2;
		elsif ((unsigned(R_columna3) > 0) OR (unsigned(G_columna3) > 0) OR (unsigned(B_columna3) > 0)) then
			R_final <= R_columna3;
			G_final <= G_columna3;
			B_final <= B_columna3;
		end if;

	end process;


end Behavioral;

=======
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:14:38 01/12/2018 
-- Design Name: 
-- Module Name:    gestor - Behavioral 
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

entity gestor is
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
			  muerte : out STD_LOGIC);
end gestor;

architecture Behavioral of gestor is

signal muerte_aux, p_muerte_aux : STD_LOGIC;

begin

	muerte <= muerte_aux;

	sinc: process(clk, reset)
	begin
		if(reset='1') then
			muerte_aux <= '0';
		elsif(rising_edge(clk)) then
			muerte_aux <= p_muerte_aux;
		end if;
	end process;

	comb:process(R_pajaro, G_pajaro, B_pajaro, R_columna, G_columna, B_columna, reset, muerte_aux)
	begin
		R_final <= "000";
		G_final <= "000";
		B_final <= "00";
		p_muerte_aux <= muerte_aux;

		if (((unsigned(R_pajaro) > 0) OR (unsigned(G_pajaro) > 0) OR (unsigned(B_pajaro) > 0)) AND
			((unsigned(R_columna) > 0) OR (unsigned(G_columna) > 0) OR (unsigned(B_columna) > 0))) then
			p_muerte_aux <= '1';			
		elsif((unsigned(R_pajaro) > 0) OR (unsigned(G_pajaro) > 0) OR (unsigned(B_pajaro) > 0)) then
			R_final <= R_pajaro;
			G_final <= G_pajaro;
			B_final <= B_pajaro;
		elsif ((unsigned(R_columna) > 0) OR (unsigned(G_columna) > 0) OR (unsigned(B_columna) > 0)) then
			R_final <= R_columna;
			G_final <= G_columna;
			B_final <= B_columna;
		end if;

	end process;


end Behavioral;

>>>>>>> 48053a99182101cc0a582997154526fc92c50df7
