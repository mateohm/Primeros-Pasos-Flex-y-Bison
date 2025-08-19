# Primeros Pasos Flex y Bison

Introducción

Los ejercicios del Capítulo 1 de Flex & Bison permitieron comprender los conceptos básicos del análisis léxico y la relación entre Flex y Bison. A través de ejemplos progresivos, se pasó de programas simples que cuentan caracteres y palabras, a analizadores que reconocen operadores y números, hasta la integración con un parser.

Con estas prácticas se aprendió a usar expresiones regulares para definir reglas, manejar tokens con valores y comprender cómo Flex transforma la entrada en tokens que Bison interpreta para darles significado dentro de una gramática.

## 1. Análisis del Ejemplo 1-1

- Objetivo del código

  Este programa es un contador de palabras, líneas y caracteres

- Estructura del código

```
/* just like Unix wc */
%{
#include <stdio.h>
#include <string.h>
int chars = 0;
int words = 0;
int lines = 0;
%}
%%
[a-zA-Z]+ { words++; chars += strlen(yytext); }
\n        { chars++; lines++; }
.         { chars++; }
%%
int main(int argc, char **argv)
{
    yylex();
    printf("%8d%8d%8d\n", lines, words, chars);
}

```

## 2. Análisis del Ejemplo 1-2

- Objetivo del código

  Este programa actúa como un traductor de palabras específicas del inglés           británico al inglés americano (y algunos sinónimos), reemplazando                  automáticamente las coincidencias en el texto de entrada.

- Estructura del código

```
* English -> American */
%{
#include <stdio.h>
%}

%%
"colour"        { printf("color"); }
"flavour"       { printf("flavor"); }
"clever"        { printf("smart"); }
"smart"         { printf("elegant"); }
"conservative"  { printf("liberal"); }
.               { printf("%s", yytext); }
%%

int main(void) {
    yylex();
    return 0;
}

```

En este ejemplo el programa venia sin el main asi que de esta forma se le implemento para que funcionara adecuadamente 

```
int main(void) {
    yylex();
    return 0;
}

```

Este ejemplo muestra cómo Flex puede servir como un filtro de texto que realiza sustituciones.


## 3. Análisis del Ejemplo 1-3

- Objetivo del código
  
  Este programa define un analizador léxico para una calculadora simple:

  Reconoce operadores (+, -, *, /, |),

  Reconoce números enteros,

  Reconoce saltos de línea,

  Ignora espacios en blanco y tabulaciones,

  Reporta caracteres desconocidos.

- Estructura del código

```
* recognize tokens for the calculator and print them out */
%{
#include <stdio.h>
%}

%%
"+"        { printf("PLUS\n"); }
"-"        { printf("MINUS\n"); }
"*"        { printf("TIMES\n"); }
"/"        { printf("DIVIDE\n"); }
"|"        { printf("ABS\n"); }
[0-9]+     { printf("NUMBER %s\n", yytext); }
\n         { printf("NEWLINE\n"); }
[ \t]      { /* Ignorar espacios y tabulaciones */ }
.          { printf("Mystery character %s\n", yytext); }
%%

int main(void) {
    yylex();
    return 0;
}
```

## 4. Análisis del Ejemplo 1-4

- Objetivo del código

  Este programa es un analizador léxico más avanzado para la calculadora, que:

    Asigna un código numérico a cada token (operadores, números, fin de línea).

- Estructura del código

```
/* recognize tokens for the calculator and print them out */
%{
#include <stdio.h>
#include <stdlib.h>

enum yytokentype {
    NUMBER = 258,
    ADD = 259,
    SUB = 260,
    MUL = 261,
    DIV = 262,
    ABS = 263,
    EOL = 264
};

int yylval;
%}

%%
"+"        { return ADD; }
"-"        { return SUB; }
"*"        { return MUL; }
"/"        { return DIV; }
"|"        { return ABS; }
[0-9]+     { yylval = atoi(yytext); return NUMBER; }
\n         { return EOL; }
[ \t]      { /* ignore whitespace */ }
.          { printf("Mystery character %c\n", *yytext); }
%%

int main(int argc, char **argv)
{
    int tok;
    while ((tok = yylex())) {
        printf("%d", tok);
        if (tok == NUMBER)
            printf(" = %d\n", yylval);
        else
            printf("\n");
    }
    return 0;
}

```
  
  Se empieza a entender cómo Flex (léxico) y Bison (sintaxis) trabajan juntos:      Flex reconoce y clasifica, Bison interpretará la estructura gramatical de los     tokens.


## 5. Análisis del Ejemplo 1-5

- Objetivo del código

  El ejemplo 1-5 muestra cómo Flex y Bison empiezan a trabajar juntos. A            diferencia de los anteriores, este código ya no imprime directamente los          tokens, sino que los envía al parser de Bison mediante el archivo de cabecera     "ejemplo1_5.tab.h". De esta forma, Flex reconoce los operadores, números y        saltos de línea, y devuelve los tokens definidos en la gramática de Bison.

- Estructura del código

 ```
  * recognize tokens for the calculator and pass them to Bison */
%{
#include <stdio.h>
#include <stdlib.h>
#include "ejemplo1_5.tab.h"  /* generado por Bison, define los tokens */


%}

%%
"+"        { return ADD; }
"-"        { return SUB; }
"*"        { return MUL; }
"/"        { return DIV; }
"|"        { return ABS; }
[0-9]+     { yylval = atoi(yytext); return NUMBER; }
\n         { return EOL; }
[ \t]      { /* ignore whitespace */ }
.          { printf("Mystery character %c\n", *yytext); }
%%

int yywrap(void) { return 1; }

```
  
## Pasos generales para ejecutar los programas de Flex

- 1. Guardar el código en un archivo con extensión .l

     nano ejemplo1-1.l

- 2. Generar el analizador con Flex

     flex ejemplo1-1.l

- 3. Compilar con GCC

     gcc lex.yy.c -o ejemplo1-1 -lfl

- 4. Ejecutar el programa
 
     ./ejemplo1-1


# Ejercicios

## 1. Manejo de comentarios
Pregunta: ¿La calculadora aceptará una línea que contenga solo un comentario? ¿Por qué no? ¿Dónde es más fácil corregirlo?


Con el parser anterior, no: la gramática exige exp EOL para imprimir un resultado. Una línea con solo comentario (si el lexer ignora los comentarios y deja solo EOL) produciría un EOL “sueltO”, lo que antes causaba error.
Arreglo recomendado en el parser: aceptar líneas en blanco (o solo comentario → EOL) agregando una producción que consuma EOL.


## 2. Conversión hexadecimal
Aceptar enteros decimales y hex (prefijo 0x), convertir con strtol, y mostrar salida en decimal y hex.


Cambios en el lexer

```
0[xX][0-9a-fA-F]+  { yylval = (int)strtol(yytext, NULL, 0); return NUMBER; }
[0-9]+             { yylval = (int)strtol(yytext, NULL, 10); return NUMBER; }

```

Cambios en el parser

```
calclist:
      /* empty */
    | calclist EOL
    | calclist exp EOL   { printf("= %d (0x%X)\n", $2, $2); }
    ;

```

## 3. Operadores de nivel de bits (AND / OR) y el conflicto con |
Agregar & (AND) y | (OR)

Lexer

```
"abs"      { return ABS; }
"&"        { return BAND; }
"|"        { return BOR; }

```

Parser

```
%left BOR
%left BAND
%left ADD SUB
%left MUL DIV

exp:
      exp BOR factor     { $$ = $1 | $3; }
    | exp BAND factor    { $$ = $1 & $3; }
    | exp ADD factor     { $$ = $1 + $3; }
    | exp SUB factor     { $$ = $1 - $3; }
    | factor
    ;

term:
      ABS '(' exp ')'    { $$ = $3 >= 0 ? $3 : -$3; } /* abs(expr) */
    | NUMBER
    ;

```

## 4. Reconocimiento de tokens
¿Reconocen exactamente lo mismo?

Generalmente no en todos los bordes:

Mayor codicia / prioridades: Flex garantiza longest match según el orden de reglas; el escáner manual puede cortar números demasiado pronto.

Unicode/ASCII extendido: Flex, por defecto, trabaja por bytes; el manual quizá trate isalpha() / isdigit() con ctype y locale, afectando qué cuenta como “letra”.

Errores y EOF: Flex maneja EOF/yywrap de forma estándar; el manual necesita más cuidado con ungetc, EOF tras número, etc.

Reglas sobre \n: Flex no casa . con \n (a menos de truco); el manual puede tratar \n como whitespace general accidentalmente.

Conclusión: para casos simples coinciden, pero Flex es más predecible y fácil de extender.


## 5. ¿Para qué idiomas Flex no es buena herramienta?


Flex reconoce lenguajes regulares (autómatas finitos). No es ideal para:

- Lenguajes donde la indentación define bloques (Python): se puede hackear          (contando espacios), pero requiere estado complejo.

- Tokens contextuales (p.ej., en C, typedef hace que un identificador pase a ser    type-name): necesita cooperación con el parser/tabla de símbolos.

- Unicode complejo / normalización: Flex trabaja a nivel de byte; análisis          Unicode real (graphemes) requiere más.


## 6. Reescribir el contador de palabras en C y comparar

Codigo en C: 

```
include <stdio.h>
#include <ctype.h>

int main(void) {
    int c, in_word = 0;
    long lines = 0, words = 0, chars = 0;

    while ((c = getchar()) != EOF) {
        chars++;
        if (c == '\n') lines++;
        if (isalpha((unsigned char)c)) {
            if (!in_word) { words++; in_word = 1; }
        } else {
            in_word = 0;
        }
    }
    printf("%8ld%8ld%8ld\n", lines, words, chars);
    return 0;
}
```

<img width="282" height="277" alt="image" src="https://github.com/user-attachments/assets/7477c3d7-0c64-4cd7-9ecd-658a10c991eb" />

El programa en C puro es más eficiente, porque no usa un analizador léxico/sintáctico generado, sino directamente código escrito a mano.

El programa en Flex/Bison es un poco más pesado, porque pasa por el analizador léxico y sintáctico antes de calcular, lo que implica más capas de procesamiento.






