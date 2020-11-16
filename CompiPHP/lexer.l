/* Programa (lexer) que será llamado desde un parser */

/* Sección DEFINICIONES */
%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h" //para que lexer.l y parser.y usen las mismas constantes
int NroArreglos = 0, NroFunciones = 0, NroErrores=0, Contador=0;
#define BUSCAR 0
int estado;
int agregar_palabra(int tipo, char *palabra);
int buscar_palabra(char *palabra);
%}
/* Sección REGLAS */
%s ARREGLO
%s FUNCION
%s ERROR
espacio [ ]
digito [0-9]
NUMERO {digito}+   
NUMcoma {NUMERO},   
caracter [a-zA-Z]
cadena {caracter}+
texto ["][a-zA-Z]*["]|["][a-zA-Z]*[:][ ]["]|["][a-zA-Z]*[ ]["]|["][a-zA-Z]*[:]["]
TEXcoma {texto},
s if|else|while|for|do|sizeof|echo|print
Si Si|SI|si
CasoContrario CasoContrario
Mientras Mientras|Mientras|mientras
Para Para|PARA|para
Tamano Tamano|TAMANO|tamano
Leer Leer|LEER|leer
Escribir Escribir|ESCRIBIR|escribir
Caso Caso|CASO|caso
Descanso Descanso|descanso|DESCANSO	
llave [{]|[}]
IGUAL [=]
var [$][a-zA-Z]+[0-9]|[$][a-zA-Z]+
VarComa {var}, 
Fun Funcion
IniFun {cadena}[(][)][;]|{cadena}[(]{var}[)][;]|{cadena}[(]{VarComa}+{var}[)][;]
Corchetes [[]|[]]
DelC [,]
DelPC [;]
con [.]
parentesis [(]|[)]
llaves	[{]|[}]
ope_arit [+]|[-]|[*]|[/]|[%]
ope_rela [<]|[>]|[<][=]|[>][=]|[<][>]|[=][=]|[!][=]
ope_log [|][|]|[&][&]
entero {digito}+
float {entero}\.{entero}
Nofloat {entero}\,{entero}
coment [/][/][a-zA-Z]*

/* Sección REGLAS */
%%

{IGUAL}		{estado = IGUAL; printf("IGUAL : %s\n",yytext);agregar_palabra(IGUAL, yytext);return IGUAL;}

{Si}	{estado = SI; printf("SI : %s\n",yytext);agregar_palabra(SI, yytext);return SI;}
{CasoContrario}		{estado = CASOCONTRARIO; printf("CC : %s\n",yytext);agregar_palabra(CASOCONTRARIO, yytext);return CASOCONTRARIO;}
{Para}	{estado = PARA; printf("PARA : %s\n",yytext);agregar_palabra(PARA, yytext);return PARA;}
{Mientras}	{estado = MIENTRAS; printf("SEN : %s\n",yytext);agregar_palabra(MIENTRAS, yytext);return MIENTRAS;}
{Escribir}	{estado = ESCRIBIR; printf("ESCRIBIR : %s\n",yytext);agregar_palabra(ESCRIBIR, yytext);return ESCRIBIR;}
{IniFun}		
{texto}		{estado = TEXTO; printf("TEXTO : %s\n",yytext);agregar_palabra(TEXTO, yytext);return TEXTO;}
{cadena}    	{printf("ERROR : %s-> No se reconoce argumento ->LINEA: %i \n",yytext,Contador+1);} 
{DelC} 		{estado = COMA; printf("COMA : %s\n",yytext);agregar_palabra(COMA, yytext);return COMA;}  
{DelPC} 		{estado = PUNTOYCOMA; printf("PUNTOYCOMA : %s\n",yytext);agregar_palabra(PUNTOYCOMA, yytext);return PUNTOYCOMA;}  
{entero}   	{estado = ENTERO; printf("ENTERO : %s\n",yytext);agregar_palabra(ENTERO, yytext);return ENTERO;}  
{float} 	{estado = FLOTANTE; printf("FLOTANTE : %s\n",yytext);agregar_palabra(FLOTANTE, yytext);return FLOTANTE;} 
{Nofloat}	{printf("ERROR : %s-> los numeros tipo float van con un punto ->LINEA: %i \n",yytext,Contador+1);}
{parentesis}		{estado = PARENTESIS; printf("PARENTESIS : %s\n",yytext);agregar_palabra(PARENTESIS, yytext);return PARENTESIS;} 
{llaves}		{estado = LLAVES; printf("LLAVES : %s\n",yytext);agregar_palabra(LLAVES, yytext);return LLAVES;} 
{var}		{estado = VAR; printf("VAR : %s\n",yytext);agregar_palabra(VAR, yytext);return VAR;} 		 	
{ope_arit}	{estado = OPE_ARIT; printf("OPE_ARIT : %s\n",yytext);agregar_palabra(OPE_ARIT, yytext);return OPE_ARIT;} 	
{coment}	
{ope_rela}	{estado = OPE_RELA; printf("OPE_RELA : %s\n",yytext);agregar_palabra(OPE_RELA, yytext);return OPE_RELA;} 	
{ope_log}	{estado = OPE_LOG; printf("OPE_LOG : %s\n",yytext);agregar_palabra(OPE_LOG, yytext);return OPE_LOG;} 	
{Corchetes}	{estado = CORCHETES; printf("CORCHETES : %s\n",yytext);agregar_palabra(CORCHETES, yytext);return CORCHETES;} 	
{con}		
\n	{Contador++;}     


%%

/* Sección CODIGO USUARIO */
/* definir una lista enlazada de palabras y tipos*/
struct palabra {
    char *nombre_palabra;
    int tipo_palabra;
    struct palabra *sgte;
};

struct palabra *lista = NULL; /*primer elemento de la lista*/

int agregar_palabra(int tipo, char *palabra) {
    struct palabra *p; /*entrada de la lista*/
    
   
    
    /* asignar espacio de memoria */
    p = malloc( sizeof( struct palabra ) );
    p->nombre_palabra = malloc( strlen(palabra) + 1 ); 
    /* copiar datos de palabra */
    strcpy( p->nombre_palabra, palabra );
    p->tipo_palabra = tipo;    
    /* enlazar nueva entrada a lista */
    p->sgte = lista;
    lista = p;
    return 1; //funciono
}

int buscar_palabra(char *palabra){
    struct palabra *p = lista;
    
    /* buscar palabra en la lista */
    while (p != NULL) {
        if ( strcmp(p->nombre_palabra, palabra) == 0 )
            return p->tipo_palabra;
        p = p->sgte;
    }
    
    return BUSCAR; /*no encontrado*/
}








