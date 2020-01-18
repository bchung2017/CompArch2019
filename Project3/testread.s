.text
.global main
.extern printf

.text
output_str: .ascii "the answer is %d\n\0"

test:
push {r4, lr}
add r4, r0, r1
pop {r4, pc}

main:
push {ip, lr}
mov r0, #1
mov r4, #3
bl test
mov r1, r0
ldr r0, =output_str
bl printf
mov r0, #0
pop {ip, pc}

.data 
string: .asciz "Argv: %s\n"
