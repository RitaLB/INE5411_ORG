.data

.text


# Recebendo input do usiario para valor de x
	
li	$v0, 5		# Comando para ler inteiro
syscall			# O valor digitado é salvo em $v0
move	$a0, $v0 	# $a0 = base

li	$v0, 5
syscall
move	$a1, $v0 	# $a1 = expoente

jal pow

pow:
	sw	$ra, 0($sp)
	move	$t0, $a0	#$t0 = x
	move	$t1, $a1	#$t1 = limite contador (expoente)
	
	li	$t2, 1		#$t2 = resultado	
	li	$t3, 0		#contatador potência
	
		Loop_potencia:
		
			mul	$t2, $t2, $t0		
			
			addi	$t3, $t3, 1		# $t1 = $t1 + 1 ---- n = n+1
			bne	$t3, $t1, Loop_potencia	# Enquanto o número de loops for diferente de n atual, continua loop
	
	move	$v0, $t2
	jr	$ra	
	

  # Carrega o endereço da string em $a0 usando 'la'
move	$a0, $v0

   # Define o serviço de impressão de string (código 4) em $v0
li	$v0, 4

    # Chama a interrupção do sistema para imprimir a string
syscall



