-- Dual 2-Line To 4-Line Decoders/Demultiplexers

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sn74139 is
  port (
    g1                     : in  std_logic;
    a1, b1                 : in  std_logic;
    g1y0, g1y1, g1y2, g1y3 : out std_logic;

    g2                     : in  std_logic;
    a2, b2                 : in  std_logic;
    g2y3, g2y2, g2y1, g2y0 : out std_logic
    );
end;

-- OpenAI Codex implementation
architecture ttl of sn74139 is
  signal y1 : unsigned(3 downto 0);
  signal y2 : unsigned(3 downto 0);
begin

  process (g1, a1, b1) is
    variable sel : unsigned(1 downto 0);
  begin
    sel := a1 & b1;

    if g1 = '0' then
      case sel is
        when "00"   => y1 <= "0111";
        when "01"   => y1 <= "1011";
        when "10"   => y1 <= "1101";
        when "11"   => y1 <= "1110";
        when others => y1 <= "1111";
      end case;
    else
      y1 <= "1111";
    end if;
  end process;

  process (g2, a2, b2) is
    variable sel : unsigned(1 downto 0);
  begin
    sel := a2 & b2;

    if g2 = '0' then
      case sel is
        when "00"   => y2 <= "0111";
        when "01"   => y2 <= "1011";
        when "10"   => y2 <= "1101";
        when "11"   => y2 <= "1110";
        when others => y2 <= "1111";
      end case;
    else
      y2 <= "1111";
    end if;
  end process;

  -- drive output pins from internal vectors
  g1y0 <= y1(3); g1y1 <= y1(2); g1y2 <= y1(1); g1y3 <= y1(0);
  g2y3 <= y2(0); g2y2 <= y2(1); g2y1 <= y2(2); g2y0 <= y2(3);

end architecture;
