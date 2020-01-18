.data
.balign 4
return:
	.word 0

.balign 4
print:
	.asciz "%f\n"
    
.balign 4
number:
    .asciz "4.30"



.text
.global main
main:
    mov r6, [r1, #4]
	ldr r1, address_of_return
	str lr, [r1]
    /*
    ldr r0, address_of_number
    bl atof
    vcvt.f64.f32 d0, s0
    vmov r2, r3, s0, s1
    */
    mov r1, r6
	ldr r0, address_of_print
	bl printf
	ldr lr, address_of_return
	ldr lr, [lr]
	bx lr
    

    


address_of_return : .word return
address_of_print : .word print
address_of_number : .word number

.global printf
.global atof