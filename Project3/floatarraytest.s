.data
.balign 4
return:
	.word 0

.balign 32
float:
    .skip 640

.balign 4
print:
	.asciz "%f\n"


.text
.global main
main:
    vmov s4, #0.0
	ldr r1, address_of_return
	str lr, [r1]
    ldr r0, address_of_float
    vmov.f32 s0, #3.5
    vmov r1, s0
    str r1, [r0]
    
    add r0, r0, #32
    vmov.f32 s0, #4.5
    vmov r1, s0
    str r1, [r0]
        
    ldr r0, address_of_print 
    ldr r5, address_of_float
    vldr s0, [r5]
    vcvt.f64.f32 d0, s0
    vmov r2, r3, d0
    bl printf
    
    ldr r0, address_of_print 
    ldr r5, address_of_float
    add r5, r5, #32
    vldr s0, [r5]
    vcvt.f64.f32 d0, s0
    vmov r2, r3, d0
    bl printf
    
    
	ldr lr, address_of_return
	ldr lr, [lr]
	bx lr
    

address_of_return : .word return
address_of_float : .word float
address_of_print : .word print

.global printf
