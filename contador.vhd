----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:42:01 11/07/2017 
-- Design Name: 
-- Module Name:    cont_digito - Behavioral 
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

entity contador is
	 Generic ( Nbit : integer := 8);
	 Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;
			  resets : in STD_LOGIC;
           cuenta : out  STD_LOGIC_VECTOR (Nbit-1 downto 0));
end contador;

architecture Behavioral of contador is
	signal cta, p_cta: unsigned(Nbit-1 downto 0);
begin

	-- Sentencias concurrentes:
	cuenta <= std_logic_vector(cta);

	-- Proceso síncrono: biestable con reset asíncrono
	sinc: process(clk, reset) 
	begin
		if(reset='1') then
			cta <= (others => '0');
		elsif(rising_edge(clk)) then
			cta <= p_cta;
		end if;
	end process;

	-- Proceso combinacional: contador con reset síncrono
	comb: process(cta, resets, enable) 
	begin
		if(resets='1') then
			p_cta <= (others => '0');
		elsif(enable='1') then
			p_cta <= cta + 1;
		else
			p_cta <= cta;
		end if;
	end process;

end Behavioral;

