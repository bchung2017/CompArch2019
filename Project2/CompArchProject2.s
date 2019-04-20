/*Brian Chung and Tiffany Yu
 --  CompArchProject2_cleaned.s --
 Prompts the user to input a textfile with integers that they want to be sorted from least to greatest. The code sorts the numbers in numeric order and then prints the sorted file in another file.*/


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
//Array that has enough space since each integer can be at most 32 bits

.balign 4
sortedoutput:
        .asciz "%d\n"
//Format specifier for decimal value to print decimal value to output file

.balign 4
fileopened: 
        .word 32
//Stores the decimal value read from the input file        
 
.balign 4
message1:
        .asciz "Please type in name of the input file (30 characters or less): "
//message that prompts the user to input the name of the file they want to sort

.balign 4
errormessage1:
        .asciz "Your specified filename doesn't exist!\n"
//error message if filename doesn't exist

.balign 4
inputfileread:
        .asciz "%s"
//scans the file that is being read

.balign 4
inputfilename:
        .skip 120
//stores the string of the filename 

.balign 4
inputfilecommand:
        .asciz "r"
//specifies that the command is to read the file

.balign 4
inputfile:
        .word 0
//Stores the __FILE type used to indicate where fscanf reads from
        
.balign 4
outputfile:
        .word 0
//Stores the __FILE type used to indicate where fprintf prints to
        
.balign 4
outputfilename:
        .asciz "sortedoutput.txt"
//name of text file that the sorted output will be printed to

.balign 4
outputfilecommand:
        .asciz "w"
//specifies that the command is to write to a file

.balign 4
outputfilemessage:
        .asciz "The sorted list has been stored in 'sortedoutput.txt'\n"
 //prompt tells the user where to find the sorted list
 
.text
.global main
//initializes registers and loops
main:
    ldr r1, address_of_return //loads the return address to r1
    str lr, [r1]                                //stores r1 into  a  link register
    mov r6, #0                                  //inializes r6 as a counter with zero
    b getinputfile                              //breaks the  loop and starts t he getinput file

//This function reads which textfile the user wants to sort
getinputfile:
    ldr r0, address_of_message1                 //loads the address of message1
    bl printf                                   //prints the first  message
    
    ldr r0, address_of_inputfileread            //loads the address of the input file that the user wants to read
    ldr r1, address_of_inputfilename            //loads the address of the input file name that the  user wants  to read
    bl scanf                                    //the filename string is scanned
    
    ldr r0, address_of_inputfilename            //loads the address of the input file name that the  user wants  to read
    ldr r1, address_of_inputfilecommand         //loads the address file command
    ldr r5, address_of_character_read
    bl fopen                                    //opens the file
    cmp r0, #0                                  //compares if r0 is equal to 0  to  see  if there  is nothing in  the  file
    beq error1                                  //branches  to  the error1 loop
    ldr r1, address_of_inputfile                //if there is no error then  the address of the input file is loaded
    str r0, [r1]                                //the address is then stored into a link register
    b fileread                                  //the  loop is broken and it goes to the fileread loop

//This function is a error message is printed if the user inputs an incorrect file
error1:
    ldr r0, address_of_errormessage1            //loads the address of the error message1
    bl printf                                   //prints out the error message1
    b getinputfile                              //loops back to the getinputfile loop

//This function reads the file and places each line in the text file into an array 
fileread:
    cmp r6, #100                                //if the array is larger than 100, it is then sorted so any file greater than 100  lines aren't accepted
    bgt sortloop                                //if it is greater than 100,  the array is sorted

    ldr r0, address_of_inputfile                //loads the address of the input file
    ldr r0, [r0]
    ldr r1, address_of_scan_pattern             //loads the addrss of the scan pattern
    ldr r2, address_of_fileopened               //loads the address  of the file opened
    bl fscanf                                   //scans the content of the file
    
    cmp r0, #4294967295                         //Checks if EOF is returned by fscanf, which is -1 
    beq sortloop                                //If EOF is checked, it is then sorted
    ldr r1, address_of_fileopened               //loads the address of the file opened
    ldr r1, [r1]                                //loads the register
    str r1, [r5]                                //stores the register into a link register and stores the file content into an  array
    add r5, r5, #32                             //shifts the array so each line  is  saved as its own  element in the array   
    add r6, r6, #1                              //increments the counter by 1 to keep track of how big the array is
    b fileread                                  //branches to the file read loop
    
//This function sorts the array in numeric ascending order using bubble sort 
sortloop:
    ldr r0, address_of_character_read           //Address  of character  read is loaded
    sub r6, r6, #1                              //r6 is size of the array, and is 1 larger than it should be
    mov r8, r6                                  //size of array
    mov r9, #0                                  //i = 0
    outerloop:
        cmp r9, r8                              //Compare if i < length (array size)
        bge exit1                               //if the size of the array  is too big, the  code will  exit
        sub r10, r9, #1                         // r10 = j, j = i - 1
        innerloop:
            cmp r10, #0                         //sees if there is anything in the array
            blt exit2                           //branches to exit2 if there is nothing in the array
            lsl r3, r10, #5                     //r3 stores modified r10 to iterate properly through memory      
            add r4, r0, r3                      //r4 is the address of v[j]
            ldr r5, [r4]                        //r5 = v[j]
            add r4, r4, #32                     //looks at the next element, which is at most 32 bits
            ldr r7, [r4]                        //r7 = v[j+1]
            cmp r5, r7                          //compares the two values to see if the first is less than the second
            ble exit2                           //if there  is no swap necessary, branches to exit2
            ldr r0, address_of_character_read   //loads the address  of  character read
            mov r1, r10                         //moves r10 to r1
            bl swap                             //branches to swap loop if the first term is greater than the second
            sub r10, r10, #1                    //subtracts 1 from r10
            b innerloop                         //branches to the innerloop loop
            
//This function is branched to if no swap is necessary. The counter is incremented by one and the next elements are compared
    exit2:
        add r9, r9, #1                          //i++
        b outerloop                             //branches to the outerloop
        
//This function is branched to if the array is finished sorting. It preps the registers to print to the output file and branches to function fileoutput
    exit1:   
        mov r6, #0                              //resets the counter back to 0
        ldr r5, address_of_character_read       //loads  the address of the character read
        ldr r0, address_of_inputfile            //loads __FILE inputfile to clear stream
        ldr r0, [r0]                            //dereferences r0 to get the __FILE type 
        bl fclose                               //closes the input file 
        ldr r0, address_of_outputfilename       //loads the address of  the output file name
        ldr r1, address_of_outputfilecommand    //loads the  address  of the output file command
        bl fopen                                //opens the file
        ldr r1, address_of_outputfile           //loads the address of the output file into the register
        str r0, [r1]                            //stores the address into the register
        b fileoutput                            //exits to the fileoutput loop

//This functions swaps the current element with the following one
swap:
    lsl r3, r1, #5                              //shifts the array to look  at  the next element (2^5 = 32, which is the size of each array element)
    add r3, r0, r3                              //adds the two registers together
    
    ldr r5, [r3]                                //loads the incrementation into the register
    ldr r6, [r3, #32]                           //loads the incrementation into the register
    
    str r5, [r3, #32]                           //stores the incrementation into the register
    str r6, [r3]                                //stores the incrementation into the register
    bx lr

//Thie function writes the output into a seperate text file called sortedoutput.txt
fileoutput:
    cmp r6,r8                                   //compares the counter to r8
    beq end                                     //if it is equal that means the array is finished being written to the file
    ldr r0, address_of_outputfile               //loads the address  of the output file
    ldr r0, [r0]
    ldr r1, address_of_sortedoutput             //loads the address of the sortedoutput
    ldr r2, [r5]                                //loads the address of the array
    add r5, r5, #32                             //looks at the next element of the array
    bl fprintf                                  //writes the sorted output into another file
    add r6, r6, #1                              //increments the counter by 1
    b fileoutput                                //reiterates the file output loop

//Terminates the program 
end:

    ldr r0, address_of_outputfilemessage        //loads the address of the output file message
    ldr r0, [r0]                                //dereferences r0 to get the __FILE type 
    bl fclose                                   //closes the output file 
    bl printf                                   //prints the outputted file message where the output can  be found
    ldr lr, address_of_return                   //loads the address of return
    ldr lr, [lr]                                //loads the register
    bx lr                                       //exits the code
    

//Addresses of each .data item  
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

//C functions that are referenced
.global printf
.global scanf
.global fopen
.global fscanf
.global fprintf
