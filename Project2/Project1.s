.data

.balign 4
message1:
        .asciz "Please type in something less than 10 characters long: "

.balign 4
message2:
        .asciz "Please type in something else that is less than 10 characters long: "

.balign 4
scan_pattern:
        .asciz "%c"

.balign 4
character_read:
        .word 0

.balign 4
concat: .skip 400

.balign 4
return:
        .word 0

.balign 4
print:
	.asciz "\nOutput: %c\n"

.balign 4
printchar:
	.asciz "%c"

.balign 4
printnewline:
	.asciz "\n"

.text
.global main
 main:
        mov r8, #0 /* r3 <-- #0 */
        mov r9, #0
        ldr r1, address_of_return
        str lr, [r1]

        ldr r0, address_of_message1
        bl printf

	ldr r5, address_of_concat
	ldr r6, address_of_concat

loop:
        add r8, r8, #1 /* r3 <-- r3 + 1 */
        cmp r8, #10 /* comparing r3 to 10 */
        bgt greater
        ldr r0, address_of_scan_pattern
        ldr r1, address_of_character_read
        bl scanf

	ldr r0, address_of_print
        ldr r1, address_of_character_read
        ldr r1, [r1]
	cmp r1, #10
	beq prompt2
	str r1, [r5], #4
        //bl printf
        b loop

prompt2:
	ldr r0, address_of_message2
	bl printf

loop2:
        add r9, r9, #1 /* r3 <-- r3 + 1 */
        cmp r9, #10 /* comparing r3 to 10 */
        bgt greatersecond

        ldr r0, address_of_scan_pattern
        ldr r1, address_of_character_read
        bl scanf

	ldr r0, address_of_print
        ldr r1, address_of_character_read
        ldr r1, [r1]
	cmp r1, #10
	beq prompt3
	str r1, [r5], #4
	//bl printf
        b loop2

prompt3:
	str r1, [r5]
	mov r6, #0
	ldr r5, address_of_concat

printloop:
	add r6, r6, #1
	cmp r6, #10
	beq end

	ldr r0, [r5]
	bl putchar
	add r5, r5, #4
	b printloop


end:
        //ldr r0, address_of_character_read
        //ldr r0, [r0]

	ldr r0, address_of_printnewline
	bl printf
        ldr lr, address_of_return
        ldr lr, [lr]
	//mov r0, #10
	//bl putchar
        add r0, r8, r9
	sub r0, r0, #2
        bx lr 

greater:
        mov r0, #21

	ldr lr, address_of_return
	ldr lr, [lr]
        bx lr 

greatersecond:
        mov r0, #22

	ldr lr, address_of_return
	ldr lr, [lr]
        bx lr

address_of_message1 : .word message1
address_of_message2 : .word message2
address_of_scan_pattern : .word scan_pattern
address_of_character_read : .word character_read
address_of_concat : .word concat
address_of_return : .word return
address_of_print : .word print
address_of_printchar : .word printchar
address_of_printnewline : .word printnewline

.global printf
.global scanf
.global putchar
