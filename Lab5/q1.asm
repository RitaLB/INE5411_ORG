.data
	# reservando espaço na memória para 1024 bytes = 256 words
	matriz: .space 1024

.text
	la	$s0, matriz	# $s0 = endereço inicial da matriz
	li	$s7, 0		# $s7 = número a ser guardado na matriz
	
	li	$s1, 0		# $s1 = row    -->  contador de linhas
				# row = 0      -->  começa na linha 0
	
	Loop_row:
		sll	$t0, $s1, 6	        # $t0 = row * 64   -->  para determinar a posição na memória
		li	$s2, 0 			# $s2 = col        -->  contador de colunas
						# col = 0          -->  começa na coluna 0
		
		Loop_col:
			sll	$t1, $s2, 2		# $t1 = col * 4      -->  para determinar a posição na memória
			add	$t2, $t0, $t1		# $t2 = $t0 + $t1    -->  $t2 = (row*64) + (col*4)
			add	$t3, $s0, $t2		# $t3 = endereço inicial da matriz + $t2
			sw	$s7, 0($t3)		# salva $s7 na posição $t3 da memória
			
			addi	$s7, $s7, 1		# $s7 += 1
			addi	$s2, $s2, 1		# col += 1
			bne	$s2, 16, Loop_col       # se col != 16, vai para Loop_col  --> vai para próxima coluna
			
		#fora do Loop_col
		addi	$s1, $s1, 1		# row += 1
		bne	$s1, 16, Loop_row	# se row != 16 vai para Loop_row  --> vai para próxima linha
