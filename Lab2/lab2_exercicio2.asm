.data
	# Salvando as matrizes A e B na memória
	A:	.word 1 2 3 0 1 4 0 0 1
	B: 	.word 1 -2 5 0 1 -4 0 0 1
	
	# Inicializando as matrizes B transposta e C na memória com os valores igual a 0 em todos os elementos
	Bt:	.word 0 0 0 0 0 0 0 0 0    # Bt = B transposta
	C: 	.word 0 0 0 0 0 0 0 0 0    # C = resposta da multiplicação A x Bt
	arq:	.asciiz 	"matriz_resultante.txt"
	buffer: .space 27	# Buffer de string para armazenar os caracteres em ASCII da matriz (tamnho preciso para a matriz resultante específica desse exercício)
	
.text
	# Início do programa
	
	# Carregando o endereço do primeiro elemento das matrizes em registradores
	la	$s0, A		# $s0 <- endereço de A
	la	$s1, B		# $s1 <- endereço de B
	la	$s2, Bt		# $s2 <- endereço de Bt
	la	$s3, C		# $s3 <- endereço de C
	
	
	# Início do código que faz a transposição de B e a salva na memória no endereço inicial salvo em $s2

	# Carregando registrador temporário $t0 com o endereço inicial de Bt 
	# pois $t0 será modificado ao longo do programa para percorrer o endereço de todos os elementos de Bt
	move	$t0, $s2	# $t0 = endereço de Bt
	
	# Salvamento da posição do 1º elemento da coluna (da matriz B) a ser transposta em relação ao endereço inicial de B
	li	$s4, 0		# $s4 = coluna de B


	# Loop que percorrerá as 3 colunas de B
Loop_coluna:

	# Salvamento da posição do 1º elemento da linha em relação a coluna a ser transposta
	li	$s5, 0		# $s5 = linha de B
	
	# Loop que percorrerá as 3 linhas de B
	Loop_linha:
	
		# $t1 = indice de B (posição de um elemento da matriz B em relação ao endereço inicial de B)
		add	$t1, $s4, $s5     	# indice de B = coluna de B + linha de B
		add	$t2, $s1, $t1	  	# $t2 guarda o endereço do elemento de B que será usado
		lw	$t3, 0($t2)	  	# $t3 = B[indice de B]
		
		# Salva na memória os elementos de Bt
		sw	$t3, 0($t0)       	# Bt[indice de Bt] = $t3
		
		# Endereço de Bt vai pro próximo elemento de Bt
		addi	$t0, $t0, 4	  	# $t0 += 4
		
		# Somando 12 a linha de B para ir a posição do elemento da próxima linha da mesma coluna
		addi	$s5, $s5, 12	  	# linha de B += 12
		bne	$s5, 36, Loop_linha	# se linha de B == 36 (já percorreu as 3 linhas de certa coluna) sai do Loop_linha
	
	# Fora do Loop_linha
	# Somando 4 a coluna de B para ir a posição do 1º elemento da próxima coluna a ser transposta
	addi	$s4, $s4, 4		# coluna de B += 4
	bne	$s4, 12, Loop_coluna	# se coluna de B == 12 (já percorreu as 3 colunas) sai do Loop_coluna
	
	
	# Fora do Loop_coluna
	# Término da transposição de B
	
	
	# Início da multiplicação C = A x Bt
	

	# Carregando registrador temporário $t0 com o endereço inicial de C
	# pois $t0 será modificado ao longo do programa para percorrer o endereço de todos os elementos de C
	move	$t0, $s3		# $t0 = indice de C
	
	# $s4 e $s5 não serão mais usados da mesma forma que anteriormente, então é possível reiniciá-los
	# Salvamento da posição do 1º elemento da linha da matriz A em relação ao endereço inicial de A
	li 	$s4, 0			# s4 = linha de A
	
	# Loop que percorrerá as 3 linhas de A:
Loop_linhas_A:

	# Salvamento da posição do 1º elemento da coluna da matriz Bt em relação ao endereço inicial de Bt
	li	$s5, 0			# $s5 = coluna de Bt
	
	# Loop que percorrerá as 3 colunas de Bt:
	Loop_colunas_Bt:
	
		# $t1 e $t2 guardam o endereço dos primeiros elementos que serão usados na multiplicação 
		# de respectivamente uma linha de A e uma coluna de  Bt
		add	$t1, $s4, $s0		# $t1 = endereço do 1º elemento de certa linha de A
						# $t1 = linha de A + endereço inicial de A
		add	$t2, $s5, $s2		# $t2 = endereço do 1º elemento de certa linha de Bt
						# $t2 = coluna de Bt + endereço inicial de Bt
		
		# $t3 será um contador para o Loop_mult que fará o somatório de 3 multiplicações 
		# de elementos de uma linha de A com elementos de uma coluna de Bt
		li	$t3, 0			# $t3 inicia com 0
		
		# $t4 será o resultado do somatório, que será o valor a ser colocado na matriz C
		li	$t4, 0			# $t4 inicia com 0
		
		# Loop que percorrerá 3 elementos de uma linha de A e 3 elementos de uma coluna de Bt:
		Loop_mult:
		
			# Carregamento dos valores a serem usados na multiplicação para registradores temporários
			lw	$t5, 0($t1)		# $t5 = elemento de A
			lw	$t6, 0($t2)		# $t6 = elemento de Bt
			
			mult	$t5, $t6		# multiplicação dos elementos carregados acima
			mflo	$t7			# coloca o resultado da multiplicação em $t7 (só é usado o bit menos 
							# significativo do resultado pois os elementos de  A e B são valores 
							# pequenos, portanto o bit mais significativo não será importante)
							
			add	$t4, $t4, $t7		# $t4 += resultado da multiplicação
			
			# Somando 4 a $t5 para ir para o próximo elemento dessa linha de A
			addi	$t1, $t1, 4		# $t1 += 4
			# Somando 12 a $t6 para ir para o próximo elemento dessa coluna de Bt
			addi	$t2, $t2, 12 		# $t2 += 12
			
			# Somando 1 ao contador do Loop_mult
			addi	$t3, $t3, 1		# $t3 += 1
			bne	$t3, 3, Loop_mult	# se contador == 3 sai do Loop_mult
		
		# Fora do Loop_mult
		# Salvamento do resultado do somatório na memória de uma elemento da matriz C
		sw	$t4, 0($t0)
		
		# Endereço de C vai para o próximo elemento de C
		addi	$t0, $t0, 4		   # $t0 += 4
		# Somando 4 a coluna de Bt para ir a posição do 1º elemento da próxima coluna
		addi	$s5, $s5, 4
		bne	$s5, 12, Loop_colunas_Bt   # se coluna de Bt == 12 (já percorreu as 3 colunas) sai do Loop_colunas_Bt
		
	# Fora do Loop_colunas_Bt
	# Somando 12 a linha de A para ir para a posição do 1º elemento da próxima linha
	addi	$s4, $s4, 12		   # $s4 += 12
	bne	$s4, 36, Loop_linhas_A     # se linha de A == 32 (já percorreu as 3 linhas) sai do Loop_linhas_A
			


# salvando resultado presente na memória de C em um arquivo, cada digito em formato ASCII

# convertento dados da matriz para digitos ASCII e salvando em uma "string" na memória

	# Carregando registrador temporário $t0 com o endereço inicial de C
	# pois $t0 será modificado ao longo do programa para percorrer o endereço de todos os elementos de C
	move	$t0, $s3	
	# $t8 recebe valor da posição inicial menos 4 para ser usado como limitador de loop
	subi	$t8, $s3, 4
					
	#queremos acessar os valores da matriz c do fim para o início. Para isso, vamos adicionar ao valor do endereço de C o tamanho dela, para acessar sua ultima psição 
	# 9 posições = 9 x 4 bytes = 36 - 4  ( começa do 0)
	addi	$t0, $t0, 32	# $t0 = indice da matriz C

	# carregando registrador com endereço do início do Buffer
	la	$t1, buffer
	# queremos acessar e inserir dados do fim da string para o começo. Então, vamos adicionar ao valor do endereço do buffer o tamanho dele, para acessar sua ultima posição
	addi	$t1, $t1, 26 # $t1 = iterador a posição string

	# carregando registrador com 10 
	li	$t3, 10	 #$t3 = 10
	
# início loop de percorrimento dos valores da matriz C:
# cria iterador ($t9) para quebra de linha
	li	$t9,	0 #contador de final de linha inicializado
Loop_matriz:
	# auxiliar ($t4) = abs(C[$to))
	lw	$t2,  0($t0)
	abs	$t4,  $t2
	abs	$s5,  $t2
	
	
	# lóop para percorrer todos os dígitos ascii do número na pisoção atual da matriz
	Loop_digitos:
		# resto( $t5) =  auxiliar ($t4) / 10
		div	$t4, $t3   # Divide auxiliar $t4 por 10;
		mfhi	$t5      # Move o resto (HI) para $t3

		# digito ($t6) = resto ($t5) + 48 (para encontrar valor digito ASCII)
		addi	$t6, $t5, 48
		
		# salva dígito ($t6) na memória da string buffer ($t1) com store byte 
		sb	$t6, 0($t1)
		
		# auxiliar ($t4) = resultado da divisão por 10
		mflo $t4
		
		# iterador da posição na string buffer ($t1) é decrescentado
		subi $t1, $t1, 1
		 
		
		bne	$t4, 0, Loop_digitos	# se o iterador do caracter == 0 (já percorreu todos caracteres do número) sai do Loop_dígitos
		
	# iterador da posição na matriz($t0) é decrescentado
	subi $t0, $t0, 4
	
	# verificar se número atual da mariz ($t2) é um número negativo:
	
		#soma o valor abs do número com o valor original do número es alva em $t7
	add $t7, $s5, $t2  
		
	bne $t7, $zero, positivo  # Se resultado for diferente de 0, o número é positivo. 

		# se número for negativo, tem que adicionar sinal de negativo na string
	li	$t7, 45	 # temporário $t7 = "-"
		# salva número ascii de "-" ($t7)  na memória da string buffer ($t1) com store byte 
	sb	$t7, 0($t1)
	
		# iterador da posição na string buffer ($t1) é decrescentado
		subi $t1, $t1, 1
		
	positivo:
	# Continua processo do loop da matriz
	
	# salva caracter de espaço na string biffer para separar números
	li	$t7, 32	 # temporário $t7 = " "
	# salva número ascii de " " ($t7)  na memória da string buffer ($t1) com store byte 
	sb	$t7, 0($t1)
	
	# iterador da posição na string buffer ($t1) é decrescentado
	subi	$t1, $t1, 1

	
	
	# verifica se iterador de linha é igual a 3:
	
	# iterrador de linha recebe +1
	addi	$t9, $t9, 1
	
	bne	$t9, 3, Nao_add_quebra_linha
	
	# salva caracter de quebra de linha na string buffer para separar linhas
	li	$t7, 10	 # temporário $t7 = quebra de linha
	# salva número ascii de quebra de linha ($t7)  na memória da string buffer ($t1) com store byte 
	sb	$t7, 0($t1)
	
	# iterador da posição na string buffer ($t1) é decrescentado
	subi	$t1, $t1, 1
	#iterador de linha é reiniciado
	li	$t9, 0
	
	Nao_add_quebra_linha:
	
	bne	$t0, $t8, Loop_matriz # se iterador chegar na posição inicial da matriz -4, sai do loop da matriz

# salvando resultado da conversão no arquivo:

# Abrindo o arquivo matriz_resultante.txt para escrita:
	li	$v0, 13			# comando para abrir arquivo
	la	$a0, arq		# Endereço da string com o nome do arquivo a ser aberto
	li	$a1, 1			# flag de escrita 
	syscall				# chamada de sistema --> arquivo é aberto
	move	$s6, $v0		# salvando o descritor do arquivo em $s6
	
# Escrevendo o resultado do somatório, que é um elemento da matriz C, no arquivo matriz_resultante.txt
	li	$v0, 15			   # comando para escrever no arquivo
	move	$a0, $s6		   # descritor do arquivo colocado em $a0
	la	$t7, buffer		   #carregando endereço do buffer para $t7
	move	$a1, $t7
	li 	$a2, 27             	   # tamanho do dado a ser escrito (24 bytes)
	syscall
	
# fechando o arquivo após a escrita
	li $v0, 16           # Código da chamada do sistema para fechar um arquivo
   	move $a0, $s6        # Descritor de arquivo
   	syscall              
	
