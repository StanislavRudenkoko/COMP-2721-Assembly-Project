section .data
    text db "Hello world!", 0

section .bss
    outbuf resb 20                     ; buffer for number

section .text
    global _start

_start:
    mov rsi, text                      ; pointer to string
    xor rcx, rcx                       ; count = 0

count_loop:
    mov al, [rsi]
    cmp al, 0
    je convert
    inc rcx
    inc rsi
    jmp count_loop

; Convert RCX to ASCII, store in outbuf
convert:
    mov rax, rcx                       ; number to convert
    mov rdi, outbuf + 19               ; write backwards
    mov byte [rdi], 10                 ; newline for nicer output
    dec rdi

convert_loop:
    xor rdx, rdx
    mov rbx, 10
    div rbx                            ; divide rax by 10
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz convert_loop

    inc rdi                             ; rdi now points to first digit
    mov rsi, rdi                        ; rsi = start of ASCII string

; compute length to print
    mov rdx, outbuf + 20
    sub rdx, rdi                        ; rdx = length of ASCII string

; write(rdi = stdout)
    mov rax, 1                          ; sys_write
    mov rdi, 1                          ; stdout
    syscall

; exit
    mov rax, 60                         ; sys_exit
    xor rdi, rdi                        ; exit code 0
    syscall
