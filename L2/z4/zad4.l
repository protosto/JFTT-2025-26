%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>

#define STACK_MAX 256

int stack[STACK_MAX];
int sp = 0;
bool error = false;

void reset();
%}

%%

^\xEF\xBB\xBF            ;      /*UTF-8 BOM problem */
[ \t\r]+                 ;      /*skip whitespace*/

\-?[0-9]+                {
                             if (sp >= STACK_MAX) {
                                 printf("Błąd: przepełnienie stosu\n");
                                 reset();
                                 break;
                             }
                             stack[sp++] = atoi(yytext);
                         }

[\+\-\*/\^%]             {
                             if (sp < 2) {
                                 printf("Błąd: za mała liczba argumentów\n");
                                 reset();
                                 break;
                             }

                             int b = stack[--sp];
                             int a = stack[--sp];

                             switch (yytext[0]) {
                                 case '+': stack[sp++] = a + b; break;
                                 case '-': stack[sp++] = a - b; break;
                                 case '*': stack[sp++] = a * b; break;
                                 case '^': stack[sp++] = (int)pow(a, b); break;
                                 case '/':
                                     if (b == 0) {
                                         printf("Błąd: dzielenie przez 0\n");
                                         reset();
                                     } else {
                                         stack[sp++] = a / b;
                                     }
                                     break;
                                 case '%':
                                     if (b == 0) {
                                         printf("Błąd: dzielenie przez 0\n");
                                         reset();
                                     } else {
                                         stack[sp++] = a % b;
                                     }
                                     break;
                             }
                         }

\n                       {
                             if (!error) {
                                 if (sp == 1)
                                     printf("= %d\n", stack[0]);
                                 else if (sp > 1)
                                     printf("Błąd: za mała liczba operatorów\n");
                             }
                             sp = 0;
                             error = false;
                         }

.                        {
                             if (!error) {
                                 printf("Błąd: zły symbol \"%c\"\n", yytext[0]);
                             }
                             reset();
                         }

%%

void reset() {
    sp = 0;
    error = true;
}

int yywrap() { return 1; }

int main() {
    yylex();
    return 0;
}
