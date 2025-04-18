@echo off
set NASM=nasm.exe
set CC=i686-elf-gcc.exe
set LD=i686-elf-ld.exe
set OBJCOPY=i686-elf-objcopy.exe
set QEMU=qemu-system-i386.exe

rem 1) Assemble bootloader (as flat binary!)
%NASM% -f bin -o bootloader.bin bootloader.asm
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

rem 2) Compile kernel to object
%CC% -ffreestanding -m32 -c kernel.c -o kernel.o
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

rem 3) Link kernel to flat binary
%LD% -m elf_i386 -T linker.ld -o kernel.elf kernel.o
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

rem 4) Extract kernel binary
%OBJCOPY% -O binary kernel.elf kernel.bin
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

rem 5) Concatenate bootloader + kernel
copy /b bootloader.bin + kernel.bin os-image.bin > nul

rem 6) Run in QEMU
%QEMU% -drive format=raw,file=os-image.bin
