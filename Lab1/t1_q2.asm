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
	
	# Recebendo input do usiario para valor da variavel B
	li	$v0, 5 # Comando para ler inteiro
	syscall # O valor digitado é salvo em $v0
	move	$s1, $v0 # movendo valor recebido para o registrador referente a B ($s1)
	
	# Realizando Operacoes
	addi	$s0, $s1, 35 # A = (B + 35)
	sub	$t5, $s3, $s0 # t5 = D - A
	add	$s2, $t5, $s4 # C = t5 + E
	
	# Salvando na variavel C da memoria o resultado
	sw	$s2, 0($t2)
	
	# Apresentando resultdo final no terminal
	
	# O valor 1 de comando deve estar salvo no reg. $v0:
	move $v0, $zero  # Resetando valor salvo em $v0
	addi $v0, $v0, 1 # atribuindo 1 para o valor do registrador. 
	
	# O valor a ser escrito no console deve estar no registrador $a0
	move $a0, $s2
	
	#chmando chamda de sistema para executar o output:
	syscall
	
	
	
	
	
	
	
