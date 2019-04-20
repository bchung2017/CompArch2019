.data

.balign 4
message1:
        .asciz "Please type in something less than 10 characters long: "
        
.balign 4
return:
        .word 0
       
       
.text
.global main
main:
    ldr r1, address_of_return
    str lr, [r1]
    
    ldr r0, address_of_message1
    bl printf
    
    ldr lr, address_of_return
    ldr lr, [lr]
    bx lr 
    
    
    
    
address_of_return : .word return
address_of_message1 : .word message1

.global printf
.global scanf