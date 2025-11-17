%{
  #include <stdio.h>
%}

%x DQDOC
%x SQDOC
%x CODE

%%

<<EOF>>         { return 0; }

.|\n            { BEGIN(CODE); ECHO; }

<CODE>\"\"\"        { BEGIN(DQDOC); }
<DQDOC>\"\"\"       { BEGIN(CODE); }
<DQDOC>.|\n         ;

<CODE>\'\'\'        { BEGIN(SQDOC); }
<SQDOC>\'\'\'       { BEGIN(CODE); }
<SQDOC>.|\n         ;

<CODE>\#[^\n]*      ;

<CODE>.             ECHO;
<CODE>\n            ECHO;

%%

int yywrap() { return 1; }

int main() {
    yylex();
    return 0;
}
