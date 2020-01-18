.data
//return stores the return address to end the program
.balign 4
return:
	.word 0

//format specifier to print the final output
.balign 4
print:
	.asciz "%f\n"
    
//format specifier to read in the string
.balign 4
stringscanf:
    .asciz "%s"

//Infix is the array the stores the expression, separated into operators and operands
.balign 8
infix:
    .skip 3200
    
//Postfix stores the operators and operands in reverse polish notation
.balign 8
postfix:    
    .skip 3200
    
//Input stores the inline string expression
.balign 4
input:
    .skip 320


.text
.global main

//Loads the string from argv[1], which is stores in [r1, #4], using sscanf
main:
    ldr r4, address_of_return
	str lr, [r4]   
    
    ldr r0, [r1, #4]
    ldr r1, address_of_stringscanf
    ldr r2, address_of_input
    bl sscanf

    
    
    ldr r0, address_of_input
    ldr r2, address_of_infix
    ldr r3, address_of_infix 
    
    mov r5, #0
    mov r6, #0
    b scannext
 
/*
INPUT TO INFIX CONVERSION:
The following functions will split up the input string into distinct strings in the infix array
Each element is an operator or an operand

Register guide for Input to Infix:
r0: stores address of the character byte being read in

r2: store address of infix array, and tells where to store the next character byte 
r3: temp register that only stores the address at the beginning of each element in infix, used to 'realign' r5 to the start of each element
r4: stores the character byte read in from [r0]

r5: used to store conditional statement results
r6: used to store conditional statement results
*/

scannext:
    ldrb r4, [r0], #1
    cmp r4, #0
    beq infix2postfixsetup
    mov r6, #0
    
    //Check if symbol is an operator 
    cmp r4, #42                     //'*' comparison
    moveq r6, #1
    cmp r4, #43                     //'+' comparison
    moveq r6, #1
    cmp r4, #45                     //'-' comparison
    moveq r6, #1    
    cmp r4, #47                     //'/' comparison
    moveq r6, #1 
    cmp r4, #40
    moveq r6, #1
    cmp r4, #41
    moveq r6, #1


    cmp r6, #0                      //If r4 is a number, then branches to number storing function
    beq storenumber
    cmp r5, #1                      //If r4 is an operator, then branches according to location of operator
    beq storeoperator               //If operator follows a number, then branches to storeoperator
    bne store_singleoperator        //If operator follows another operator or is at the beginning of the expression, branches to store_singleoperator
  
  
//storenumber loops through address_of_infix to store the operand character in the infix array
storenumber:
    strb r4, [r2], #1
    mov r5, #1
    b scannext

//storeoperator iterates to the next index of the infix array, stores the operator, then iterates to the next index 
storeoperator:
    add r3, r3, #8
    mov r2, r3
    strb r4, [r2], #1
    add r3, r3, #8
    mov r2, r3
    mov r5, #0
    b scannext

//store_singleoperator stores the character byte into the infix aarray, then iterates to the next index 
store_singleoperator:
    strb r4, [r2], #1
    add r3, r3, #8
    mov r2, r3
    b scannext


/*
INFIX TO POSTFIX CONVERSION:

After the input expression is split up into separate elements that are distinct operators and operands,
the infix array is rearranged into the postfix array to represent reverse polish notation.
This conversion is done by examining each operator and operand read in, and using a stack to rearrange the order.
Reverse polish notation will then enable use of the stack to easily evaluate the expression using a stack

Register guide:
r0 is address of the infix array 
r1 stores the first character of each infix array element, which indicates if that element is an operand or operator

r3 is the address of the new postfix array, where the elements will be arranged in reverse polish notation
r2 is also the postfix address, is a copy so that the address can be referenced when incremented so that r3 is the
address of the start of each element in the postfix array

r4 is used as a temp register to store each byte read in from the infix array, when an infix element is transferred to the postfix array
r5 is used as a temp register
r6 is also used as a temp register 
r1 hold the byte read in from infix
*/

infix2postfixsetup:
    ldr r0, address_of_infix
    ldr r8, address_of_infix
    ldr r2, address_of_postfix
    ldr r3, address_of_postfix
    mov r5, sp
    push {r11, lr}
    b infix2postfix
     
//infix2postfix reads in the first byte of the infix array element
infix2postfix:              
    ldrb r1, [r0]  
    b infix2postfixend
    
//Checks if character loaded is a null character. 
//If the character is null, that means the end of the infix array is reached and the program flushes the rest of the stack to the postfix array
//If the character is not null, then the program branches to other functions that read in the infix array element into the stack or the postfix array according to conditional statements 
infix2postfixend:
    cmp r1, #0
    bne add_number
    beq flush_stack
    
//Loops through the remaining elements of the stack and stores them into the postfix array   
flush_stack:
    pop {r4}                //If null character is read in, then flush stack to postfix expression
    cmp r4, #0
    beq postfixeval_setup
    str r4, [r3], #8
    b flush_stack
    
//If the byte read in is a number, then the program branches to load_number1 since a while loop is required to read in all bytes of the number string to the postfix array
//Checks if the byte read in is a number by checking if its ASCII value is within the right range
add_number:                 //Checks if byte read in is a number
    cmp r1, #46
    moveq r4, #0
    beq load_number1
    cmp r1, #48
    blt left_parenthesis
    cmp r1, #57
    bgt left_parenthesis
    mov r4, #0
    b load_number1

//A while loop that transfers each byte of the string from the infix array to the postfix array 
load_number1:                //loads the number string byte by byte to postfix expression with a while loop
    ldrb r4, [r0], #1
    cmp r4, #0
    beq infix2postfix_increment2
    strb r4, [r3], #1
    b load_number1
    
//Checks if the byte read in is a left parenthesis
//If so, pushes in the left parenthesis
left_parenthesis:
    cmp r1, #40
    bne right_parenthesis
    push {r1} 
    b infix2postfix_increment1
    
//Checks if the byte read in is a right parenthesis
//If the byte is a right parenthesis, branches to operators2postfix
//operators2postfix loops through the stack and pops the existing operators in the stack into the postfix array until a left parentheses is detected
//Once all operators are read in, the left parenthesis remaining is discarded 
right_parenthesis:
    cmp r1, #41
    bne operator
    
    b add_operators2postfix
add_operators2postfix:
    ldr r4, [sp]
    cmp r4, #40
    beq discard_left_parenthesis
    
    pop {r6}
    strb r6, [r3], #8
    add r2, r2, #8
    b add_operators2postfix
discard_left_parenthesis:
    pop {r6}
    b infix2postfix_increment1

//Checks if the byte read in is an operator
//Branches to push_operator if byte is an operator
operator:
    cmp r1, #42             //'*' comparison
    beq push_operator
    cmp r1, #43             //'+' comparison
    beq push_operator
    cmp r1, #45             //'-' comparison
    beq push_operator  
    cmp r1, #47             //'/' comparison
    beq push_operator
        
    b infix2postfix_increment1

//push_operator checks if top element of the stack is left parenthesis or is empty 
//If the top stack element is a left parenthesis or is empty, the operator is pushed to the stack
//Else, the program branches to pop_operator
push_operator:
    ldr r4, [sp]
    
    cmp r4, #0
    bne pop_operator
    
    cmp r4, #41
    bne pop_operator
    
    push {r1}
    b infix2postfix_increment1

/*
pop_operator pops the operators in the stack to the postfix array as long as these 3 conditions are met:
1. stack is not empty
2. top of stack is not a left parenthesis 
3. precedence of operator at top of the stack >= precedence of operator that was read in 

r5 and r6 hold the precedence values for each operator so that precedence can be compared
*/
pop_operator:
    ldr r4, [sp]
    cmp r4, #0
    beq push_lastoperator
    cmp r4, #40
    beq push_lastoperator
    
    //Map the operator that was read-in to values that align with MDAS precedence
    cmp r1, #42             //'*' comparison
    moveq r5, #4
    cmp r1, #47             //'/' comparison
    moveq r5, #3
    cmp r1, #43             //'+' comparison
    moveq r5, #2
    cmp r5, #45             //'-' comparison
    moveq r1, #1
    
    //Map value at top of stack to values that align with MDAS precedence
    cmp r4, #42             //'*' comparison
    moveq r6, #4
    cmp r4, #47             //'/' comparison
    moveq r6, #3
    cmp r4, #43             //'+' comparison
    moveq r6, #2
    cmp r4, #45             //'-' comparison
    moveq r6, #1
    
    //Compares the precedence values to see if program should stop popping values from the stack 
    cmp r5, r6
    bgt push_lastoperator
    pop {r7}
    strb r7, [r3], #8
    add r2, r2, #8
    b pop_operator
    
push_lastoperator:
    push {r1}
    b infix2postfix_increment1
  
//increments the address_of_infix so that the next byte is read in
infix2postfix_increment1:
    add r8, r8, #8
    mov r0, r8 
    b infix2postfix
   
//increments the address_of_postfix so that the next element is read into the correct spot
//only needed sometimes because elements are not added to postfix with every loop iteration
infix2postfix_increment2:  
    add r2, r2, #8
    mov r3, r2
    b infix2postfix_increment1
 
/*
POSTFIX EVALUATION:

Now that the operands and operators are stored in reverse polish notation in the postfix array, the expression can be evaluated easily.
If an operand is read in from postfix, it is pushed to the stack.
If an operator is read in, the top 2 operands stored on the stack are popped out and are evaluated according the to operator.
The result is then pushed back into the stack.
After the program iterates through the entire postfix array, the stack is popped. This value is the final value.

This is also where the float conversion occurs. The operand strings are converted to single-precision floats using atof().
Then the Floating Point Unit (FPU) Architecture VFPV3 is then used to carry out floating-point operations.
All values pushed to the stack in this portion of the code are floats, so only vpush and vpop are used. 

Register guide:
r1 stores the first character of each infix array element, which indicates if that element is an operand or operator
r6 is the address of the new postfix array, where the elements will be arranged in reverse polish notation

s0 holds the first single-precision float value popped from the stack
s1 holds the second single-precision float value popped from the stack
s3 hold the float result after each operation is completed
*/ 
postfixeval_setup:
    mov r1, #0
    ldr r5, address_of_postfix
    ldr r6, address_of_postfix
    b postfix_eval
    
postfix_eval:
    ldrb r1, [r6]   
    cmp r1, #0
    beq end
    b push_operand 

postfix_eval_increment:
    add r6, r6, #8
    b postfix_eval
    
push_operand:
    cmp r1, #48
    blt eval_operator
    cmp r1, #57
    bgt eval_operator
    
    mov r0, r6
    bl atof
    vcvt.f32.f64 s0, d0
    vpush {s0}
    b postfix_eval_increment
   
eval_operator:
    vpop {s0}
    vpop {s1}
    cmp r1, #42             //'*'
    vmuleq.f32 s3, s0, s1
    cmp r1, #47             //'/' comparison
    vdiveq.f32 s3, s1, s0
    cmp r1, #43             //'+' comparison
    vaddeq.f32 s3, s0, s1 
    cmp r1, #45             //'-' comparison
    vsubeq.f32 s3, s1, s0  
    
    vpush {s3}
    b postfix_eval_increment
   
/*
PRINTING RESULT:
The remaining value on the stack is popped into s2
Since printf only accepts double float as a parameter, s2 must be converted to a double using fcvtds
Then the double stored in d1 is moved to the ARM registers r1 and r2 so that the float value can be printed.
*/
end:
    mov r2, #0
    mov r3, #0
    vpop {s2}
    fcvtds d1, s2
    vmov r1, r2, d1
    ldr r0, address_of_print
    bl printf
    
	ldr lr, address_of_return
	ldr lr, [lr]
	bx lr
     


address_of_return : .word return
address_of_print : .word print
address_of_infix : .word infix
address_of_postfix : .word postfix
address_of_input : .word input 
address_of_stringscanf : .word stringscanf

.global printf
.global atof 
.global sscanf
