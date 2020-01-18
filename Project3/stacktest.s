.data
.balign 4
return:
	.word 0

.balign 32
float:
    .skip 640

.balign 4
print:
	.asciz "%s\n"

.balign 4
string1:
    .asciz "3.1415968"
    
.balign 4
string2:
    .asciz "world"
    
    
.text
.global main
main:
    ldr r6, [r1, #4]
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
address_of_float : .word float
address_of_print : .word print
address_of_string1: .word string1
address_of_string2 : .word string2

.global printf