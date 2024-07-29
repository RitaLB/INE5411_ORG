.data
	# Salvando as matrizes A e B na memória
	A:	.word 1 2 3 0 1 4 0 0 1
	B: 	.word 1 -2 5 0 1 -4 0 0 1
	
	# Inicializando as matrizes B transposta e C na memória com os valores igual a 0 em todos os elementos
	Bt:	.word 0 0 0 0 0 0 0 0 0    # Bt = B transposta
	C: 	.word 0 0 0 0 0 0 0 0 0    # C = resposta da multiplicação A x Bt

.text
	# Início do programa
	
	# Carregando o endereço do primeiro elemento das matrizes em registradores
	la	$s0, A		# $s0 <- endereço de A
	la	$s1, B		# $s1 <- endereço de B
	la	$s2, Bt		# $s2 <- endereço de Bt
	la	$s3, C		# $s3 <- endereço de C
	
	# Carregando os endereços de B e Bt em $a0 e $a1 para usar como argumentos do procedimento transposição
	move	$a0, $s1	# $a0 <- $s1
	move	$a1, $s2	# $a1 <- $s2
	
	# Chamando o procedimento que faz a transposição de B
	jal	PROC_TRANS
	
	# Carregando os endereços de A, Bt e C em $a0, $a1 e $a2 para usar como argumentos do procedimento multiplicação
	move	$a0, $s0	# $a0 <- $s0
	move	$a1, $s2	# $a1 <- $s2
	move	$a2, $s3	# $a2 <- $s3
	
	# Chamando o procedimento que faz a multiplicação
	jal	PROC_MUL
	
	# Depois que acaba o procedimento, vai para Exit, onde acaba o programa
	j	Exit
	
	
	
# Procedimento que faz a transposição de B e a salva na memória no endereço inicial salvo em $a1
PROC_TRANS:
	
	# Salvamento da posição do 1º elemento da coluna (da matriz B) a ser transposta em relação ao endereço inicial de B
	li	$t4, 0		# $t4 = coluna de B

	# Loop que percorrerá as 3 colunas de B
Loop_coluna:

	# Salvamento da posição do 1º elemento da linha em relação a coluna a ser transposta
	li	$t5, 0		# $t5 = linha de B
	
	# Loop que percorrerá as 3 linhas de B
	Loop_linha:
	
		# $t1 = indice de B (posição de um elemento da matriz B em relação ao endereço inicial de B)
		add	$t1, $t4, $t5     	# indice de B = coluna de B + linha de B
		add	$t2, $a0, $t1	  	# $t2 guarda o endereço do elemento de B que será usado
		lw	$t3, 0($t2)	  	# $t3 = B[indice de B]
		
		# Salva na memória os elementos de Bt
		sw	$t3, 0($a1)       	# Bt[indice de Bt] = $t3
		
		# Endereço de Bt vai pro próximo elemento de Bt
		addi	$a1, $a1, 4	  	# $a1 += 4
		
		# Somando 12 a linha de B para ir a posição do elemento da próxima linha da mesma coluna
		addi	$t5, $t5, 12	  	# linha de B += 12
		bne	$t5, 36, Loop_linha	# se linha de B == 36 (já percorreu as 3 linhas de certa coluna) sai do Loop_linha
	
	# Fora do Loop_linha
	# Somando 4 a coluna de B para ir a posição do 1º elemento da próxima coluna a ser transposta
	addi	$t4, $t4, 4		# coluna de B += 4
	bne	$t4, 12, Loop_coluna	# se coluna de B == 12 (já percorreu as 3 colunas) sai do Loop_coluna
	
	# Fora do Loop_coluna
	jr	$ra



# Procedimento que faz a multiplicação C = A x Bt
PROC_MUL:
	
	# $s4 e $s5 não serão mais usados da mesma forma que anteriormente, então é possível reiniciá-los
	# Salvamento da posição do 1º elemento da linha da matriz A em relação ao endereço inicial de A
	li 	$t8, 0			# t8 = linha de A
	
	# Loop que percorrerá as 3 linhas de A:
Loop_linhas_A:

	# Salvamento da posição do 1º elemento da coluna da matriz Bt em relação ao endereço inicial de Bt
	li	$t9, 0			# $t9 = coluna de Bt
	
	# Loop que percorrerá as 3 colunas de Bt:
	Loop_colunas_Bt:
	
		# $t1 e $t2 guardam o endereço dos primeiros elementos que serão usados na multiplicação 
		# de respectivamente uma linha de A e uma coluna de  Bt
		add	$t1, $t8, $a0		# $t1 = endereço do 1º elemento de certa linha de A
						# $t1 = linha de A + endereço inicial de A
		add	$t2, $t9, $a1		# $t2 = endereço do 1º elemento de certa linha de Bt
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
		sw	$t4, 0($a2)
		
		# Endereço de C vai para o próximo elemento de C
		addi	$a2, $a2, 4		   # $a2 += 4
		# Somando 4 a coluna de Bt para ir a posição do 1º elemento da próxima coluna
		addi	$t9, $t9, 4
		bne	$t9, 12, Loop_colunas_Bt   # se coluna de Bt == 12 (já percorreu as 3 colunas) sai do Loop_colunas_Bt
		
	# Fora do Loop_colunas_Bt
	# Somando 12 a linha de A para ir para a posição do 1º elemento da próxima linha
	addi	$t8, $t8, 12		   # $s4 += 12
	bne	$t8, 36, Loop_linhas_A     # se linha de A == 32 (já percorreu as 3 linhas) sai do Loop_linhas_A
	
	jr	$ra
			
		

Exit:

