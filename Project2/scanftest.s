.data

.balign 4
message1:
        .asciz "Please type in something less than 10 characters long: "
        
.balign 4
return:
        .word 0
        
.balign 4
scan_pattern:
        .asciz "%s"
        
.balign 4
print_pattern:
        .asciz "Output: %s\n"
       
.balign 4
character_read: .skip 400     
.text
.global main
main:
    ldr r1, address_of_return
    str lr, [r1]
    
    ldr r0, address_of_message1
    bl printf
    
    ldr r0, address_of_scan_pattern
    ldr r1, address_of_character_read
    bl scanf
    
    ldr r0, address_of_print_pattern
    ldr r1, address_of_character_read
    bl printf
        
    ldr lr, address_of_return
    ldr lr, [lr]
    bx lr 
    
    
    
    
address_of_return : .word return
address_of_message1 : .word message1
address_of_scan_pattern : .word scan_pattern
address_of_character_read : .word character_read
address_of_print_pattern : .word print_pattern

.global printf
.global scanf