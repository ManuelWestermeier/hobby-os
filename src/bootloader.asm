; ------------------------------------------------------------------
; bootloader.asm  (512 Bytes, letzter Wert 0xAA55)
; ------------------------------------------------------------------

bits 16
org 0x7E00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7E00
    sti

    ; GDT aufbauen und laden
    lgdt [gdt_descriptor]

    ; in Protected Mode schalten
    mov eax, cr0
    or  eax, 1
    mov  cr0, eax

    ; Far jump zu Protected Mode Code
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
    ; Segmente setzen
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov esp, 0x90000

    ; Direkt zu Kernel springen (laut linker.ld bei 0x7E00)
    jmp CODE_SEG:0x7E00

halt:
    cli
    hlt
    jmp halt

; Füllbytes + Signatur
times 510-($-$$) db 0
dw 0xAA55
