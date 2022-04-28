addi t0,zero,2
addi t1,zero,2
add t0,t1,t2
addi t1,zero,4
error_1 : bne t1,t0,error_1
sw t1,0(zero)
lw t2, 0(zero)
error_2 : bne t2,t0,error_2
addi t3 , zero,3
add t4,zero,t3
jal Funcion
lui t5 , 0x1CA1B
fin: j fin

Funcion:
addi t0,zero,2
jr ra