section .data
    text db "Hello world!", 0

section .text
    global _start

_start:
    mov rsi, text       ; pointer to string
    xor rcx, rcx        ; counter = 0

count_loop:
    mov al, [rsi]
    cmp al, 0
    je done

    inc rcx
    inc rsi
    jmp count_loop

done:
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; exit code = 0
    syscall
