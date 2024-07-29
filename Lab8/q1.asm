.data
	# Escreva o valor de MAX, a matriz A e a matriz B aqui:
	MAX: .word 8
	matriz_A: .word 3 6 5 9 7 5 3 1 2 5 4 8 9 0 2 1 3 6 5 9 7 5 3 1 2 5 4 8 9 0 2 1 3 6 5 9 7 5 3 1 2 5 4 8 9 0 2 1 3 6 5 9 7 5 3 1 2 5 4 8 9 0 2 1
	matriz_B: .word 8 6 4 7 2 6 4 5 8 9 1 2 3 4 6 9 3 6 5 9 7 5 3 1 2 5 4 8 9 0 2 1 3 6 5 9 7 5 3 1 2 5 4 8 9 0 2 1 3 6 5 9 7 5 3 1 2 5 4 8 9 0 2 1 
	
	# Reservando 1 byte na memória apenas para usar o endereco dessa variavel como o endereco inicial da matriz C
	matriz_C: .space 1
	
.text
	la	$s0, MAX
	lw	$s0, 0($s0)		# $s0 = MAX
	mul	$s1, $s0, 4		# $s1 = MAX * 4
	
	la	$s2, matriz_A		# $s2 = endereco de matriz_A
	la	$s3, matriz_B		# $s3 = endereco de matriz_B
	la	$s4, matriz_C		# $s4 = endereco de matriz_C
	
	li	$s5, 0			# $s5 = i
	
	Loop_i:
		li	$s6, 0		# $s6 = j
		
		Loop_j:
			mul	$t0, $s5, $s1          # i * MAX * 4
			mul	$t1, $s6, 4	       # j * 4
			add	$t0, $t0, $t1	       # (i * MAX * 4) + (j * 4)
			add	$t3, $t0, $s2          # $t3 = (i * MAX * 4) + (j * 4) + endereco de matriz_A
			add	$t4, $t0, $s4	       # $t4 =  (i * MAX * 4) + (j * 4) + endereco de matriz_C
			
			mul	$t0, $s6, $s1	       # j * MAX * 4
			mul	$t1, $s5, 4	       # i * 4 
			add	$t0, $t0, $t1	       # (j * MAX * 4) + (i * 4)
			add	$t5, $t0, $s3	       # $t5 = (j * MAX * 4) + (i * 4) + endereco matriz_B
			
			lw	$t0, 0($t3)	       # Carrega valor de A[i,j]
			lw	$t1, 0($t5)	       # Carrega valor de B[j,i]
			add	$t6, $t0, $t1	       # A[i,j] + B[j,i]
			sw	$t6, 0($t4)	       # Armazena A[i,j] + B[j,i] em C[i,j]
			
			addi	$s6, $s6, 1	       # j ++
			slt	$t0, $s6, $s0	       # Se j < MAX  -->  $t0 = 1
			beq	$t0, 1, Loop_j         # Se $t0 = 1 (j < MAX)  -->   vai para Loop_j
		
		addi	$s5, $s5, 1		# i ++
		slt	$t0, $s5, $s0		# Se i < MAX  -->  $t0 = 1
		beq	$t0, 1, Loop_i		# Se $t0 = 1 (i < MAX)  -->   vai para Loop_i
