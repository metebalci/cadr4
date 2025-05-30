library ieee;
use ieee.std_logic_1164.all;

library ttl;
use ttl.other.all;

entity sip330_470_8_tb is
end;

architecture testbench of sip330_470_8_tb is

  signal r7 : std_logic;
  signal r6 : std_logic;
  signal r5 : std_logic;
  signal r4 : std_logic;
  signal r3 : std_logic;
  signal r2 : std_logic;

begin

  uut : sip330_470_8 port map(
    r2 => r2,
    r3 => r3,
    r4 => r4,
    r5 => r5,
    r6 => r6,
    r7 => r7
    );

  process
  begin
    wait for 1 ns;
    
    -- Test all outputs are '1'
    assert r2 = '1' report "r2 should be '1'";
    assert r3 = '1' report "r3 should be '1'";
    assert r4 = '1' report "r4 should be '1'";
    assert r5 = '1' report "r5 should be '1'";
    assert r6 = '1' report "r6 should be '1'";
    assert r7 = '1' report "r7 should be '1'";

    wait;
  end process;

end;
