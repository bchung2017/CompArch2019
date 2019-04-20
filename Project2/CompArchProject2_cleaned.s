.data
//Where our variables and C-function parameter will be passed through

.balign 4
return:
        .word 0
//Stores the address of the link register so program can terminate

.balign 4
scan_pattern:
        .asciz "%d"
//Format specifier for decimal input, reads in decimal values from the input text file

       
.balign 32
character_read: .skip 3200  

.balign 4
sortedoutput:
        .asciz "%d\n"

.balign 4
fileopened: 
        .word 32
        
.balign 4
message1:
        .asciz "Please type in name of the input file (30 characters or less): "
        
.balign 4
errormessage1:
        .asciz "Your specified filename doesn't exist!\n"
        
.balign 4
inputfileread:
        .asciz "%s"
          
.balign 4
inputfilename:
        .skip 120

.balign 4
inputfilecommand:
        .asciz "r"
        
.balign 4
inputfile:
        .word 0
        
.balign 4
outputfile:
        .word 0
        
.balign 4
outputfilename:
        .asciz "sortedoutput.txt"

.balign 4
outputfilecommand:
        .asciz "w"
        
.balign 4
outputfilemessage:
        .asciz "The sorted list has been stored in 'sortedoutput.txt'\n"
        
.text
.global main
main:
    ldr r1, address_of_return
    str lr, [r1]
    mov r6, #0
    b getinputfile
    
getinputfile:
    ldr r0, address_of_message1
    bl printf
    
    ldr r0, address_of_inputfileread
    ldr r1, address_of_inputfilename
    bl scanf
    
    ldr r0, address_of_inputfilename
    ldr r1, address_of_inputfilecommand
    ldr r5, address_of_character_read
    bl fopen 
    cmp r0, #0
    beq error1
    ldr r1, address_of_inputfile
    str r0, [r1]
    b fileread
    
error1:
    ldr r0, address_of_errormessage1
    bl printf
    b getinputfile

    
fileread:
    add r6, r6, #1
    cmp r6, #100
    bgt sortloop

    ldr r0, address_of_inputfile
    ldr r0, [r0]
    ldr r1, address_of_scan_pattern
    ldr r2, address_of_fileopened
    bl fscanf
    
    cmp r0, #4294967295 //EOF by fscanf (-1)
    beq sortloop
    ldr r1, address_of_fileopened
    ldr r1, [r1]
    str r1, [r5]
    add r5, r5, #32
    b fileread

sortloop:
    ldr r0, address_of_character_read //Array v
    sub r6, r6, #1          //r6 is size of the array, and is 1 larger than it should be
    mov r8, r6              //size of array
    mov r9, #0              //i = 0
    outerloop:
        cmp r9, r8          //Compare if i < length (array size)
        bge exit1
        sub r10, r9, #1     // r10 = j, j = i - 1
        innerloop:
            cmp r10, #0
            blt exit2
            lsl r3, r10, #5 //r3 stores modified r10 to iterate properly through memory      
            add r4, r0, r3  //r4 is the address of v[j]
            ldr r5, [r4]    //r5 = v[j]
            add r4, r4, #32
            ldr r7, [r4]    //r7 = v[j+1]
            cmp r5, r7
            ble exit2
            ldr r0, address_of_character_read
            mov r1, r10
            bl swap
            sub r10, r10, #1
            b innerloop
    exit2:
        add r9, r9, #1      //i++
        b outerloop
    exit1:   
        mov r6, #0
        ldr r5, address_of_character_read
        ldr r0, address_of_outputfilename
        ldr r1, address_of_outputfilecommand
        bl fopen 
        ldr r1, address_of_outputfile
        str r0, [r1]      
        b fileoutput

swap:
    lsl r3, r1, #5
    add r3, r0, r3
    
    ldr r5, [r3]
    ldr r6, [r3, #32]
    
    str r5, [r3, #32]
    str r6, [r3]
    bx lr
    
fileoutput:
    cmp r6,r8
    beq end
    ldr r0, address_of_outputfile
    ldr r0, [r0]
    ldr r1, address_of_sortedoutput
    ldr r2, [r5]
    add r5, r5, #32
    bl fprintf    
    add r6, r6, #1
    b fileoutput
    
end:
    ldr r0, address_of_outputfilemessage
    bl printf
    ldr lr, address_of_return
    ldr lr, [lr]
    bx lr 
    

    
address_of_return : .word return
address_of_message1 : .word message1
address_of_errormessage1 : .word errormessage1
address_of_inputfileread : .word inputfileread
address_of_inputfilename : .word inputfilename
address_of_scan_pattern : .word scan_pattern
address_of_character_read : .word character_read
address_of_fileopened : .word fileopened
address_of_inputfilecommand : .word inputfilecommand
address_of_sortedoutput : .word sortedoutput
address_of_inputfile : .word inputfile
address_of_outputfile : .word outputfile
address_of_outputfilecommand : .word outputfilecommand
address_of_outputfilename : .word outputfilename
address_of_outputfilemessage : .word outputfilemessage

.global printf
.global scanf
.global fopen
.global fscanf
.global fprintf