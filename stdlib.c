#include "stdlib.h"

/* = Textmodus = */
volatile uint16_t *VGA = (uint16_t *)0xB8000;
int cursor = 0;

void clear_screen(void)
{
    for (int i = 0; i < 80 * 25; i++)
        VGA[i] = ' ' | (0x07 << 8);
    cursor = 0;
}

void putc(char c)
{
    if (c == '\n')
    {
        cursor += 80 - (cursor % 80);
    }
    else
    {
        VGA[cursor++] = c | (0x07 << 8);
    }
}

void puts(const char *s)
{
    while (*s)
        putc(*s++);
}

char getkey(void)
{
    /* BIOS Int16h real-mode geht nicht in Protected Mode.
       Stattdessen pollen wir PS/2-Controller: */
    while (!(inb(0x64) & 1))
        ;
    return inb(0x60);
}

/* = Grafikmodus = */
void set_graphics_mode(void)
{
    /* BIOS-Interrupt Mode 13h aufrufen (funktioniert nur in real/vm86). */
    __asm__ volatile(
        "mov $0x13, %%ax\n\t"
        "int $0x10"
        : : : "ax");
}

void set_text_mode(void)
{
    __asm__ volatile(
        "mov $0x03, %%ax\n\t"
        "int $0x10"
        : : : "ax");
}

uint8_t *FB = (uint8_t *)0xA0000;
void putc_graphic(int x, int y, uint8_t color)
{
    if (x < 0 || x >= 320 || y < 0 || y >= 200)
        return;
    FB[y * 320 + x] = color;
}

void puts_graphic(const char *s, int x, int y, uint8_t color)
{
    while (*s)
    {
        putc_graphic(x++, y, color);
        s++;
        if (x >= 320)
        {
            x = 0;
            y++;
        }
    }
}
