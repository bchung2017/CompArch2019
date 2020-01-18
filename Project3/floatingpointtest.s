.data
.balign 4
return:
	.word 0

.balign 4
print:
	.asciz "%f\n"



.text
.global main
main:
	ldr r1, address_of_return
	str lr, [r1]
	vmov.f32 s8, #4.0
	vmov.f32 s9, #3.0
    vmov.f32 s10, #30.0
    vmov.f32 s11, #-20.0
	vdiv.f32 s9, s9, s8
    vadd.f32 s0, s9, s10
    vsub.f32 s0, s0, s11
	vcvt.f64.f32 d1, s0
	vmov r2, r3, d1
	ldr r0, address_of_print
	bl printf
	ldr lr, address_of_return
	ldr lr, [lr]
	bx lr
    
    

multiply:
    


address_of_return : .word return
address_of_print : .word print

.global printf
