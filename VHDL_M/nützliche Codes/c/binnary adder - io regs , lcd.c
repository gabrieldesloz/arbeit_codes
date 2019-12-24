/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"

// rotina para escrever no LCD
void lcd_display(int a, int b);


//rotina para leitura e escrita em regostradpres
int main()
{
	int value, value2;
	// armazena caracteres
	static alt_u8 segments[16] = {
		0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90, /* 0-9 */
		0x88, 0x83, 0xc6, 0xal, 0x86, 0x8e /* A-F */
	}; //


	while(1) {
		value = IORD_ALTERA_AVALON_PIO_DATA(PIO_SW_BASE);
		value2 = IORD_ALTERA_AVALON_PIO_DATA(PIO_SW1_BASE);
		IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE, value);
		IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED1_BASE, value2);
		//-----------------------
		IOWR_ALTERA_AVALON_PIO_DATA(PIO_HEX6_BASE, segments[value%10]);
		IOWR_ALTERA_AVALON_PIO_DATA(PIO_HEX7_BASE, segments[value/10]);

		IOWR_ALTERA_AVALON_PIO_DATA(PIO_HEX4_BASE, segments[value2%10]);
		IOWR_ALTERA_AVALON_PIO_DATA(PIO_HEX5_BASE, segments[value2/10]);

		IOWR_ALTERA_AVALON_PIO_DATA(PIO_HEX0_BASE, segments[(value+value2)%10]);
		IOWR_ALTERA_AVALON_PIO_DATA(PIO_HEX1_BASE, segments[(value+value2)/10]);

		lcd_display(value2, value);

	}

	return 0;
}

//rotina para acessar o lcd
  void lcd_display(int a, int b) {
	FILE *pLCD;

	char text[32];
	sprintf(text, " %d + %d = %d   \r", a, b, a+b);

	pLCD = fopen(LCD_0_NAME, "w");

	if (pLCD) {
		fwrite(text, 32, 1, pLCD);
		fclose(pLCD);
	} else {
		printf("Failed to display\n");
	}
}


