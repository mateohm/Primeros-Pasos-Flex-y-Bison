/* recognize tokens for the calculator and print them out */
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
