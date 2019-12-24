

// caqbeçalho
//estruturas comuns


#define exemplo a

#define SET_BIT(f,bit) ((f)|=(1<<(bit)))
#define CLR_BIT(f,bit) ((f)&=~(1<<(bit)))
#define TST_BIT(f,bit) ((f)&(1<<(bit)))




// teste ---------------------------
/*ativa informações de debug*/
#define DEBUG
/* se não quiser mais usar*/
#undef DEBUG

#ifdef DEBUG
printf("##Indice de x: %d\n", indice);
#endif

#ifdef DEBUG
printf("Versão de teste. Debug ativado\n”);
#else
printf("Código normal, sem debug\n”);
#endif
//-------------------------------------
//definição de tipos

// intN_t  // signed
// uintN_t  // unsigned

long / double / float
