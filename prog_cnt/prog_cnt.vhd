library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity prog_cnt is
    Port ( clk : in STD_LOGIC;              -- Entrada de clock
           nrst : in STD_LOGIC;             -- Entrada de reset ass�ncrono
           load : in STD_LOGIC;             -- Entrada de carga s�ncrona
           data_in : in STD_LOGIC_VECTOR(10 downto 0);  -- Entrada de dados para carregamento
           q : out STD_LOGIC_VECTOR(10 downto 0));      -- Sa�da do contador
end prog_cnt;

architecture arch1 of prog_cnt is
    signal cnt : unsigned(10 downto 0) := (others => '0');  -- Sinal interno para manter o estado do contador
begin
    process(clk, nrst)
    begin
        if nrst = '0' then                 -- Se o sinal de reset ass�ncrono estiver em n�vel baixo
            cnt <= (others => '0');         -- Reseta o contador para zero
        elsif rising_edge(clk) then         -- Caso contr�rio, na borda de subida do clock
            if load = '1' then              -- Se o sinal de carga estiver ativo
                cnt <= unsigned(data_in);   -- Carrega um novo valor para o contador a partir dos dados de entrada
            else
                cnt <= cnt + 1;             -- Incrementa o contador
            end if;
        end if;
    end process;
    
	q <= std_logic_vector(to_unsigned(to_integer(cnt), 11));  -- Converte o valor do contador para um vetor de bits para a sa�da
end arch1;
