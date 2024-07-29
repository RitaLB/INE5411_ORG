.data
resultado : .word 0

.text

li	$t0, 1
li	$s0, 0

Loop_somatorio:
	
	add	$s0, $s0, $t0
	addi,	$t0, $t0, 1
	
bne	$t0, 6, Loop_somatorio

la	$t1, resultado
sw	$s0, 0($t1)

