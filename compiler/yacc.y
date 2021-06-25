%{
    #include <stdio.h>
    #include "node.h"
    #include "operations.h"
    #include "compiler.h"
    int yylex();
%}


%union{
    node_t *node;
    char value[1024];
}

/* Tokens */

%token START FINISH 
%token PRINT END_OF_LINE READ CREATE CALLED SAVE INTO OPEN_PAR CLOSE_PAR COLON
%token WHILE REPEAT IF DO END ELSE 
%token AND OR PLUS MINUS MULTIPLY DIVIDE GREATER LOWER EQUAL DIFF
%token NUMBER TEXT

%type<node> program code instruction declaration assignment term condition else expression comparator type op

%token<value> NUMBER_VAL TEXT_VAL VARNAME

%start  program


/* Producciones */

%%
    program:        START code FINISH                           {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, create_node(CONSTANT, "int main(){"));
                                                                    append_node($$, $2);
                                                                    append_node($$, create_node(CONSTANT, "return 0;}"));
                                                                    print_headers()
                                                                }
                    ;

    code:           instruction                                 {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $1);
                                                                }

                    | instruction code                          {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $1);
                                                                    append_node($$, $2);
                                                                }

                    //TODO Agregar produccion LAMDA
                    ;

    instruction:    declaration END_OF_LINE                     {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $1);
                                                                    append_node($$, create_node(CONSTANT, ";"));
                                                                }

                    | assignment END_OF_LINE                    {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $1);
                                                                    append_node($$, create_node(CONSTANT, ";"));
                                                                }

                    | PRINT term END_OF_LINE                    {   $$ = create_node(EMPTY, NULL);
                                                                    if($2->type == NUMBER)
                                                                        append_node($$, create_node(CONSTANT, "printf(\"%d\", "));
                                                                    if($2->type == TEXT)
                                                                        append_node($$, create_node(CONSTANT, "printf(\"%s\", "));
                                                                    append_node($$, $2);
                                                                    append_node($$, create_node(CONSTANT, ");"));
                                                                }

                    | READ INTO VARNAME END_OF_LINE             {   $$ = create_node(EMPTY, NULL);
                                                                    if($3->type == NUMBER)
                                                                        append_node($$, create_node(CONSTANT, "scanf(\"%d\", &"));
                                                                    if($3->type == TEXT)
                                                                        append_node($$, create_node(CONSTANT, "scanf(\"%s\", "));
                                                                    append_node($$, $3);
                                                                    append_node($$, create_node(CONSTANT, ");"));
                                                                }

                    | WHILE OPEN_PAR condition CLOSE_PAR REPEAT COLON code END          {   $$ = create_node(EMPTY, NULL);
                                                                                            append_node($$, create_node(CONSTANT, "while("));
                                                                                            append_node($$, $3);
                                                                                            append_node($$, create_node(CONSTANT, "){"));
                                                                                            append_node($$, $7);
                                                                                            append_node($$, create_node(CONSTANT, "}"));
                                                                                        }

                    | IF OPEN_PAR condition CLOSE_PAR DO COLON code END else            {
                                                                                            $$ = create_node(EMPTY, NULL);
                                                                                            append_node($$, create_node(CONSTANT, "if("));
                                                                                            append_node($$, $3);
                                                                                            append_node($$, create_node(CONSTANT, "){"));
                                                                                            append_node($$, $7);
                                                                                            append_node($$, create_node(CONSTANT, "}"));
                                                                                            append_node($$, $9);
                                                                                        }
                    }
                    ;
    
    else:           ELSE DO COLON code END                      {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, create_node(CONSTANT, "else{"));
                                                                    append_node($$, $4);
                                                                    append_node($$, create_node(CONSTANT, "}"));
                                                                }

                    // TODO AGREGAR PRODUCCION LAMDA
                    ;

    condition:      expression comparator expression            {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $1);
                                                                    append_node($$, $2);
                                                                    append_node($$, $3);
                                                                }

                    | condition AND condition                   {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $1);
                                                                    append_node($$, create_node(CONSTANT, " && "));
                                                                    append_node($$, $3);
                                                                }

                    | condition OR condition                    {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $1);
                                                                    append_node($$, create_node(CONSTANT, " || "));
                                                                    append_node($$, $3);
                                                                }

                    | OPEN_PAR condition CLOSE_PAR              {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, create_node(CONSTANT, "( "));
                                                                    append_node($$, $2);
                                                                    append_node($$, create_node(CONSTANT, " )"));
                                                                }
                    ;

    type:           NUMBER                                      {   $$ = create_node(NUMBER, "int ");   }
                    
                    | TEXT                                      {   $$ = create_node(NUMBER, "char* ");   }
                    ;

    op:             PLUS                                        {   $$ = create_node(OPERATION, "+");   }
                    
                    | MINUS                                     {   $$ = create_node(OPERATION, "-");   }
                    
                    | MULTIPLY                                  {   $$ = create_node(OPERATION, "*");   }

                    | DIVIDE                                    {   $$ = create_node(OPERATION, "/");   }
                    ;
                    
    comparator:     GREATER                                     {   $$ = create_node(CONSTANT, " > ");   }

                    | LOWER                                     {   $$ = create_node(CONSTANT, " < ");   }

                    | EQUAL                                     {   $$ = create_node(CONSTANT, " == ");   }

                    | DIFF                                      {   $$ = create_node(CONSTANT, " != ");   }
                    ;

    expression:     term                                        {   $$ = $1;    }

                    | expression op expression                  {   $$ = make_expression($1, $2, $3);   }

                    | OPEN_PAR expression CLOSE_PAR             {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, create_node(CONSTANT, "( "));
                                                                    append_node($$, $2);
                                                                    append_node($$, create_node(CONSTANT, " )"));}
                    ;

    term:           NUMBER_VAL                                  {   $$ = create_node(NUMBER, $1);   }

                    | TEXT_VAL                                  {   $$ = create_node(TEXT, $1);   }

                    | VARNAME                                   {   $$ = create_node(CONSTANT, $1);   }
                    ;

    declaration:    CREATE type CALLED VARNAME                  {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $2);
                                                                    append_node($$, create_node(CONSTANT, $4));
                                                                }
                    ;

    assignment:     SAVE expression INTO VARNAME              {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, create_node(CONSTANT, $4));
                                                                    append_node($$, create_node(CONSTANT, " = "));
                                                                    append_node($$, $2);
                                                                }
                    ;

%%