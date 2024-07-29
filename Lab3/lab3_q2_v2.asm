.data
	n: .word 20
	x: .double 90
	resultado : .double 0
	
.text
main:
	
	la	$t0, qtd_termos		# $s0 = n
	lw	$s0, 0($t0)
	move	$a0, $s0		#parâmetro $a0 = n
	
	la	$t0, x			# $t0 =  endereço de x
	move	$a1, $t0		#parâmetro $a1 = endereço de x
	
	la	$t1, resultado
	move	$a2, $t1		#parâmetro $a2 = endereço de resultado
	
	
	
	jal 	seno			# Chama o procedimento seno

	

	li	$v0, 10			# Termina o programa por meio de uma 
	syscall				# chamada de sistema
	
	
seno:
	mtc1.d	$a0, $f0		
	cvt.d.w	$f0, $f0		# f0 = n em double
	
	move	$t0, $a0		# $t0 = n em word
	
	move	$t1, $a1		# $t1 = endereço de x
	lwc1	$f2, 0($t1)		# $f2 = x
	
	addi	$sp, $sp, -4			# salva na pilha o endereço de ra
	sdc1	$ra, 4($sp)			#
	
	
	# calcular -1 ^ n por meio de função de potenciação
	Loop_somatorio:
		
		# calcular -1 ^ n por meio de função de potenciação

		move	$a0, $t0		#$a0 = n final
		
		li	$t2, -1			# !! $t2 descartável !!
		move	$a1, $t2		#$a1 = -1
		
		jal	potencia
		
		lwc1	$f4, 16($sp)		# $f4 = resultadp -1^n salvo na memória
		addi	$sp, $sp, 16		#pop
		
		# calcular 2n+1 em word $t3 = 2n+1
		
		mul	$t3, $t0, 2
		addi	$t3, 1
		
		# calcular x^2n+1
		
		move	$a0, $t3		#$a0 = 2n+1
		
		move	$a1, 
	
	
potencia:
		# !! $f6, $f8 podem ser reutilizados fora dessa função !!
		move	$t2, $a0		# $t2 = n final
		
		move	$t3, $a1		# !! $t3 descartável !!
		mtc1.d	$t3, $f6		# $f6 = número p\ potencia double
		cvt.d.w	$f6, $f6
		
		addi	$t3, 1		# !! $t3 descartável !!
		mtc1.d	$t3, $f8	# $f8 = 1
		cvt.d.w	$f8, $f8
	Loop_potencia:
		
		mul.d	$f8, $f8, $f6
		
		subi	$t2, $t2, 1		#	diminui n final
		bne	$t2, 0, Loop_potencia
		
	addi 	$sp, $sp, -16			# push : Aumenta a pilha o suficiente para alocar o double resultado
	swc1	$f8, 16($sp)
	
	jr	$ra
	
	
