%{
	#include <stdio.h>
	#include <stdlib.h>
  #include <string.h>
	#include "y.tab.h"  /* archivo generado por yacc */

  int line_no = 1;
%}

%option noyywrap

number  -?[0-9]+
variable [a-zA-Z]([a-zA-Z0-9]|_|-)*
string \"[^\"]*\"

%%

"create"                { return CREATE; }
"const"                 { return CONST; }
"number"                { return NUMBER; }
"text"                  { return TEXT; }
"list of"               { return LISTOF; }
"with"                  { return WITH; }
"items"                 { return ITEMS; }
"item"                  { return ITEM; }
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
"end"                   { return END; }
"("                     { return OPEN_PAR; }
")"                     { return CLOSE_PAR; }
":"                     { return COLON; }
"."                     { return END_OF_LINE; }
"\n"                    { line_no++; }
"start"                 { return START; }
"finish"                { return FINISH; }
"please"                { return PLEASE;}
[\t ]                 { /* if space, tab or new line, then nothing to do */ ; }

{number}    {
              char *s = malloc(strlen(yytext)+1);
              strcpy(s, yytext);
              yylval.value = s;
              return NUMBER_VAL;
            }

{string}    {
              char *s = malloc(strlen(yytext)+1);
              strcpy(s, yytext);
              yylval.value = s;
              return TEXT_VAL;
            }

{variable}  {
              char *s = malloc(strlen(yytext)+1);
              strcpy(s, yytext);
              yylval.value = s;
              return VARNAME;
            }

.           { return yytext[0]; } /* si no hay match, devolvemos el caracter */

%%
