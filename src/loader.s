/* Declare constants for the multiboot header. */
.set ALIGN,    1<<0             /* align loaded modules on page boundaries */
.set MEMINFO,  1<<1             /* provide memory map */
.set FLAGS,    ALIGN | MEMINFO  /* this is the Multiboot 'flag' field */
.set MAGIC,    0x1BADB002       /* 'magic number' lets bootloader find the header */
.set CHECKSUM, -(MAGIC + FLAGS) /* checksum of above, to prove we are multiboot */

.section multiboot
    .align 4
    .long MAGIC
    .long FLAGS
    .long CHECKSUM

.section .bss
    .align 16
    kernel_stack_bottom:
        .skip 2*1024*1024 # 2 MiB
    kernel_stack_top:

.section .text
.extern kernelMain
.extern initializeConstructors
.global _start
.type _start, @function
_start:
    mov $kernel_stack_top, %esp
    push %eax # magic number
    push %ebx # multiboot structure ref
    call initializeConstructors
    call kernelMain

    cli
.hang:
    hlt
    jmp .hang

.size _start, . - _start
