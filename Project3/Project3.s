.data
.balign 4
return:
	.word 0

.balign 4
print:
	.asciz "%f\n"

.balign 32
P:
    .skip 3200


.text
.global main

postfix_eval_setup:
    ldr r5, address_of_P
    ldr r7, #0

       
/*
readnext reads operands into a stack, and evaluates the operands when an operator is detected 

r2 stores the character read from array P (operator/operand)
r3 stores the output from the expression (s4)
r4 store the current operator
r5 is the address of array P
r6 stores length of array P
r7 is a counter

s4 stores the cumulative final value
*/
readnext:
    //Check if entire array P has been iterated through
    cmp r6, r7
    beq output
    
    //Load next character from array P into r2 
    ldr r2, [r5]
    
    //Now check if character read from P is an operator
    //If character read is an operator, then perform operation
    //If not, store value in the stack, and repeat
    cmp r2, #42             //'*' comparison
    beq multiplyvalues
    cmp r2, #43             //'+' comparison
    beq addvalues
    cmp r2, #45             //'-' comparison
    beq subtractvalues      
    cmp r2, #47             //'/' comparison
    beq dividevalues
    
    
    //Push next character from array P into the stack
    str lr, [sp, #-32]
    str r2, [sp, #-32]
    b readnextloop
    
//Increment array address to next element
//CHECK IF PARAMETERS ARE BEING PASSED CORRECTLY
readnextloop:
    add r5, r5, #32          
    add r7, r7, #1
    vadd.f32 s4, s4, s0
    b readnext
 

multiplyvalues:
    ldr s0, [sp]
    add sp, sp, #32 
    ldr s1, [sp]
    add sp, sp, #32
    vmul.f32 s0, s1, s0
   
    b readnextloop
    
dividevalues:
    ldr s0, [sp]
    add sp, sp, #32
    ldr s1, [sp]
    add sp, sp, #32
    vdiv.f32 s4, s1, s0
    b readnextloop
    
    
    
    
    
    
    
    vcvt.f32.s32 s0

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
address_of_P : .word P

.global printf
