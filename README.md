# Transpilador de Python para Java Script

## 1.	Justificativa do Trabalho:

O projeto consistiu em criar um transpilador capaz de transformar código Python em código JavaScript. Isso permite que programas escritos em Python possam ser executados em ambientes que suportam JavaScript, como navegadores da web ou servidores Node.js. Em suma, o objetivo e a consequente justificativa era possibilitar a portabilidade de código entre essas duas linguagens de programação.

## 2.	Instrução de Utilização
Para executar o transpilador usando o terminal, digite o comando “win_flex lexico.l” para gerar o código-fonte do analisador léxico, que contém as regras de análise léxica escritas na linguagem Lex/Flex. Em seguida, digite “win_bison -d expressao.y” para gerar o código-fonte do analisador sintático que contém as regras de análise sintática escritas na linguagem Yacc/Bison. Depois, digite “gcc expressao.tab.c” que é usado para compilar o código-fonte gerado pelo Bison. Por fim, digite “./a.exe expressao.print” ou “./a.exe exemplo.txt” no Windows para executar o arquivo “a”.

Obs: Como foi utilizado o Windows e não o Linux foi necessário baixar uma ferramenta chamada WinFlex-Bison que combina dois geradores de analisadores, Flex e Bison, para criar analisadores léxicos e sintáticos em ambientes Windows. Por isso os comandos “win_flex” e “win_bison”.

## 3.	Tokens
- Funções Definidas (def); 
- Atribuição e inicialização de variáveis (= e +=); 
- Saída de dados (print);
- Operadores de relação (<, <=, >, >=, ==);   
- Controles de repetição (while); 
- Identificadores (váriaveis, etc);
- Estruturas condicionais (if, else);
- Números inteiros (1, 2, 3, 2938, 94); 
- Strings ("Deni não pagou o boleto"); 

## 4.	Exemplo Utilizado
O exemplo utilizado no código do transpilador foi:

<pre>def somap(x, y):
    soma = x + y
    if x > y:
        resultado = "O primeiro numero e maior e da pra somar"
        soma = x + y
    else:
        resultado = "O primeiro numero nao e maior que o segundo e nao tem soma."
    return resultado
x = 10
y = 9
z = somap(x, y)
print(z)</pre>

## 5.	Limitações
A base do analisador léxico está nos princípios estabelecidos pela gramática e nos tokens reconhecidos pelo lexico. Portanto, é possível que ele não lide de maneira eficaz com estruturas não previstas na gramática ou com o uso inadequado dos tokens. Além disso, o tratamento de erros no código não é abrangente, podendo resultar em relatórios imprecisos ou tratamento inadequado de erros. A estrutura sintática da linguagem personalizada compartilha características tanto do Python quanto do JavaScript. Isso pode levar a situações onde a semântica original é mantida, mas a sintaxe resultante em JavaScript nem sempre segue as convenções mais comuns da linguagem.

Dois exemplos específicos que gerará inconsistências no código são:
- Colocar mais de duas variáveis para rodar o transpilador, como por exemplo: somap (x,y,z).
- Colocar um return dentro do if e do else.
