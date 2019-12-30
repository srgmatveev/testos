#include "vga_colors.h"
#include <stddef.h>
#include <stdint.h>

/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
    #error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

#if !defined(__i386__)
    #error "This OS needs to be compiled with a ix86-elf compiler"
#endif


volatile uint16_t *vga_buffer = (uint16_t *)0xB8000; /* memory location of the VGA textmode buffer */

/* Columns and rows of the VGA buffer */
const int VGA_COLS = 80;
const int VGA_ROWS = 25;
/* We start displaying text in the top-left of the screen (column = 0, row = 0) */
int term_col = 0;
int term_row = 0;
/* term_init() : This function initiates the terminal by clearing it */
void term_init(unsigned char forecolour, unsigned char backcolour)
{
    /* Clear the textmode buffer */
    for (int col = 0; col < VGA_COLS; col++)
    {
        for (int row = 0; row < VGA_ROWS; row++)
        {
            uint16_t attrib = (backcolour << 4) | (forecolour & 0x0F);
            /* The VGA textmode buffer has size (VGA_COLS * VGA_ROWS) */
            /* Given this, we find an index into the buffer for our character */
            const size_t index = (VGA_COLS * row) + col;
            /* Entries in the VGA buffer take the binary form BBBBFFFFCCCCCCCC, where: */
            /* - B is the background color */
            /* - F is the foreground color */
            /* - C is the ASCII character */
            /* Now we set the character to blank (a space character) */
            vga_buffer[index] = ((uint16_t)attrib << 8) | ' ';
        }
    }
}

void printf(const char *str)
{
    static uint16_t *VideoMemory = (uint16_t *)0xb8000;
    for (auto i = 0; str[i] != '\0'; ++i)
    {
        VideoMemory[i] = (VideoMemory[i] & 0xFF00) | str[i];
    }
}

extern "C" void kernelMain(void)
{
    term_init(White, Blue);
    printf("Test string 32 bit starting!...");
    while (1)
        ;
}
