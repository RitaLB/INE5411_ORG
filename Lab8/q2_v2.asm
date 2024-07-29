.data
	# Escreva o valor de MAX, block_size, a matriz A e a matriz B aqui:
	matriz_A: 	.word 0:1024
	matriz_B: 	.word 0:1024	
	# Reservando 1 byte na memória apenas para usar o endereco dessa variavel como o endereco inicial da matriz C
	matriz_C: .space 1

.text
	li	$s0, 32			# $s0 = MAX
	mul	$s1, $s0, 4		# $s1 = MAX * 4

	li	$s7, 32		# $s7 = block_size

	la	$s2, matriz_A		# $s2 = endereco de matriz_A
	la	$s3, matriz_B		# $s3 = endereco de matriz_B
	la	$s4, matriz_C		# $s4 = endereco de matriz_C
	

	li	$s5, 0			# $s5 = i
	
	Loop_i:
		li	$s6, 0		# $s6 = j
		
		Loop_j:
			move	$t8, $s5	# $t8 = ii (inicia com i)
			
			Loop_ii:
				move	$t9, $s6	# $t9 = jj (inicia com j)
				
				Loop_jj:
					mul	$t0, $t8, $s1          # ii * MAX * 4
					mul	$t1, $t9, 4	       # jj * 4
					add	$t0, $t0, $t1	       # (ii * MAX * 4) + (jj * 4)
					add	$t3, $t0, $s2          # $t3 = (ii * MAX * 4) + (jj * 4) + endereco de matriz_A
					add	$t4, $t0, $s4	       # $t4 =  (ii * MAX * 4) + (jj * 4) + endereco de matriz_C
			
					mul	$t0, $t9, $s1	       # jj * MAX * 4
					mul	$t1, $t8, 4	       # ii * 4 
					add	$t0, $t0, $t1	       # (jj * MAX * 4) + (ii * 4)
					add	$t5, $t0, $s3	       # $t5 = (jj * MAX * 4) + (ii * 4) + endereco matriz_B
			
					lw	$t0, 0($t3)	       # Carrega valor de A[i,j]
					lw	$t1, 0($t5)	       # Carrega valor de B[j,i]
					add	$t6, $t0, $t1	       # A[i,j] + B[j,i]
					sw	$t6, 0($t4)	       # Armazena A[i,j] + B[j,i] em C[i,j]
					
					addi	$t9, $t9, 1	       # jj ++
					add	$t0, $s6, $s7	       # j + block_size
					slt	$t1, $t9, $t0 	       # Se jj < j+block_size -->  $t1 = 1
					beq	$t1, 1, Loop_jj	       # Se $t1 = 1 (jj < j+block_size)  -->   vai para Loop_jj
				
				addi	$t8, $t8, 1		# ii ++
				add	$t0, $s5, $s7		# i + block_size
				slt	$t1, $t8, $t0		# Se ii < i+block_size  -->  $t1 = 1
				beq	$t1, 1, Loop_ii		# Se $t1 = 1 (ii < i+block_size)  -->   vai para Loop_ii
			
			add	$s6, $s6, $s7		# j ++
			slt	$t0, $s6, $s0		# Se j < MAX  -->  $t0 = 1
			beq	$t0, 1, Loop_j       	# Se $t0 = 1 (j < MAX)  -->   vai para Loop_j
		
		add	$s5, $s5, $s7		# i ++
		slt	$t0, $s5, $s0		# Se i < MAX  -->  $t0 = 1
		beq	$t0, 1, Loop_i		# Se $t0 = 1 (i < MAX)  -->   vai para Loop_i
