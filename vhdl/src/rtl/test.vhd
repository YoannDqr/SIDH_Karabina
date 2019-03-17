library ieee;
library lib_rtl;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use lib_rtl.const.all;
use ieee.numeric_std.all;

entity test is 
end entity test;

architecture test_arch of test is
    signal a : std_logic_vector(7 downto 0);
    signal c : std_logic_vector(7 downto 0);
begin
    c <= X"01";
    a <= std_logic_vector(to_unsigned((-1 * to_integer(unsigned(c))) mod 3, a'length));

end architecture test_arch;

    