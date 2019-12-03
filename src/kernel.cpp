#include <stdint.h>

void printf(const char *str) {
    static uint16_t *VideoMemory = (uint16_t*) 0xb8000;
    for (auto i = 0; str[i] != '\0'; ++i) {
        VideoMemory[i] = (VideoMemory[i] & 0xFF00) | str[i];
    }
}

extern "C" void kernelMain(void) {
    printf("Test string 32 bit starting...");
    while (1);
}
