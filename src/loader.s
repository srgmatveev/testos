.set MAGIC, 0x1badb002
.set FLAGS, (1<<0 | 1<<1)
.set CHECKSUM, -(MAGIC + FLAGS)
.section multiboot
    .long MAGIC
    .long FLAGS
    .long CHECKSUM
.section .text
.extern kernelMain
.extern initializeConstructors
    .global loader
loader:
    mov $kernel_stack, %esp
    push %eax # magic number
    push %ebx # multiboot structure ref
    call initializeConstructors
    call kernelMain

_stop:
    cli
    hlt
    jmp _stop

.section .bss
.space 2*1024*1024 #2Mib
kernel_stack:
