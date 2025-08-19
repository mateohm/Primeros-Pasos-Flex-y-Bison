%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);
int yylex(void);
%}

/* Tokens */
%token NUMBER
%token ADD SUB MUL DIV
%token AND OR
%token ABS
%token EOL

/* Precedencia y asociatividad */
%left ADD SUB
%left MUL DIV
%left AND OR
%left ABS

%%

calclist:
    /* vacío */
  | calclist exp EOL   { printf("= %d (0x%X)\n", $2, $2); }
  ;

exp:
    factor
  | exp ADD factor     { $$ = $1 + $3; }
  | exp SUB factor     { $$ = $1 - $3; }
  | exp AND factor     { $$ = $1 & $3; }
  | exp OR factor      { $$ = $1 | $3; }
  ;

factor:
    term
  | factor MUL term    { $$ = $1 * $3; }
  | factor DIV term    { $$ = $1 / $3; }
  ;

term:
    NUMBER             { $$ = $1; }
  | ABS term ABS       { $$ = $2 >= 0 ? $2 : -$2; }
  ;

%%

int main(void) {
    printf("Calculadora extendida (decimal, hex, abs, bitwise, comentarios)\n");
    printf("Escribe expresiones, Ctrl+D para salir.\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
