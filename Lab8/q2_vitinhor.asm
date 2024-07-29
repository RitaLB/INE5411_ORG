.data
	MatrizA: .word 0:1024		# Matriz MAX x MAX (MAX = 128)
	MatrizB: .word 0:1024  		# Matriz MAX x MAX (MAX = 128)
	
.text

	li 	$s0, 32			# $s0 = MAX, escolhemos nao colocar MAX em 
					# memoria para facilitar analise da cache
	
	li	$s7, 4			# $s7 = block_size

	la	$s1, MatrizA		# Endereco inicial da MatrizA
	la	$s2, MatrizB		# Endereco inicial da MatrizB
	
	# $s3 = i
	# $s4 = j
	# $s5 = ii
	# $s6 = jj
	# $s7 = block_size

linha:
	beq	$s3, $s0, exitLinha	# Caso o registrador de controle "linha" ($s3)
					# seja igual a MAX, saimos do loop

	add	$s4, $zero, $zero	# Registrador de controle "coluna"
	
coluna:
	beq	$s4, $s0, exitColuna
	
	add 	$s5, $s3, $zero

linha_linha:
	add 	$t0, $s3, $s7
	beq	$s5, $t0, exitLinha_Linha
	
	add	$s6, $s4, $zero
	
coluna_coluna:
	add	$t0, $s4, $s7
	beq	$s6, $t0, exitColuna_Coluna
	
	# Endereco na Matriz A

	mul 	$t0, $s0, 4		# Calcula deslocamento da linha
	mul	$t0, $s5, $t0		# $t0 = linha_linha * MAX * 4

	mul	$t1, $s6, 4		# Calcula deslocamento da coluna
					# $t1 = coluna_coluna * 4

	add	$t2, $t0, $t1		# Calcula endereco final para acessar
	add	$t2, $t2, $s1		# a MatrizA

	# -----------------------------------

	# Endereco na Matriz B

	mul 	$t0, $s0, 4		# Calcula deslocamento da coluna
	mul	$t0, $s6, $t0		# $t0 = coluna_coluna * MAX * 4

	mul	$t1, $s5, 4		# Calcula deslocamento da linha
					# $t1 = linha_linha * 4

	add	$t3, $t0, $t1		# Calcula endereco final para acessar
	add	$t3, $t3, $s2		# a MatrizB
	
	# -----------------------------------

	# Calculos para armazenar na matriz
	
	lw	$t0, 0($t2)		# Carrega valor da MatrizA
	lw	$t1, 0($t3)		# Carrega valor da MatrizB

	add	$t0, $t0, $t1		# Soma MatrizA(i,j) + MatrizB(j,i)
	
	sw	$t0, 0($t2)		# Armazena resultado na MatrizA

	# -----------------------------------
	
	addi 	$s6, $s6, 1
	
	j 	coluna_coluna

exitColuna_Coluna:	
	addi 	$s5, $s5, 1
	
	j 	linha_linha
	
exitLinha_Linha:
	add	$s4, $s4, $s7		# Incrementa "coluna"
	
	j 	coluna

exitColuna:
	add	$s3, $s3, $s7		# Incrementa o registrador de controle "linha"
	
	j 	linha		      	# Volta para o inicio do loop
	
exitLinha:
	li	$v0, 10 		# Encerra programa			
	syscall				#
