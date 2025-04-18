@echo off
set NASM=nasm.exe
set CC=i686-elf-gcc.exe
set LD=i686-elf-ld.exe
set OBJCOPY=i686-elf-objcopy.exe
set QEMU=qemu-system-i386.exe

mkdir build >nul 2>nul

rem 1) Assemble bootloader (as flat binary!)
%NASM% -f bin -o build/bootloader.bin src/bootloader.asm
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

rem 2) Compile kernel and stdlib to object files
%CC% -ffreestanding -m32 -c src/stdlib.c -o build/stdlib.o
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

%CC% -ffreestanding -m32 -c src/kernel.c -o build/kernel.o
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

rem 3) Link kernel to ELF
%LD% -m elf_i386 -T src/linker.ld -o build/kernel.elf build/kernel.o build/stdlib.o
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

rem 4) Extract flat kernel binary
%OBJCOPY% -O binary build/kernel.elf build/kernel.bin
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

rem 5) Concatenate bootloader and kernel
copy /b build/bootloader.bin + build/kernel.bin build/os-image.bin > nul

rem 6) Run in QEMU
%QEMU% -drive format=raw,file=build/os-image.bin
