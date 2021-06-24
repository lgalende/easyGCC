%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"  /* archivo generado por yacc */
%}

number  -?[0-9]+
variable [a-zA-Z]([a-zA-Z0-9]|_|-)*
string \"[^\"]*\"

%%

"create"                { return CREATE; }
"number"                { return NUMBER; }
"text"                  { return TEXT; }
"called"                { return CALLED; }
"save"                  { return SAVE; }
"into"                  { return INTO; }
"print"                 { return PRINT; }
"read"                  { return READ; }
"is different from"     { return DIFF; }
"is equal to"           { return EQUAL; }
"is greater than"       { return GREATER; }
"is lower than"         { return LOWER; }
"plus"                  { return PLUS; }
"minus"                 { return MINUS; }
"multiplied by"         { return MULTIPLY; }
"divided by"            { return DIVIDE; }
"module"                { return MODULE; }
"or"                    { return OR; }
"and"                   { return AND; }
"if"                    { return IF; }
"else"                  { return ELSE; }
"while"                 { return WHILE; }
"repeat"                { return REPEAT; }
"do"                    { return DO; }
"("                     { return OPEN_PAR; }
")"                     { return CLOSE_PAR; }
":"                     { return COLON; }
"."                     { return END_OF_LINE; }
"main"                  { return MAIN; }
"start"                 { return START; }
"finish"                { return FINISH; }
"start ignoring"        { return START_IGNORING; }
"stop ignoring"         { return STOP_IGNORING; }
[\t \n]                 { /* if space, tab or new line, then nothing to do */ ; }

{number}    {
              strcpy(yylval.value, yytext);
              return NUMBER_VAL;
            }

{string}    {
              strcpy(yylval.value, yytext);
              return TEXT_VAL;
            }

{variable}  {
              strcpy(yylval.value, yytext);
              return VARNAME;
            }

.           { return yytext[0]; } /* si no hay match, devolvemos el caracter */

%%
