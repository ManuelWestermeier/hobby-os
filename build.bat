@echo off
REM Pfad zu MSYS2 MinGW‑32‑bit (ggf. anpassen)
set PATH=C:\msys64\mingw32\bin;%PATH%

REM 1) Bootloader assemblieren (binär, 512 Bytes)
nasm -f bin bootloader.asm -o bootloader.bin

REM 2) C‑Quellcode kompilieren (kernel + stdlib)
gcc -m32 -ffreestanding -c kernel.c  -o kernel.o
gcc -m32 -ffreestanding -c stdlib.c  -o stdlib.o

REM 3) Linken in eine flache Binär-Datei bei 0x1000
ld -m elf_i386 -T linker.ld --oformat binary \
    kernel.o stdlib.o -o kernel.bin

REM 4) Image zusammenfügen
copy /b bootloader.bin+kernel.bin os-image.bin >nul

REM 5) Image in QEMU starten
qemu-system-i386 -drive format=raw,file=os-image.bin -serial stdio
