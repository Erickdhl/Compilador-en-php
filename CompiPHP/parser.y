/* Analizador sintactico para reconocer sentencias  */

/* Sección DEFINICIONES */
%{
#include <stdio.h>
/*#define YYERROR_VERBOSE*/

int yylex();
int yyerror(char *s);
%}

/* Sección REGLAS */
%token  IGUAL SI CASOCONTRARIO MIENTRAS PARA COMA PUNTOYCOMA PARENTESIS LLAVES TEXTO ENTERO FLOTANTE VAR OPE_ARIT OPE_RELA OPE_LOG CORCHETES ESCRIBIR

%%
/* REGLAS PARA REPETIR RECORRIDOS*/
sentencias: sentencia sentencias 
    | sentencia
    ;
/* REGLAS ESTRUCTURA SI*/
sentencia:  SI PARENTESIS condicion PARENTESIS instrucion PUNTOYCOMA {printf("Sentencia SI valida: SVS\n");}
   | SI PARENTESIS condicion PARENTESIS LLAVES instrucion PUNTOYCOMA conjuntoinstruciones LLAVES {printf("Sentencia SI valida: SVS\n");} 

/* REGLAS ESTRUCTURA SI CASO CONTRARIO*/
   |SI PARENTESIS condicion PARENTESIS instrucion PUNTOYCOMA otraexpresion {printf("Sentencia  valida: SVS\n");}
   |  SI PARENTESIS condicion PARENTESIS LLAVES instrucion PUNTOYCOMA conjuntoinstruciones LLAVES otraexpresion {printf("Sentencia SI CASOCONTRARIO ANIDADO valida: SVS\n");} 

/* REGLAS ESTRUCTURA MIENTRAS*/
   | asignacion MIENTRAS PARENTESIS condicion PARENTESIS instrucion PUNTOYCOMA {printf("Sentencia MIENTRAS valida: SVS\n");} 
   | asignacion MIENTRAS PARENTESIS condicion PARENTESIS LLAVES instrucion PUNTOYCOMA conjuntoinstruciones LLAVES {printf("Sentencia MIENTRAS valida: SVS\n");} 

/* REGLAS ESTRUCTURA PARA*/
   |PARA PARENTESIS asignacion comparacion contador PARENTESIS instrucion PUNTOYCOMA {printf("Sentencia PARA valida: SVS\n");} 
   |PARA PARENTESIS asignacion comparacion contador PARENTESIS LLAVES instrucion PUNTOYCOMA conjuntoinstruciones LLAVES{printf("Sentencia PARA valida: SVS\n");}

/* REGLAS ASIGNACION*/ 
   |VAR IGUAL numero PUNTOYCOMA {printf("ASIGNACION: SVS\n");}
   ;

    
condicion:     VAR OPE_RELA ENTERO 
    |  VAR OPE_RELA FLOTANTE 
    |  VAR OPE_RELA TEXTO   
    |  VAR OPE_RELA ENTERO otracondicion
    |  VAR OPE_RELA FLOTANTE otracondicion
    |  VAR OPE_RELA TEXTO otracondicion
    ;
otracondicion:     OPE_LOG VAR OPE_RELA ENTERO 
    |  OPE_LOG VAR OPE_RELA FLOTANTE 
    |  OPE_LOG VAR OPE_RELA TEXTO 
    |  OPE_LOG VAR OPE_RELA ENTERO otracondicion
    |  OPE_LOG VAR OPE_RELA FLOTANTE otracondicion
    |  OPE_LOG VAR OPE_RELA TEXTO otracondicion 
    ;
conjuntoinstruciones:     instrucion PUNTOYCOMA conjuntoinstruciones 
    | instrucion PUNTOYCOMA
    ;
otraexpresion:   CASOCONTRARIO sentencia 
    | CASOCONTRARIO instrucion PUNTOYCOMA
    | CASOCONTRARIO LLAVES instrucion PUNTOYCOMA instrucion LLAVES
    ; 
instrucion:     ESCRIBIR TEXTO
    | ESCRIBIR VAR
    | ESCRIBIR ENTERO
    | ESCRIBIR FLOTANTE
    | ESCRIBIR VAR IGUAL ENTERO
    ;
asignacion:	VAR IGUAL numero PUNTOYCOMA
    ;
comparacion:	VAR OPE_RELA numero PUNTOYCOMA
    ;	
contador:	VAR OPE_ARIT OPE_ARIT
    ;
numero:		ENTERO
    |	FLOTANTE
    ;	

/*REGLAS DECLARACION DE ARREGLOS*/

/*REGLAS ESTRUCTURA ERRONEAS*/
%%

/* Sección CODIGO USUARIO */
FILE *yyin;
int main() {
    do {
        yyparse();
    }
    while ( !feof(yyin) );
    
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "A.Sintactico: %s\n", s);
    return 0;
}
