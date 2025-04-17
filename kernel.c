#include "stdlib.h"

void kernel_main(void)
{
    clear_screen();
    puts("Hello from simple OS!\n");

    puts("Press key to switch to graphics mode...");
    getkey();

    set_graphics_mode();      // VGA Mode 13h (320×200)
    putc_graphic(10, 10, 12); // gelber Pixel an (10,10)
    puts_graphic("Grafikmodus aktiv!\n", 20, 50, 15);

    while (1)
    {
        char c = getkey();
        if (c == 't')
        {
            set_text_mode();
            clear_screen();
            puts("Zurueck im Textmodus.\n");
            break;
        }
    }

    for (;;)
        __asm__("hlt");
}
