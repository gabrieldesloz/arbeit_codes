/************************************************************************
* Versão para rodar algoritmo filtro FIR no PC
* (adaptado de stm32_fir_intr.c)
*
*  Lê arquivo texto hexadecimal no formato inteiro 16 bits
*  e escreve arquivo de saída no mesmo formato
*
*  Usa acumulador de 32 bits. Não verifica se ocorre saturação
*
* Parâmetros:
*  nome_arquivo_entrada nome_arquivo_saida
*
* Compilar com:
* gcc -Wall filtro-fir-pc.c -o filtro-fir-pc
*
* Fernando
* 06/2015
*************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>

typedef float float32_t ;//para ficar igual ao que é usado em arm_math

//Aqui estão os coeficientes do filtro (h[n]) e a ordem do filtro (N)
#include "bp1750.h"

float32_t x[N];
int16_t k = 0;
 
int16_t EmulateIRQHandler(int16_t left_in_sample)
{
   int16_t left_out_sample = 0;
   int16_t i;
   float32_t yn = 0.0; //acumulador de 32 bits

   x[k++] = (float32_t)(left_in_sample);
   if (k >= N) k = 0;
   for (i=0 ; i<N ; i++)
   {
      yn += h[i]*x[k++];
      if (k >= N) k = 0;
   }
   left_out_sample = (int16_t)(yn);
   return (left_out_sample);
}
 
int main(int argc, char* argv[])
{
   int n;
   int16_t xin, yout;
   FILE *fpin, *fpout;

   if (argc!=3) {
      printf("Uso: filtro-fir-pc arquivoaudioentrada.txt arquivoaudiosaida.txt\n");
      printf("      arquivos no formato texto hexadecimal inteiro 16 bits\n");
      exit(1);
   }
   fpin=fopen(argv[1],"r");
   if (fpin==NULL) {
      printf("Erro ao abrir arquivo de entrada %s.\n\n", argv[1]);
      exit(1);
   }
   fpout=fopen(argv[2],"w");
   if (fpin==NULL) {
      printf("Erro ao abrir arquivo de saida %s.\n\n", argv[2]);
      exit(1);
   }
 
   while(1) {
      n=fscanf(fpin, "%" SCNx16, &xin); //Hexadecimal, usar SCNx16. Decimal, usar SCNd16.
      if (n==EOF) {
         break;
      }
      yout = EmulateIRQHandler(xin); //passa uma amostra de cada vez, emulando o que é feito a cada interrupção
      fprintf(fpout, "%" PRIx16 "\n", yout);
      //fprintf(fpout, "%" PRId16 "\n", yout);
   }
   fclose(fpin);
   fclose(fpout);
   return 0;
}
 
