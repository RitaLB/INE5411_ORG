.data 
	#variaveis na memoria de dados
	A: .word 1
	B: .word 10
	C: .word 1
	D: .word 100
	E: .word 20
	
.text 
	#início do programa
	# Carregando endereco das variaveis da memoria para registradores temporarios 
	la	$t0, A
	la	$t1, B
	la	$t2, C
	la	$t3, D
	la	$t4, E
	
	# Carregando os valores das variaveis para registradores. Possibilita realizar as operacoes com os valores
	lw	$s0, 0($t0) #A
	lw	$s1, 0($t1) #B
	lw	$s2, 0($t2) #C
	lw	$s3, 0($t3) #D
	lw	$s4, 0($t4) #E
	
	# Realizando Operacoes
	addi	$s0, $s1, 35 # A = (B + 35)
	sub	$t5, $s3, $s0 # t5 = D - A
	add	$s2, $t5, $s4 # C = t5 + E
	
	# Salvando na variavel C da memoria o resultado
	sw	$s2, 0($t2)
	
	
	
