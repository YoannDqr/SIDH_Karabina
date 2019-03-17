--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library ieee;
use ieee.std_logic_1164.all;

package const is

    --  F_p^m parameters --
    -- Infinite point : [ (others => '1'), (others => '0'), (others => '1')]
    constant m : positive := 2;
    constant p : positive := 11;
    constant a : positive := 5; -- parameter of elliptical curve's equation
    constant Fp_bytes_length : positive := 7;
    constant Mult_bytes_length : positive := 7;


    -- Number of F_p^m are taken as array of polynomial coefficient in F_p
    -- FpCoef represent a number in Fp
    subtype FpCoef is std_logic_vector(Fp_bytes_length downto 0);
    type Fp2 is array(0 to m) of FpCoef;
    type Fp2Mult is array(0 to m) of std_logic_vector(2*Fp_bytes_length + 1 downto 0);
    type Coordonate is array(0 to 2) of FP2;
    type ECCMult is array(0 to Mult_bytes_length+1) of Coordonate;


    -- Constant rcon
    constant F : Fp2 := (X"01", X"00", X"01"); -- X² + 1
    constant upFP2 : FP2 := ( (others => '1'), (others => '1'), (others => '0'));
    constant nullFP2 : FP2 := ( (others => '0'), (others => '0'), (others => '0'));
    constant infPoint : Coordonate := (upFP2, nullFP2, upFP2);


end const;


package body const is

end const;
