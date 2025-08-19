/* English -> American */
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

