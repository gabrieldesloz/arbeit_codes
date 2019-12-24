#include <stdio.h>
#include <stdlib.h>
#include "system.h"
#include "io.h"
#include "alt_types.h"




/***********************************************************************
* global variables
***********************************************************************/
alt_u32 input[3] = {1,20,65}; //-- ordem ascendente

int quo = 0;
int rema = 0;


/***********************************************************************
* declaração de funções
***********************************************************************/
// rotina para escrever no LCD
void lcd_display(int a, int b);
static void hw_divider_isr(void* context, alt_u32 id);





int main(){


	// registrando ISR
	alt_irq_register(DIVIDER_NIOS_INTERFACE_0_IRQ, NULL, hw_divider_isr);


	while(1) {

        // -- leitura e escrita em registradores -

        // endereçamento de 4 em 4 bytes
		IOWR(DIVIDER_NIOS_INTERFACE_0_BASE,0, input[2]); //-- endereço 0 - carrega numerador
		IOWR(DIVIDER_NIOS_INTERFACE_0_BASE+4,0, input[1]); //-- endereço 1 - carrega denominador
		IOWR(DIVIDER_NIOS_INTERFACE_0_BASE+8,0, input[0]); //-- endereço 2 - inicia

		// -- espera ready --caso nao haja interrupt
		//while(IORD(DIVIDER_NIOS_INTERFACE_0_BASE+8,0) != 0x01); //-- espera o ready no endereço 3
		//quo  = IORD(DIVIDER_NIOS_INTERFACE_0_BASE,0); //-- joga o valor do quociente no endereço base
		//rema = 0;

	}
	return 0;
}


//rotina para acessar o lcd
  void lcd_display(int a, int b) {
	FILE *pLCD;

	char text[32];
	sprintf(text, "   %d + %d = %d  \r", a, b, a+b);

	pLCD = fopen(LCD_0_NAME, "w");

	if (pLCD) {
		fwrite(text, 32, 1, pLCD);
		fclose(pLCD);
	} else {
		printf("Failed to display\n");
	}
}

  /***********************************************************************
   * ISR -- HW_DIVIDER
   ***********************************************************************/
   static void hw_divider_isr(void* context, alt_u32 id)
   {
     /* clear current interrupt condition */
	 /* Primeiro limpar flag para que o processador saia do modo de interrupt  */
     IOWR(DIVIDER_NIOS_INTERFACE_0_BASE+12,0,1); // no hdl - endereço 3 - sinal clear_dco_flag


	 /* function */
	 lcd_display( IORD(DIVIDER_NIOS_INTERFACE_0_BASE+16,0),  IORD(DIVIDER_NIOS_INTERFACE_0_BASE+20,0)  ); // lê quociente e resto


   }



