--ROHIT MISHRA
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fibo_fsmd is
  generic (
    width  :     positive := 8);
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    go     : in  std_logic;
    n      : in  std_logic_vector(width-1 downto 0);
    result : out std_logic_vector(width-1 downto 0);
    done   : out std_logic);
end fibo_fsmd;


architecture fibo_fsmd_proc of fibo_fsmd is

  type STATE_TYPE is (S_INIT, S_CHECK_COND, S_DONE);
  signal state   : STATE_TYPE;

  signal value   : std_logic_vector(width-1 downto 0);
  	signal i     : unsigned(width-1 downto 0);
	signal x     : unsigned(width-1 downto 0);
	signal y     : unsigned(width-1 downto 0);
-- i is the number of times the loop will run based on its comparison with the number as input.  
  
begin
  process(clk, rst)
    variable temp  : unsigned(width-1 downto 0);
-- Defined a temporary variable for storing the value of Y in the previous state.
	
  begin
    if (rst = '1') then
      
      result <= (others => '0');
      done   <= '0';
      value  <= (others => '0');
      state  <= S_INIT;
	  
    elsif (clk'event and clk = '1') then

  

      case state is
       
        when S_INIT =>

        
          done  <= '0';
          value <= n;
		  x <=to_unsigned(1,width);
		  i <=to_unsigned(3,width);
		  y <=to_unsigned(1,width);

        
          if (go = '1') then
            state <= S_CHECK_COND;
          end if;

        when S_CHECK_COND=>

           if (i <= unsigned(value)) then
               temp :=x+y;
			   x<=y;
			   y<=temp;
			   i<=i + 1;
			   
          else
            state<= S_DONE;
          end if;

       

        when S_DONE =>
       
          result <= std_logic_vector(y);
          done   <= '1';

       
          state  <= S_INIT;

        when others => null;
      end case;
    end if;
  end process;
end fibo_fsmd_proc;


