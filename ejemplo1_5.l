/* recognize tokens for the calculator and pass them to Bison */
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
