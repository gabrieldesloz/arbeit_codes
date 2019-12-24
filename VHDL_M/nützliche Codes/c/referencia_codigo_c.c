#include <stdio.h>
#include <stdlib.h>


int main()  /* função "main" que retorna o tipo int */
{
    printf( "I am alive!  Beware.\n" );  /* \n pula linha */
    getchar();             /* espera um caracter ser inserido */
    return 0;            /* retorna int */
}




int main()
{
    int this_is_a_number;
    printf( "Please enter a number: " );
    scanf( "%d", &this_is_a_number );      // "%d" pede para a função ler integer, &... passa o local
                                           //  da variavel this_is_a_number

    printf( "You entered %d", this_is_a_number );
    getchar();
    return 0;
}




////////////////////////////////////////////////////////////
// uso de funções e multiplicação

int mult (int mx, int my)
{
  int www;
  www = mx * my;
  return www;
}


int main()
{


    float x, y;
    float z;
    int w;
    int ww;
    int www;
    int ww_query;
    printf( "Please enter number x: " );
    scanf("%f", &x);
    printf( "Please enter number y: " );
    scanf("%f", &y);
    z = x/y;
    printf( "Resposta:%f \n", z);

    if (z > 10) {
        printf(" z > 10\n");
     } else if (z == 10) {
     printf(" z igual a 10\n");
     } else {
         printf(" z < ou igual a 10\n");
     }


    for ( w = 1; w <= z; w++ ) {
    printf( "%d\n", w );
    if (w == 2){system("PAUSE");} // #include <stdlib.h>
    }
    //getchar();


    float a = rand();     //
    printf( "%f\n", a );
    system("PAUSE");    //  #include <stdlib.h>

    ww = 0;
    while (ww < z) {

        printf( "%d\n", ww );
        //if (ww == 4) //{break;}
        ww++;
        if (ww == z-2){continue;} // pula o proximo printf
        printf( "%d\n", ww );
    }
    getchar();



    www = 0;
    do
    {
        printf("Hello World\n");
    } while ( www != 0 );
    getchar();


int mx;
int my;

printf( "Please input two numbers to be multiplied: " );
scanf( "%d", &mx );
scanf( "%d", &my );
printf( "The product of your two numbers is %d\n", mult( mx, my ) );
getchar();




//////////////////////////////////////////////////////////////
// estruturas => name.1 ...
// declaracao do tipo de estrutura "example"

struct example {
  int x;
  int y;
};
// declaração da variavel  an_example do tipo example
struct example an_example; /* Treating it like a normal variable type
                            except with the addition of struct*/
an_example.x = 33;          /*How to access its members */
an_example.y = 12;

printf( "x:%d\n\n", an_example.x);
printf( "y:%d\n\n", an_example.y);

system("PAUSE");


//typedef struct...


struct xampl {
  int x;
  int y;
};

{
    struct xampl structure;
    struct xampl *ptr;  // ponteiro ptr do tipo xampl

    structure.x = 12;
    structure.y = 5;
    ptr = &structure; /*  apontar ptr para structure  */
    printf( "%d\n", ptr->y );  /* The -> acts somewhat like the * when
                                   does when it is used with pointers
                                    It says, get whatever is at that memory
                                   address Not "get what that memory address
                                   is"*/
    printf( "%d\n", ptr->x );
    getchar();
}

////////////////////////////////////
// arrays

int examplearray[100]; /* matriz com 100 elementos */
char string_array[50];


char astring[10];
int i = 0;
scanf( "%s", astring ); // matriz é convertida auto para um ponteiro do 1o elemento
for ( i = 0; i < 10; ++i )
{
    if ( astring[i] == 'a' )
    {
        printf( "You entered an a!\n" );
    }
}


  int ax;
  int ay;
  int array[8][8]; /* Declares an array like a chessboard */

  for ( ax = 0; ax < 8; ax++ ) {
    for ( ay = 0; ay < 8; ay++ )
      array[ax][ay] = ax * ay; /* Set each element to a value */
  }
  printf( "...:\n" );
  for ( ax = 0; ax < 8; ax++ ) {
    for ( ay = 0; ay < 8; ay++ )
    {
        printf( "[%d][%d] = %d\t", ax , ay , array[ax][ay]);
    }
    printf( "\n" );
  }
  getchar();


//// ponteiros e matrizes /////

//char *ptr;
//char str[40];
//ptr = str;  /* Gives the memory address without a reference operator(&) */



	// declare an variable ptr which holds the value-at-address of an int type
	int *ptr2;
	// declare assign an int the literal value of 1
	int val = 1;
	// assign to ptr the address-of the val variable
	ptr2 = &val;
	// dereference and get the value-at-address stored in ptr
	int deref = *ptr2;
	printf("%d\n", deref);
	system("PAUSE");

return 0;

}

///////////////////////////////////////////////////////////////
//uso de switch / case, função void(não retorna valores)


void playgame()
{
    printf( "Play game called" );
}
void loadgame()
{
    printf( "Load game called" );
}
void playmultiplayer()
{
    printf( "Play multiplayer game called" );
}

void game()
{
    int input;

    printf( "1. Play game\n" );
    printf( "2. Load game\n" );
    printf( "3. Play multiplayer\n" );
    printf( "4. Exit\n" );
    printf( "Selection: " );
    scanf( "%d", &input );
    switch ( input ) {
        case 1:            /* Note the colon, not a semicolon */
            playgame();
            break;
        case 2:
            loadgame();
            break;
        case 3:
            playmultiplayer();
            break;
        case 4:
            printf( "Thanks for playing!\n" );
            break;
        default:
            printf( "Bad input, quitting!\n" );
            break;
    }
    getchar();

}

// int x
// int a, b, c, d;
// char letter;
// float f;
// +, -, /, *, =, ==, <, >, <=, >= , !=

// logical operators
// && and
// || or
// ! not



// pointer --> aponta para um local na memoria. Endereço da memoria ou a variavel que armazena este endereço

// declarando pointers
//int *pointer1, *pointer2;

// call_to_function_expecting_memory_address(pointer);
//"*pointer" para retornar o valor daquele endereço,
//"pointer": endereço
//   p = &x;           /* passa o valor do endereço x para p" */
// & para ler o endereço
// & --> para o endereço
// * retornar o valor do endereço



//////////////////////ponteiros//////////////////////////////
#include <stdio.h>

void main2()
{
    int x;              /* A normal integer*/
    int *p;             /* A pointer to an integer ("*p" is an integer, so p
                       must be a pointer to an integer) */

    p = &x;               /* Read it, "assign the address of x to p" */
    scanf( "%d", &x );    /* Put a value in x, we could also use p here */
    printf( "%d\n", *p ); /* Note the use of the * to get the value */
    getchar();

}


//------------------------------------------------------
// caracteres e hexa
//------------------------------------------------------

int main()
{
	int value, value2;
	static alt_u8 segments[16] = {
		0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90, /* 0-9 */
		0x88, 0x83, 0xc6, 0xal, 0x86, 0x8e /* A-F */
	};


//////////////////////////////////////////////////
//----rotina para escrever no LCD

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









