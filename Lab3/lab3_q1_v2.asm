.data
	x: .double 9
	n: .word 30
	resultado: .double 0
.text
	
	la	$a0, x		#$a0 =  endereço de x
	la	$a1, n		#$a1 =  endereço de n
	
	
	jal 	raiz_aproximada
	
	j	exit
	
raiz_aproximada:
	ldc1	$f0, 0($a0)		# $f0 = valor de x !! antes tava l.d
	lw	$t0, 0($a1)		#t0 = valor de n
	
	
	li	$t1, 1			
	mtc1.d	$t1, $f2		# f2 = estimativa = 1 . 
	cvt.d.w	$f2, $f2
	
	li	$t1, 2			
	mtc1.d	$t1, $f4 
	cvt.d.w	$f4, $f4		# f6 = 2
	
	
	li	$t1, 0			# $t1 é o contador do loop
	
	Loop:
	div.d	$f6, $f0, $f2		# $f6 = $f0 / $f2  ---- $f6 = x / estimativa
	add.d	$f6, $f6, $f2		# $f6 = $f6 + $f2 ---- $f4 = resultado linha de cima + estimativa
	div.d	$f2, $f6, $f4		# $f2 = $f6 / $f4 ---- $f2 = resultado linha de cima /2
	addi	$t1, $t1, 1		# $t2 = $t2 + 1 ----
	bne	$t1, $t0, Loop		# Enquanto o número de loops for diferente de n, continua loop
	
	# mov.d	$v0, $f2  resolver como fazer esse retorno pelo registrador certo	
	
	jr	$ra

exit:
	la	$t2, resultado		#lembrar: resultado salvo em $f2
	sdc1	$f2, 0($t2)
	
# calculando resposta com a função sqet.d

	la	$t0, x			# $t0 =  endereço de x
	ldc1	$f0, 0($t0)		# $f0 = valor de x 
	sqrt.d	$f4, $f0		# $f0 = raiz quadrada de x
	
# calculando erro absoluto:

	sub.d	$f6, $f4, $f2
	abs.d	$f6, $f6		#$f6 = erro absoluto
	

