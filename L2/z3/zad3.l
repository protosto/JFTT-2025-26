%{
#include <stdio.h>
int yylex();
int yywrap();
int docs = 0;
%}

%x IN_STRING
%x IN_COMMENT
%x IN_DOCS

singleLine               \/\/[^\n]*
docSingleLine            \/\/(\/|!)[^\n]*
multilineClose           \*\/

continuedSingleLine      \/\/[^\n]*(\\\n[^\n]*)+
docContinuedSingleLine   \/\/(\/|!)[^\n]*(\\\n[^\n]*)+

%%

\#include[[:blank:]].*\n      ECHO;

\"                            { ECHO; BEGIN(IN_STRING); }


{docContinuedSingleLine}       { if (docs) ECHO; }
{docSingleLine}                { if (docs) ECHO; }

{continuedSingleLine}          ;
{singleLine}                   ;


\/\*\*\/                      ;

\/\*(\*|!)                    { if (docs) ECHO; BEGIN(IN_DOCS); }

\/\*                          { BEGIN(IN_COMMENT); }

<IN_STRING>{
    \\.                       { ECHO; }
    [^"\\\n]                  { ECHO; }
    \"                        { ECHO; BEGIN(INITIAL); }
    \n                        { ECHO; BEGIN(INITIAL); }
}

<IN_DOCS>{
    {multilineClose}          { if (docs) ECHO; BEGIN(INITIAL); }
    \n                        { if (docs) ECHO; }
    .                         { if (docs) ECHO; }
}

<IN_COMMENT>{
    {multilineClose}          { BEGIN(INITIAL); }
    \n                        { ECHO; }
    .                         ;
}

.                             ECHO;
\n                            ECHO;

%%

int yywrap() { return 1; }

int main(int argc, char **argv) {
    if (argc > 1) docs = 1;
    return yylex();
}
