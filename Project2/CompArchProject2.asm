.data

.balign 4
return:
        .word 0
        
.balign 4
scan_pattern:
        .asciz "%d"
        
.balign 4
print_pattern:
        .asciz "Output: %d\n"
       
.balign 32
character_read: .skip 3200     

.balign 4
fileopened: 
        .word 32
        
.balign 4
filename:
        .asciz "singleinput.txt"

.balign 4
filecommand:
        .asciz "r"
        
.balign 4
inputfile:
        .word 0
        
.text
.global main
main:
    ldr r1, address_of_return
    str lr, [r1]
    mov r6, #0
    ldr r0, address_of_filename
    ldr r1, address_of_filecommand
    ldr r5, address_of_character_read
    bl fopen 
    ldr r1, address_of_inputfile
    str r0, [r1]
    b fileread
    
    
fileread:
    add r6, r6, #1
    cmp r6, #100
    bgt end
    ldr r0, address_of_inputfile
    ldr r0, [r0]
    ldr r1, address_of_scan_pattern
    ldr r2, address_of_fileopened
    bl fscanf
    
    str r1, [r5], #32
    ldr r0, address_of_print_pattern
    ldr r1, address_of_fileopened
    ldr r1, [r1]
    bl printf    
    
    b fileread
    
end:
    ldr lr, address_of_return
    ldr lr, [lr]
    bx lr 
    
    
    
    
address_of_return : .word return
address_of_scan_pattern : .word scan_pattern
address_of_character_read : .word character_read
address_of_print_pattern : .word print_pattern
address_of_fileopened : .word fileopened
address_of_filename : .word filename
address_of_filecommand : .word filecommand

address_of_inputfile: .word inputfile
.global stoi
.global printf
.global scanf
.global fopen
.global fscanf
