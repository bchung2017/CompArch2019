    .globl  main
    .extern atof
    .extern printf
	.extern strlen
    .fpu vfp

output_str:
    .asciz     "The answer is %d\n"

error_str:
    .asciz "Error: Needs exactly one argument. %d given.\n"

    .text
    .align 4

process:
	stmfd sp!, {r4-r11,lr}
	ldr r0, [r1,#4]
	bl printf
	b R

	mov r5, r0
	mov r1, #43
	bl strchr
	mov r6, r0

	mov r0, r5
	mov r1, #45
	bl strchr
	mov r7, r0

R:	
	

    //bl      atof
    //fcpyd d7, d0
    //mov r0, #420
	ldmfd sp!, {r4-r11,pc}

main:
    push    {ip, lr}
    mov     r6,  r1 // save argv

    // Compare and check argc and error
    cmp r0, #2
    beq L1
    mov r1, r0
    sub r1, r1, #1
    ldr r0, =error_str
    bl printf
	mov r0, #1
    pop {ip, pc}

    // Else
L1:
    ldr     r0, [r6,#4] // process(argv[1])
    bl process
    mov r1, r0
    ldr     r0, =output_str
    bl      printf
    mov     r0, #0
    pop     {ip, pc}

