.data

	A : .float
	B : .float
	
.text

	la	$s0, A
	la	$s1, B
	
	# Recebendo input do usiario para valor de N
	
	li	$v0, 5		# Comando para ler inteiro
	syscall			# O valor digitado é salvo em $v0
	move	$s2, $v0 	# movendo valor recebido para o reg. $s2
	
	
	li	$t0, 0		#inicializando contador loop receber A
Loop_receber_A:
	
	li	$v0, 5		# Comando para ler inteiro
	syscall			# O valor digitado é salvo em $v0
	move	$s2, $v0 	# movendo valor recebido para o reg. $s2
	
	