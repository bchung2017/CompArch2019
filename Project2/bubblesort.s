bsort:
    //Bubble sort an array of 32bit integers in place
    //Arguments: R0 = Array location, R1 = Array size
    PUSH    {R0-R12,LR}         @ Push the existing registers on to the stack
    MOV     R4,R0               @ R4 = Array Location
    MOV     R5,R1               @ R5 = Array size
bsort_check:                   @ Check for a sorted array
    MOV     R6,#0               @ R6 = Current Element Number
bsort_check_loop:              @ Start check loop
    ADDS    R7,R6,#1            @ R7 = Next Element Number
    CMP     R7,R5               @ Check for the end of the array
    BGE     bsort_done          @ Exit method if we reach the end of the array
    LDR     R8,[R4,R6,LSL #2]   @ R8 = Current Element Value
    LDR     R9,[R4,R7,LSL #2]   @ R9 = Next Element Value
    CMP     R8,R9               @ Compare element values
    BGT     bsort_swap          @ If R8 > R9, swap
    MOV     R6,R7               @ Advance to the next element
    B       bsort_check_loop    @ End check loop
bsort_swap:                    @ Swap values
    STR     R9,[R4,R6,LSL #2]   @ Store current element at next location
    STR     R8,[R4,R7,LSL #2]   @ Store next element at current location
    B       bsort_check         @ Check again for a sorted array
bsort_done:                    @ Return
    POP     {R0-R12,PC}         @ Pop the registers off of the stack and return
    
    
 ===============
  /*   
compare:
    ldr r0, address_of_character_read
    //ldr r0, [r2] //loads the address of r0 to r0
    //ldr r1, [r3] //loads the address of r1 to r1

    //bkpt #1
    //cmp r0, #10 //compares the value of r0 to #10, which represents a new line
    cmp r6, #100
    bgt reiterate //if there is a new line detected, it means it is the end of the array and "reiterate" loop is implemented
    cmp  r0, r1 //compares the two values in the registers
    bgt swap //if r0 is greater than r1, branch to "swap" loop
    add r2, r2,  #32 //increment r0, the index of the array, by 1
    str r0, [r2] //store the new number back  into  the register
    add r3, r3, #32 //increment r1, the index of the array, by 1
    str r1, [r3]  //store the new number back  into  the register
    add r4, r4, #1 //increments the  counter by 1 each time  the compare loop is iterated
    cmp r4,#100 //compares the register to the number 100 because the array cannot be more than 100 lines
    bgt error1 //if the register is greater than 100, the loop is broken and an error message is printed
    b compare //the compare loop is reiterated
    
swap:
    mov r7, r1 //moves whatever is in r1 to r8
    mov r1, r0 //moves whatever is in r0 to r1
    mov  r0, r7 //moves whatever is in r8 to r0
    add r2, r2,  #32 //increment r0, the index of the array, by 1
    str r0, [r2] //store the new number back  into  the register
    add r3, r3, #32 //increment r1, the index of the array, by 1
    str r1, [r3]  //store the new number back  into  the register
    add r4, r4, #1 //increments the  counter by 1 each time  the swap loop is iterated
    add r9, r9, #1
    cmp r4,#100 //compares the register to the number 100 because the array cannot be more than 100 lines
    bgt error1 //if the register is greater than 100, the loop is broken and an error message is printed
    b compare //branches back to the compare loop
reiterate:
    cmp r9, #0 //compares the register that keeps  track of how many swaps takes place to go through the array once
    beq end //if there are no swaps then the loop is exited to print it out
    mov r9, #0 //resets the r9 register to 0 for the next reiteration
    mov r4, #0
    b compare //branches back to the compare loop
error1:
    //ldr r0, address_of_error1 //loads the address of the  error1 message
    //bl printf     //prints out the error1 message
    b end
end:
    add r6, r6, #64
    cmp r6, #192
    beq end2
    ldr r0, address_of_print_pattern
    ldr r1, address_of_character_read
    add r1, r1, r6
    ldr r1, [r1]
    bl printf 
    b end
    
    
*/ 