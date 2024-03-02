%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "expressao.tab.h"
#include "lex.yy.c"
%}

%union {
    char *str;
}


%token<str> PRINT ABREP FECHAP VIRGULA ID STR NUM FIM_ENTRADA MAIORIGUAL MENOS FIM_DE_LINHA MAIS ATRIB IF ELIF ELSE MAIOR MENORIGUAL MENOR IGUAL WHILE MAISIGUAL DOIS_PONTOS ABRECHAVE FECHACHAVE DEF RETURN ESPACO
%type<str> COMANDOS VALOR CHAMAR_FUNCAO COMANDO_DEF COMANDO_PRINT COMANDO_VARIAVEIS_SEM_D CONDICAO COMANDO_IF_ELSE VARIAVEIS COMANDO_VARIAVEIS COMANDO_WHILE DENTRO_DO_WHILE

%%

COMANDOS : COMANDO_DEF | COMANDOS COMANDO_DEF
         | COMANDO_PRINT | COMANDOS COMANDO_PRINT
         | COMANDO_IF_ELSE | COMANDOS COMANDO_IF_ELSE
         | COMANDO_VARIAVEIS | COMANDOS COMANDO_VARIAVEIS
         | COMANDO_WHILE | COMANDOS COMANDO_WHILE
         | CHAMAR_FUNCAO | COMANDOS CHAMAR_FUNCAO
         ;


DENTRO_DO_WHILE : COMANDO_PRINT
                | DENTRO_DO_WHILE COMANDO_PRINT
                | COMANDO_IF_ELSE 
                | DENTRO_DO_WHILE COMANDO_IF_ELSE
                | COMANDO_VARIAVEIS_SEM_D
                | DENTRO_DO_WHILE COMANDO_VARIAVEIS_SEM_D
                ;

VARIAVEIS : VALOR
          | ID ATRIB VALOR 
          | ID ATRIB VALOR VARIAVEIS
          ;

COMANDO_DEF : DEF VALOR ABREP VALOR VIRGULA VALOR FECHAP FIM_DE_LINHA
    {
       printf("function %s(%s,%s);\n", $2,$4,$6);  
    } 
    |
    DEF VALOR ABREP VALOR VIRGULA VALOR FECHAP DOIS_PONTOS FIM_DE_LINHA
    {
       printf("function %s(%s,%s){\n", $2,$4,$6);  
    }
    |
    DEF VALOR  ABREP FECHAP FIM_DE_LINHA
    {
       printf("function %s();\n", $2);  
    }
    |DEF VALOR ABREP VALOR FECHAP FIM_DE_LINHA
    {
       printf("function %s(%s);\n", $2,$4);  
    } 
    |DEF VALOR ABREP VALOR FECHAP DOIS_PONTOS FIM_DE_LINHA
    {
       printf("function %s(%s);\n", $2,$4);  
    } 
    |DEF VALOR ABREP VALOR FECHAP ABRECHAVE FIM_DE_LINHA 
    {
       printf("function %s(%s){\n", $2,$4);  
    } 
    |RETURN VALOR FIM_DE_LINHA
    {
       printf("return %s;\n}\n",$2);  
    } 
    ;

COMANDO_PRINT : PRINT  ABREP VARIAVEIS FECHAP FIM_DE_LINHA
    { 
        printf("console.log(%s);\n", $3);
    }
    |PRINT  ABREP FECHAP FIM_DE_LINHA
    { 
        printf("console.log();\n");
    }  
    | PRINT  ABREP VARIAVEIS VIRGULA  VALOR FECHAP FIM_DE_LINHA
    {
                printf("console.log(%s,%s);\n", $3,$5);
    }
    ;

COMANDO_VARIAVEIS : ID ATRIB VALOR FIM_DE_LINHA
    {
        printf("let %s = %s;\n", $1, $3);
    } 
    |
    ID ATRIB VALOR MAIS VALOR FIM_DE_LINHA
    {
        printf("let %s = %s + %s;\n", $1, $3, $5);
    } 
    |
    ID ATRIB VALOR MENOS VALOR FIM_DE_LINHA
    {
        printf("let %s = %s - %s;\n", $1, $3, $5);
    } 
    |
    ID ATRIB CONDICAO FIM_DE_LINHA
    {
        printf("let %s;\nif (%s) {\n", $1, $3);
    }
    ;

COMANDO_VARIAVEIS_SEM_D : ID ATRIB VALOR FIM_DE_LINHA
    {
        printf(" %s = %s;\n", $1, $3);
    }
    | ID MAISIGUAL VALOR FIM_DE_LINHA
    {
        printf(" %s++;\n", $1);
    }
    ;
CHAMAR_FUNCAO : ID ATRIB VALOR ABREP VALOR VIRGULA VALOR FECHAP FIM_DE_LINHA
            {
                 printf("let %s = %s(%s,%s)\n", $1, $3,$5,$7);
            }
            |ID ATRIB VALOR ABREP VALOR FECHAP FIM_DE_LINHA
            {
                 printf("let %s = %s(%s)\n", $1, $3,$5);
            }
;

COMANDO_IF_ELSE :  IF CONDICAO FIM_DE_LINHA
    {
        printf("if (%s) {\n", $2);
    }
    | IF ABREP CONDICAO FECHAP FIM_DE_LINHA
    {
        printf("if (%s) {\n", $3);
    }
    | ELIF ABREP CONDICAO FECHAP FIM_DE_LINHA
    {
        printf("} else if (%s) {\n", $3);
    }
    | ELIF CONDICAO FIM_DE_LINHA
    {
        printf("} else if (%s) {\n", $2);
    }
    | ELSE FIM_DE_LINHA
    {
        printf("} else {\n");
        
    } | ELSE DOIS_PONTOS FIM_DE_LINHA
    {
        printf("} else {\n");
        
    }
     | IF CONDICAO DOIS_PONTOS FIM_DE_LINHA
    {
        printf("if (%s) {\n", $2);
    }
    | IF ABREP CONDICAO FECHAP DOIS_PONTOS FIM_DE_LINHA
    {
        printf("if (%s) {\n", $3);
    }
    | ELIF ABREP CONDICAO FECHAP DOIS_PONTOS FIM_DE_LINHA
    {
        printf("} else if (%s) {\n", $3);
    }
    | ELIF CONDICAO DOIS_PONTOS FIM_DE_LINHA
    {
        printf("} else if (%s) {\n", $2);
    }
    ;
    
COMANDO_WHILE : WHILE ABREP CONDICAO
    {
            printf("while (%s) {\n", $3);
    }
    FECHAP ABRECHAVE FIM_DE_LINHA FECHACHAVE 
    {
            printf("}\n");
    }
    FIM_DE_LINHA
    |WHILE CONDICAO DOIS_PONTOS FIM_DE_LINHA 
    {
        printf("while (%s) {\n", $2);
    }DENTRO_DO_WHILE
    {
            printf("}\n");
    }FIM_DE_LINHA
    ;

CONDICAO : ID MAIOR VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" > ") + 1);
    sprintf(temp, "%s > %s", $1, $3);
    $$ = temp;
}
| ID MENOR VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" < ") + 1);
    sprintf(temp, "%s < %s", $1, $3);
    $$ = temp;
}
| ID IGUAL VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" === ") + 1);
    sprintf(temp, "%s === %s", $1, $3);
    $$ = temp;
}| ID MENORIGUAL VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" <= ") + 1);
    sprintf(temp, "%s <= %s", $1, $3);
    $$ = temp;
}| ID MAIORIGUAL VALOR {
    char *temp = (char *)malloc(strlen($1) + strlen($3) + strlen(" >= ") + 1);
    sprintf(temp, "%s >= %s", $1, $3);
    $$ = temp;
};

VALOR : ID { $$ = $1; }
      | STR { $$ = $1; }
      | NUM { $$ = $1; }
      ;

%%
void yyerror(const char *msg) {
    if (strcmp(msg, "syntax error") != 0 || yytext[0] != '\0') {
        fprintf(stderr, "Erro na linha %d: %s\n", yylineno, msg);
    }
}

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Modo de uso: ./a expressao.print\n");
        return -1;
    }
    
    FILE* file = fopen(argv[1], "r");
    if (!file) {
        printf("expressao %s não encontrado!\n", argv[1]);
        return -1;
    }
    
    yyin = file;
    while (yyparse() == 0) {
    }
    
    printf("\n\nConversao OK!!!\n");
    fclose(yyin);
    return 0;
}
