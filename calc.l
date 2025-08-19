%{
#include "calc.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%%

"+"         { return ADD; }
"-"         { return SUB; }
"*"         { return MUL; }
"/"         { return DIV; }
"&"         { return AND; }
"|"         { return OR; }

0[xX][0-9a-fA-F]+   { yylval = strtol(yytext, NULL, 16); return NUMBER; }
[0-9]+              { yylval = atoi(yytext); return NUMBER; }

\n          { return EOL; }
[ \t\r]+    { /* ignorar espacios */ }

.           { printf("Caracter desconocido: %s\n", yytext); }

%%

int yywrap(void) { return 1; }
