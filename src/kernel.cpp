void printf(const char *str) {
    static unsigned short *VideoMemory = (unsigned short *) 0xb8000;
    for (int i = 0; str[i] != '\0'; ++i) {
        VideoMemory[i] = (VideoMemory[i] & 0xFF00) | str[i];
    }
}

extern "C" void kernelMain(void* multiboot_structure, unsigned int magic_number) {
    printf("Test string 32 bit starting...");
    while (1);
}
