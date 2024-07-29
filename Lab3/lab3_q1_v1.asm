.data
	x: .double 9
	n: .word 30
	d1 : .double 1
	d2 : .double 2
	resultado: .double 0
.text

	la	$a0, x 		#$a0 =  endereço de x
	la	$a1, d1		#$a1 = 1
	la	$a2, d2		#$a2 = 2
	la	$a3, n		#$a3 =  endereço de n
	
	jal 	raiz_aproximada
	
	j	exit
	
raiz_aproximada:
	ldc1	$f0, 0($a0)		# $f0 = valor de x !! antes tava l.d
	ldc1	$f2, 0($a1)		# $f2 = estimativa = 1
	ldc1	$f4, 0($a2)		# $f4 = 2
	lw	$t0, 0($a3)		##t0 = valor de n
	

	li	$t1, 0			# $t1 é o contador do loop
	
	Loop:
	div.d	$f6, $f0, $f2		# $f6 = $f0 / $f2  ---- $f6 = x / estimativa
	add.d	$f6, $f6, $f2		# $f6 = $f6 + $f2 ---- $f4 = resultado linha de cima + estimativa
	div.d	$f2, $f6, $f4		# $f2 = $f6 / $f4 ---- $f2 = resultado linha de cima /2
	addi	$t1, $t1, 1		# $t2 = $t2 + 1 ----
	bne	$t1, $t0, Loop		# Enquanto o número de loops for diferente de n, continua loop
	
	
	
	jr	$ra

exit:
	la	$t2, resultado
	sdc1	$f2, 0($t2)
	
	ldc1	$f8, 0($t2)
	
