%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "expressao.tab.h"
%}

%option noyywrap
%option nodefault
%option yylineno

BRANCO [ \t]
ESPACO {BRANCO}+

DIGITO [0-9]
NUMERO {DIGITO}+

LETRA [A-Za-z]
STRING_SIMPLES \'[^']*\'
STRING \"[^"]*\"
IDENTIFICADOR {LETRA}+

%%
"def"       { return DEF; }
"return"    { return RETURN; }
","          { return VIRGULA; }
"print"      { return PRINT; }
"("          { return ABREP; }
")"          { return FECHAP; }
"{"          { return ABRECHAVE; }
"}"          { return FECHACHAVE; }
"="          { return ATRIB; }
"+="          { return MAISIGUAL; }
"+"          { return MAIS; }
"-"          { return MENOS; }
"if"         { return IF; } 
"elif"       { return ELIF; }
"else"       { return ELSE; }
">"          { return MAIOR; }
"<="          { return MENORIGUAL; }
">="          { return MAIORIGUAL; }
"<"          { return MENOR; }
"=="         { return IGUAL; }
"while"      { return WHILE; }
":"          { return DOIS_PONTOS; }
{IDENTIFICADOR} { yylval.str = strdup(yytext); return ID;}
{STRING}     { yylval.str = strdup(yytext); return STR;}
{STRING_SIMPLES} { yylval.str = strdup(yytext); return STR;}
{NUMERO}     { yylval.str = strdup(yytext); return NUM; }
<<EOF>>      { return FIM_ENTRADA; }
{ESPACO}+   { /* Ignore whitespace */ }
.           { yyerror("Token desconhecido."); }
"\n"+        { yylineno++; return FIM_DE_LINHA; }
%%