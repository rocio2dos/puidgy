--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:09:40 11/25/2017
-- Design Name:   
-- Module Name:   C:/Xilinx/Projects/Practica2/entrega/dibuja_tb.vhd
-- Project Name:  practica2_entrega
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dibuja
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY pajaro_tb IS
END pajaro_tb;
 
ARCHITECTURE behavior OF pajaro_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pajaro
	 Generic ( 
			Nbit : integer;
			alto : integer;
			ancho : integer
	 );
    PORT(
         clk : IN  std_logic;
         eje_x : IN  std_logic_vector(7 downto 0);
         eje_y : IN  std_logic_vector(7 downto 0);
         RED : OUT  std_logic_vector(2 downto 0);
         GREEN : OUT  std_logic_vector(2 downto 0);
         BLUE : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal eje_x : std_logic_vector(7 downto 0) := (others => '0');
   signal eje_y : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal RED : std_logic_vector(2 downto 0);
   signal GREEN : std_logic_vector(2 downto 0);
   signal BLUE : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pajaro 
		GENERIC MAP (
			Nbit => 8,
			alto => 10,
			ancho => 15
		)
		PORT MAP (
          clk => clk,
          eje_x => eje_x,
          eje_y => eje_y,
          RED => RED,
          GREEN => GREEN,
          BLUE => BLUE
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
		variable x: integer range 10 downto 0 := 0;
		variable y: integer range 15 downto 0 := 0;
   begin		
      
		filas: while(x<10) loop
			columnas: while(y<15) loop
				y := y+1;
				eje_y <= std_logic_vector(to_unsigned(y, 8));
				wait for clk_period*1;
			end loop columnas;
			y := 0;
			eje_y <= std_logic_vector(to_unsigned(y, 8));

			x := x+1;
			eje_x <= std_logic_vector(to_unsigned(x, 8));
	      wait for clk_period*1;
			
		end loop filas;
		x := 0;
		eje_x <= std_logic_vector(to_unsigned(x, 8));
		wait for clk_period*1;

   end process;

END;
