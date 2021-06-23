%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"  /* archivo generado por yacc */
%}

number  -?[0-9]+
variable [a-zA-Z]([a-zA-Z0-9]|_|-)*

%%

"create"                { return CREATE; }
"number"                { return NUMBER; }
"text"                  { return TEXT; }
"called"                { return CALLED; }
"save into"             { return SAVE; }
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
/* . ( ) “ “ : */
"."                     { return END_OF_LINE; }
"main"                  { return MAIN; }
"start"                 { return START; }
"finish"                { return FINISH; }

%%
