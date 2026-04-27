.data
prompt: .asciz "Enter int: "
fnlPrompt: .asciz "The double is: "

.bss
inputStr: .skip 16
inputInt: .skip 4
inputStrLen: .skip 4

.text
.global _start

_start:
    mov $4, %eax 
    mov $1, %ebx
    mov $prompt, %ecx
    mov $11, %edx
    int $0x80
    
    mov $3, %eax
    mov $0, %ebx
    mov $inputStr, %ecx
    mov $16, %edx
    int $0x80

    mov $inputStr, %esi
    mov $0, %ecx
    mov $0, %eax
    strToInt:
        movb (%esi), %bl
        cmpb $0x0A, %bl
        je done

        cmpb $0, %bl
        je done

        sub $0x30, %bl
        movzbl %bl, %ebx
        imul $10, %eax
        add %ebx, %eax

        inc %esi
        jmp strToInt 
    done:
    mov %eax, inputInt

    mov inputInt, %eax
    imul $2, %eax
    mov %eax, inputInt

    mov $inputStr, %edi
    mov $0, %ecx
    intToStr: 
        cdq
        mov $10, %ebx 
        idiv %ebx
        add $0x30, %dl
        mov %dl, (%edi)
        inc %edi
        inc %ecx
        cmp $0, %eax
        jne intToStr
    done2:
    mov %ecx, inputStrLen

    mov $4, %eax
    mov $1, %ebx
    mov $fnlPrompt, %ecx
    mov $16, %edx
    int $0x80

    mov $inputStr, %esi
    mov $inputStr, %edi
    add inputStrLen, %edi
    dec %edi

    cmp %edi, %esi
    jge Done3
    reverse:
        movb (%esi), %al
        movb (%edi), %bl 
        movb %bl, (%esi)
        movb %al, (%edi)

        inc %esi
        dec %edi

        cmp %edi, %esi
        jl reverse
    Done3:

    mov $4, %eax
    mov $1, %ebx
    mov $inputStr, %ecx
    mov inputStrLen, %edx
    int $0x80
 
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80





    
    
