--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:21:03 11/26/2017
-- Design Name:   
-- Module Name:   C:/Xilinx/Projects/Practica2/entrega/VGA_Driver_tb.vhd
-- Project Name:  practica2_entrega
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: VGA_Driver
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
 
ENTITY Flappy_tb IS
END Flappy_tb;
 
ARCHITECTURE behavior OF Flappy_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Flappy
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         VS : OUT  std_logic;
         HS : OUT  std_logic;
         R : OUT  std_logic_vector(2 downto 0);
         G : OUT  std_logic_vector(2 downto 0);
         B : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal VS : std_logic;
   signal HS : std_logic;
   signal R : std_logic_vector(2 downto 0);
   signal G : std_logic_vector(2 downto 0);
   signal B : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Flappy PORT MAP (
          clk => clk,
          reset => reset,
          VS => VS,
          HS => HS,
          R => R,
          G => G,
          B => B
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
   begin		
      reset <= '1';
      wait for 100 ns;	

		reset <= '0';
      wait;
   end process;

END;
