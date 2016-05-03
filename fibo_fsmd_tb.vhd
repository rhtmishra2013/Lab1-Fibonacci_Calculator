
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_3 is
end tb_3;

architecture BHV of tb is

  constant TEST_WIDTH : positive := 8;
  constant TIMEOUT    : time     := TEST_WIDTH*100 ns;

  signal clk          : std_logic := '0';
  signal rst          : std_logic;
  signal go           : std_logic;
  signal input        : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal output_fsmd1 : std_logic_vector(TEST_WIDTH-1 downto 0);
  signal done_fsmd1   : std_logic;
  signal done         : std_logic := '0';

  

begin

  U_FSMD_1PROC : entity work.fibo_fsmd(fibo_fsmd_proc)
    generic map (
      width  => TEST_WIDTH)
    port map (
      clk    => clk,
      rst    => rst,
      go     => go,
      n      => input,
      result => output_fsmd1,
      done   => done_fsmd1);

 

  clk <= not clk after 10 ns when done = '0' else
         clk;

  process
  begin
    rst   <= '1';
    go    <= '0';
    input <= (others => '0');
    for i in 0 to 5 loop
      wait until clk'event and clk = '1';
    end loop;  -- i

    rst <= '0';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';



    for i in 5 to 8 loop
      input <= std_logic_vector(to_unsigned(i, TEST_WIDTH));
      go    <= '1';
      wait until clk'event and clk = '1';
      go    <= '0';
      wait for TIMEOUT;
    end loop;  

    report "SIMULATION COMPLETE!!!!";
    done <= '1';
    wait;

  end process;

  process
    begin
    wait until go = '1';
    wait until done_fsmd1 = '1' for TIMEOUT;
    assert(done_fsmd1 = '1') report "FSMD_1P never asserts done.";
   
  end process;



end BHV;
