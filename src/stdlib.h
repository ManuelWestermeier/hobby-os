#ifndef _STDLIB_H
#define _STDLIB_H

#include <stdarg.h>
#include <stdint.h>

/* Textmodus (80×25, 0xB8000) */
void clear_screen(void);
void putc(char c);
void puts(const char *s);
char getkey(void);

/* Grafikmodus (Mode 13h, 320×200, 0xA0000) */
void set_graphics_mode(void);
void set_text_mode(void);
void putc_graphic(int x, int y, uint8_t color);
void puts_graphic(const char *s, int x, int y, uint8_t color);

/* Low‐level I/O */
static inline void outb(uint16_t port, uint8_t val)
{
    __asm__ volatile("outb %0, %1" : : "a"(val), "Nd"(port));
}
static inline uint8_t inb(uint16_t port)
{
    uint8_t ret;
    __asm__ volatile("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

#endif
