

// caqbe�alho
//estruturas comuns


#define exemplo a

#define SET_BIT(f,bit) ((f)|=(1<<(bit)))
#define CLR_BIT(f,bit) ((f)&=~(1<<(bit)))
#define TST_BIT(f,bit) ((f)&(1<<(bit)))




// teste ---------------------------
/*ativa informa��es de debug*/
#define DEBUG
/* se n�o quiser mais usar*/
#undef DEBUG

#ifdef DEBUG
printf("##Indice de x: %d\n", indice);
#endif

#ifdef DEBUG
printf("Vers�o de teste. Debug ativado\n�);
#else
printf("C�digo normal, sem debug\n�);
#endif
//-------------------------------------
//defini��o de tipos

// intN_t  // signed
// uintN_t  // unsigned

long / double / float
