--Bibliotecas a serem usadas
LIBRARY ieee;
USE ieee.std_logic_1164.all; -- para os tipos std_logic e std_logic_vector
USE ieee.numeric_std.all; -- para convers�es de tipos

--DEFINICAO DA ENTIDADE E SUAS ENTRADAS/SAIDAS
ENTITY reg_bank IS
	PORT(
		clk_in 			: IN STD_LOGIC;						--Entrada respons�vel pelo clock para escrita em todos os registradores A escrita acontece na borda de subida do clock, desde que habilitada. 
		nrst 			: IN STD_LOGIC; 					--Entrada de reset ass�ncrono. Quando ativada (n�vel l�gico baixo), todos os registradores dever�o ser zerados. Esta entrada tem prefer�ncia sobre todas as outras. 
		regn_di			: IN STD_LOGIC_VECTOR(7 DOWNTO 0); 	--Entrada de dados para escrita nos 8 registradores (R0 a R7)
		regn_wr_sel 	: IN STD_LOGIC_VECTOR(2 DOWNTO 0); 	--Entrada para selecionar qual registrador receber� a escrita.
		regn_wr_ena 	: IN STD_LOGIC;						--Entrada de habilita��o para escrita nos registradores (ativa��o em n�vel alto)
		regn_rd_sel_a	: IN STD_LOGIC_VECTOR(2 DOWNTO 0); 	--Entrada para selecionar qual registrador vai ser lido na saida A. 3 bits para permitir endere�ar 8 registradores.
		regn_rd_sel_b	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);	--Entrada para selecionar qual registrador vai ser lido na saida B. 2 bits para permitir endere�ar 8 registradores.
		c_flag_in		: IN STD_LOGIC;						--Entrada de dados para escrita no bit 0 do registrador R7 Flag(C).
		z_flag_in		: IN STD_LOGIC;						--Entrada de dados para escrita no bit 1 do registrador R7 Flag(Z).
		v_flag_in		: IN STD_LOGIC;						--Entrada de dados para escrita no bit 2 do registrador R7 Flag(V)  
		c_flag_wr_ena	: IN STD_LOGIC;						--Entrada de habilita��o de escrita no bit 0 do registrador R7, ativa em n�vel alto.
		z_flag_wr_ena	: IN STD_LOGIC;						--Entrada de habilita��o de escrita no bit 1 do registrador R7, ativa em n�vel alto.
		v_flag_wr_ena	: IN STD_LOGIC;						--Entrada de habilita��o de escrita no bit 2 do registrador R7, ativa em n�vel alto.
		
		regn_do_a		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --Sa�da A de dados de um dos registradores. Independente de sinal de habilita��o e do sinal do clock
		regn_do_b		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --Sa�da B de dados de um dos registradores. Independente de sinal de habilita��o e do sinal do clock
		c_flag_out		: OUT STD_LOGIC;					--Saida do Registrador R7(0)(C). Independente de sinal de habilita��o e do sinal do clock
		z_flag_out		: OUT STD_LOGIC;					--Saida do Registrador R7(1)(Z). Independente de sinal de habilita��o e do sinal do clock
		v_flag_out		: OUT STD_LOGIC						--Saida do Registrador R7(2)(V). Independente de sinal de habilita��o e do sinal do clock
	);
END ENTITY;

--DEFINICAO DA ARQUITETURA

ARCHITECTURE arch1 OF reg_bank IS
	TYPE mem_type IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(7 DOWNTO 0); --Define o tipo de dados para o banco de registradores (8 registradores de 8 bits cada)
	SIGNAL mem_reg 		: mem_type; 								--Declara o banco de registradores utilizando o tipo definida acima.
	SIGNAL addr_int 	: INTEGER RANGE 0 TO 2; 					--Declara a vari�vel de endere�amento do registrador que receber� o dado da entrada.
	SIGNAL addr_int_a 	: INTEGER RANGE 0 TO 2; 					--Declara a vari�vel de endere�amento do registrador que ser� lido pela saida A.
	SIGNAL addr_int_b 	: INTEGER RANGE 0 TO 2; 					--Declara a vari�vel de endere�amento do registrador que ser� lido pela saida B.
	
BEGIN

--CONVERS�O DE TIPOS
	
	addr_int   <= 	TO_INTEGER(UNSIGNED(regn_wr_sel)); 				--Converte de STD_LOGIC para INTEGER a entrada de endere�o de registrador a ser escrito.
	addr_int_a <= 	TO_INTEGER(UNSIGNED(regn_rd_sel_a));				--Converte de STD_LOGIC para INTEGER a entrada de endere�o de registrador a ser lido pela saida A.
	addr_int_b <= 	TO_INTEGER(UNSIGNED(regn_rd_sel_b));				--Converte de STD_LOGIC para INTEGER a entrada de endere�o de registrador a ser lido pela saida B.

--PROCESSO PARA ESCRITA NOS REGISTRADORES
	PROCESS(nrst, clk_in, regn_wr_ena)
		BEGIN
		IF nrst ='0' THEN
			mem_reg <= (OTHERS => (OTHERS => '0'));					--Caso o Reset esteja em n�vel l�gico baixo, o valor � zerado.
		ELSIF RISING_EDGE(clk_in) THEN								--Verifica se o clock est� na borda de subida.
				IF regn_wr_ena = '1' THEN							--Verifica se a escrita nos registradores est� habilitada
					mem_reg(addr_int) <= regn_di;					--Escreve o dado (regn_di) no registrador R(addr_int)
				END IF;
				
				IF c_flag_wr_ena = '1' THEN
					mem_reg(7)(0) <= c_flag_in;						--Verifica se o sinal de enable respectivo a entrada est� habilitado e escreve o dado da respectiva entrada no bit do registrador
				END IF;
				
				IF z_flag_wr_ena = '1' THEN
					mem_reg(7)(1) <= z_flag_in;						--Verifica se o sinal de enable respectivo a entrada est� habilitado e escreve o dado da respectiva entrada no bit do registrador
				END IF;
				
				IF v_flag_wr_ena = '1' THEN
					mem_reg(7)(2) <= v_flag_in;						--Verifica se o sinal de enable respectivo a entrada est� habilitado e escreve o dado da respectiva entrada no bit do registrador
				END IF;
		END IF;
	END PROCESS;

--LEITURA DOS REGISTRADORES

	regn_do_a 	<= 	mem_reg(addr_int_a);
	regn_do_b 	<= 	mem_reg(addr_int_b);
	c_flag_out 	<= 	mem_reg(7)(0);
	z_flag_out 	<= 	mem_reg(7)(1);
	v_flag_out 	<= 	mem_reg(7)(2);
END arch1;
		