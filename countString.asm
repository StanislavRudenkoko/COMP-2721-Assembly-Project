; ============================================================
; Program: String Length Counter
; Purpose: Counts characters in "Hello world!" and prints the count
; Architecture: x86-64 Linux
; ============================================================

section .data
    text db "Hello world!", 0          ; Define string with null terminator (12 chars + \0)

section .bss
    outbuf resb 20                     ; Reserve 20 bytes for ASCII number conversion buffer

section .text
    global _start                      ; Entry point for linker

_start:
    ; -------------------- PHASE 1: Count String Length --------------------
    mov rsi, text                      ; RSI = pointer to start of "Hello world!" string
    xor rcx, rcx                       ; RCX = 0 (initialize character counter)

count_loop:
    mov al, [rsi]                      ; AL = byte at memory address RSI (current character)
    cmp al, 0                          ; Compare AL with 0 (check if null terminator)
    je convert                         ; If AL == 0, jump to convert phase
    inc rcx                            ; RCX++ (increment character count)
    inc rsi                            ; RSI++ (move pointer to next character)
    jmp count_loop                     ; Jump back to start of loop

    ; -------------------- PHASE 2: Convert Number to ASCII --------------------
convert:
    mov rax, rcx                       ; RAX = character count (the number to convert)
    mov rdi, outbuf + 19               ; RDI = pointer to END of buffer (position 19)
    mov byte [rdi], 10                 ; Store newline character (ASCII 10) at position 19
    dec rdi                            ; RDI-- (move to position 18, start writing digits here)

convert_loop:
    xor rdx, rdx                       ; RDX = 0 (clear upper bits for division)
    mov rbx, 10                        ; RBX = 10 (divisor for extracting decimal digits)
    div rbx                            ; RAX = RAX / 10 (quotient), RDX = RAX % 10 (remainder)
    add dl, '0'                        ; DL = DL + 48 (convert digit 0-9 to ASCII '0'-'9')
    mov [rdi], dl                      ; Store ASCII digit at current buffer position
    dec rdi                            ; RDI-- (move left in buffer for next digit)
    test rax, rax                      ; Test if RAX == 0 (check if quotient is zero)
    jnz convert_loop                   ; If RAX != 0, continue loop (more digits to process)

    inc rdi                            ; RDI++ (adjust to point to first digit written)
    mov rsi, rdi                       ; RSI = pointer to start of ASCII number string

    ; -------------------- PHASE 3: Calculate String Length --------------------
    mov rdx, outbuf + 20               ; RDX = address just past end of buffer
    sub rdx, rdi                       ; RDX = length of string (end - start, includes newline)

    ; -------------------- PHASE 4: Write to stdout --------------------
    mov rax, 1                         ; RAX = 1 (syscall number for sys_write)
    mov rdi, 1                         ; RDI = 1 (file descriptor for stdout)
                                       ; RSI already contains pointer to string
                                       ; RDX already contains string length
    syscall                            ; Invoke kernel to print string

    ; -------------------- PHASE 5: Exit Program --------------------
    mov rax, 60                        ; RAX = 60 (syscall number for sys_exit)
    xor rdi, rdi                       ; RDI = 0 (exit status code: success)
    syscall                            ; Invoke kernel to exit program