library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity ecc_scalar_mul_tb is
end ecc_scalar_mul_tb ;

architecture ecc_scalar_mul_tb of ecc_scalar_mul_tb is
    component ecc_scalar_mul
    port (
        op_i : in std_logic_vector(Mult_bytes_length downto 0);
        x_i : in FP2;
        y_i : in FP2;
        z_i : in FP2;
    
        x_o : out FP2;
        y_o : out FP2;
        z_o : out FP2
      );
    end component;
    signal op_s : std_logic_vector(Mult_bytes_length downto 0);
    signal x_s : FP2 := (X"03", X"02", X"00");
    signal y_s : FP2 := (X"07", X"05", X"00");
    signal z_s : FP2 := (X"01", X"03", X"00");

    signal x_o_s : FP2;
    signal y_o_s : FP2;
    signal z_o_s : FP2;
begin
    op_s <= X"04";
    x_s <= (X"03", X"02", X"00");
    y_s <= (X"07", X"05", X"00");
    z_s <= (X"01", X"03", X"00");

    DUT: ecc_scalar_mul
    port map(
        op_i => op_s,
        x_i => x_s,
        y_i => y_s,
        z_i => z_s,
    
        x_o => x_o_s,
        y_o => y_o_s,
        z_o => z_o_s
    );
    

end architecture ; -- ecc_scalar_mul_tb