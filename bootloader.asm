; ------------------------------------------------------------------
; bootloader.asm  (512 Bytes, letzter Wert 0xAA55)
; ------------------------------------------------------------------

org 0x7C00
bits 16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; GDT aufbauen und laden
    lgdt [gdt_descriptor]

    ; in Protected Mode schalten
    mov eax, cr0
    or  eax, 1
    mov  cr0, eax

    jmp CODE_SEG:pm_entry

; ------------------------------------------------------------------
; GDT
gdt_start:
    dq 0
gdt_code:
    dw 0xFFFF, 0x0000
    db 0x00, 10011010b, 11001111b
    db 0x00
gdt_data:
    dw 0xFFFF, 0x0000
    db 0x00, 10010010b, 11001111b
    db 0x00
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; ------------------------------------------------------------------
bits 32
pm_entry:
    ; Segmente nachziehen
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov esp, 0x90000

    ; Kernel aufrufen
    extern kernel_main
    call kernel_main

halt:
    cli
    hlt
    jmp halt

; Füllbytes + Signatur
times 510-($-$$) db 0
dw 0xAA55
