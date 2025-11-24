section .data
    text db "Hello world!", 0       ; null-terminated string

section .bss
    ; nothing needed

section .text
    global _start

; -----------------------------------------
; int count_chars(const char *str)
; ECX = count
; -----------------------------------------

_start:
    mov esi, text       ; esi = pointer to string
    xor ecx, ecx        ; ecx = count = 0

count_loop:
    mov al, [esi]       ; load character into AL
    cmp al, 0           ; is it the null terminator?
    je done             ; yes -> exit loop

    inc ecx             ; count++
    inc esi             ; move to next char
    jmp count_loop      ; repeat loop

done:
    ; ECX contains the length (same as C return value)

    ; exit program
    mov eax, 1          ; sys_exit
    int 0x80
