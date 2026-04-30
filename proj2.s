.data
prompt: .asciz "Enter int: "
fnlPrompt: .asciz "The double is: "

.bss
inputStr: .skip 16
inputInt: .skip 4
outputStr: .skip 16

.text
.global _start

_start:
    mov $4, %eax # calls syscall write
    mov $1, %ebx # std output
    mov $prompt, %ecx # move ptr prompt to ecx
    mov $11, %edx # tells computer to write 11 bytes
    int $0x80 # invoke syscalls 
    
    mov $3, %eax # calls syscall read
    mov $0, %ebx # std input
    mov $inputStr, %ecx # move inputStr address to ecx to show where to print
    mov $16, %edx # tells computer to write 16 bytes
    int $0x80 # invoke syscalls

    mov $inputStr, %esi # loads address of first char into esi
    xor %eax, %eax # eax XOR eax = 0
    strToInt:
        movb (%esi), %bl # move current char to lowest byte
        cmp $'\n', %bl # check if char == null
        je done # if null exit loop

        sub $'0', %bl # subtract char with char '0' to find numeric digit
        movzx %bl, %ebx # move bl to ebx so we can add to eax
        imul $10, %eax # multiply inputInt by 10 to push back if multiple digits
        add %ebx, %eax # add ebx to eax

        inc %esi # increment esi to next char
        jmp strToInt # loop back
    done:   
    imul $2, %eax # multiply eax by 2
    mov %eax, inputInt # move eax to inputInt

    mov inputInt, %eax # move inputInt to eax
    mov $inputStr+15, %esi # moves esi to last byte so chars can be stored backwards
    mov %esi, %edi # copies esi to edi since esi is moving backwards
    intToStr:
        xor %edx, %edx # set edx = 0
        mov $10, %ebx # ebx = 10 for div

        div %ebx # divides by ebx and stores last digit in edx
        add $'0', %dl # add '0' to dl so we can convert digit back to char
        dec %esi # decrements int backwards
        mov %dl, (%esi) # stores converted char back to esi

        cmp $0, %eax # checks if eax == 0
        jne intToStr # if not equal to cmp, return loop 
    done2:

    mov $4, %eax # syscall write 
    mov $1, %ebx # std ouput
    mov $fnlPrompt, %ecx # moves fnlPrompt address to ecx to show where to print
    mov $16, %edx # tells computer how many bytes to print
    int $0x80 # invoke syscalls 

    mov $4, %eax # syscall write
    mov $1, %ebx # std ouput
    mov %esi, %ecx # moves beginning of esi reg to ecx reg
    mov %edi, %edx # moves edi reg to edx reg for byte calculation
    sub %esi, %edx # subtracts edi by esi to find number of bytes to print
    int $0x80 # invoke syscalls
 
    mov $1, %eax # syscall exit
    xor %ebx, %ebx # ebx = 0
    int $0x80 # invoke syscalls


