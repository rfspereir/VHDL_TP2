--Bibliotecas a serem usadas
LIBRARY ieee;
USE ieee.std_logic_1164.all; -- para os tipos std_logic e std_logic_vector
USE ieee.numeric_std.all; -- para conversões de tipos

--DEFINICAO DA ENTIDADE E DUAS ENTRADAS/SAIDAS
ENTITY reg_bank IS
	PORT(
		clk_in 			: IN STD_LOGIC;						--Entrada responsável pelo clock para escrita em todos os registradores A escrita acontece na borda de subida do clock, desde que habilitada. 
		nrst 			: IN STD_LOGIC; 					--Entrada de reset assíncrono. Quando ativada (nível lógico baixo), todos os registradores deverão ser zerados. Esta entrada tem preferência sobre todas as outras. 
		regn_di			: IN STD_LOGIC_VECTOR(7 DOWNTO 0); 	--Entrada de dados para escrita nos 8 registradores (R0 a R7)
		regn_wr_sel 	: IN STD_LOGIC_VECTOR(2 DOWNTO 0); 	--Entrada para selecionar qual registrador receberá a escrita.
		regn_wr_ena 	: IN STD_LOGIC;						--Entrada de habilitação para escrita nos registradores (ativação em nível alto)
		regn_rd_sel_a	: IN STD_LOGIC_VECTOR(2 DOWNTO 0); 	--Entrada para selecionar qual registrador vai ser lido na saida A. 3 bits para permitir endereçar 8 registradores.
		regn_rd_sel_b	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);	--Entrada para selecionar qual registrador vai ser lido na saida B. 2 bits para permitir endereçar 8 registradores.
		c_flag_in		: IN STD_LOGIC;						--Entrada de dados para escrita no bit 0 do registrador R7 Flag(C).
		z_flag_in		: IN STD_LOGIC;						--Entrada de dados para escrita no bit 1 do registrador R7 Flag(Z).
		v_flag_in		: IN STD_LOGIC;						--Entrada de dados para escrita no bit 2 do registrador R7 Flag(V)  
		c_flag_wr_ena	: IN STD_LOGIC;						--Entrada de habilitação de escrita no bit 0 do registrador R7, ativa em nível alto.
		z_flag_wr_ena	: IN STD_LOGIC;						--Entrada de habilitação de escrita no bit 1 do registrador R7, ativa em nível alto.
		v_flag_wr_ena	: IN STD_LOGIC;						--Entrada de habilitação de escrita no bit 2 do registrador R7, ativa em nível alto.
		
		regn_do_a		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- Saída A de dados de um dos registradores. Independente de sinal de habilitação e do sinal do clock
		regn_do_b		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- Saída B de dados de um dos registradores. Independente de sinal de habilitação e do sinal do clock
		c_flag_out		: OUT STD_LOGIC;					-- Saida do Registrador R7(0)(C). Independente de sinal de habilitação e do sinal do clock
		z_flag_out		: OUT STD_LOGIC;					-- Saida do Registrador R7(1)(Z). Independente de sinal de habilitação e do sinal do clock
		v_flag_out		: OUT STD_LOGIC;					-- Saida do Registrador R7(2)(V). Independente de sinal de habilitação e do sinal do clock
		);
END ENTITY;
		