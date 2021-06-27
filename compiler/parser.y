%{
    #include <stdio.h>
    #include <string.h>
    #include "node.h"
    #include "compiler.h"
    #include "variables.h"
    #include "operations.h"
    #include "comparations.h"

    #define MAX_VALUE_SIZE 1024

    extern int line_no;
    int yylex();
    int assignment_count = 0;
    int please_count = 0;

    void yyerror(char *msg);
    void check_var(char *varname, type type);
    void define_array_var(node_t *parent, node_t *expression, char *varname, char *val);
%}


%union{
    struct node_t *node;
    char *value;
}

/* Tokens */

%token START FINISH 
%token PRINT END_OF_LINE READ CREATE CONST CALLED SAVE INTO OPEN_PAR CLOSE_PAR COLON PLEASE
%token WHILE REPEAT IF DO END ELSE 
%token AND OR PLUS MINUS MULTIPLY DIVIDE MODULE GREATER LOWER EQUAL DIFF
%token NUMBER TEXT LISTOF WITH ITEMS ITEM

%type<node> program code instruction declaration assignment term condition else expression comparator type op

%token<value> NUMBER_VAL TEXT_VAL VARNAME

%start  program

%left PLUS MINUS
%left MULTIPLY DIVIDE
%nonassoc EQUAL DIFF GREATER LOWER
%left AND
%left OR


/* Producciones */

%%
    program:        START code FINISH                           {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, create_node(CONSTANT, "int main(){"));
                                                                    append_node($$, $2);
                                                                    append_node($$, create_node(CONSTANT, "return 0;}"));
                                                                    if(assignment_count > 0 && (float) please_count/assignment_count < 0.75f){
                                                                        yyerror("You are so rude. Try being more polite.");
                                                                    }
                                                                    print_headers();
                                                                    spit_out_code($$);
                                                                }
                    ;

    code:           instruction                                 {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $1);
                                                                }

                    | instruction code                          {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $1);
                                                                    append_node($$, $2);
                                                                }

                    |                                           { $$ = NULL;}
                    ;

    instruction:    declaration END_OF_LINE                     {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $1);
                                                                    append_node($$, create_node(CONSTANT, ";"));
                                                                }

                    | assignment END_OF_LINE                    {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $1);
                                                                    append_node($$, create_node(CONSTANT, ";"));
                                                                }

                    | PRINT term END_OF_LINE                    {   
                                                                    $$ = create_node(EMPTY, NULL);
                                                                    if($2->type == NUMBER_T)
                                                                        append_node($$, create_node(CONSTANT, "printf(\"%d\\n\", "));
                                                                    if($2->type == TEXT_T)
                                                                        append_node($$, create_node(CONSTANT, "printf(\"%s\", "));
                                                                    append_node($$, $2);
                                                                    append_node($$, create_node(CONSTANT, ");"));
                                                                }

                    | READ INTO VARNAME END_OF_LINE             {   check_var($3,-1);
                                                                    int var_type = get_var_type($3);
                                                                    $$ = create_node(EMPTY, NULL);
                                                                    if(var_type == NUMBER_T)
                                                                        append_node($$, create_node(CONSTANT, "scanf(\"%d\", &"));
                                                                    if(var_type == TEXT_T)
                                                                        append_node($$, create_node(CONSTANT, "scanf(\"%s\", "));
                                                                    append_node($$, create_node(var_type,$3));
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
                    ;
    
    else:           ELSE DO COLON code END                      {   $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, create_node(CONSTANT, "else{"));
                                                                    append_node($$, $4);
                                                                    append_node($$, create_node(CONSTANT, "}"));
                                                                }

                    |                                           { $$ = NULL;}
                    ;

    condition:      expression comparator expression            {   $$ = make_comparation($1, $2, $3); }

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

    type:           NUMBER                                      {   $$ = create_node(NUMBER_T, "int ");   }
                    
                    | TEXT                                      {   $$ = create_node(TEXT_T, "char* ");   }
                    ;

    op:             PLUS                                        {   $$ = create_node(OPERATION, "+");   }
                    
                    | MINUS                                     {   $$ = create_node(OPERATION, "-");   }
                    
                    | MULTIPLY                                  {   $$ = create_node(OPERATION, "*");   }

                    | DIVIDE                                    {   $$ = create_node(OPERATION, "/");   }

                    | MODULE                                    {   $$ = create_node(OPERATION, "%");   }
                    ;
                    
    comparator:     GREATER                                     {   $$ = create_node(COMPARATION, ">");   }

                    | LOWER                                     {   $$ = create_node(COMPARATION, "<");   }

                    | EQUAL                                     {   $$ = create_node(COMPARATION, "==");   }

                    | DIFF                                      {   $$ = create_node(COMPARATION, "!=");   }
                    ;

    expression:     term                                        {   $$ = $1;    }

                    | expression op expression                  {   $$ = make_expression($1, $2, $3);   }

                    | OPEN_PAR expression CLOSE_PAR             {   $$ = create_node($2->type, NULL);
                                                                    append_node($$, create_node(CONSTANT, "( "));
                                                                    append_node($$, $2);
                                                                    append_node($$, create_node(CONSTANT, " )"));}
                    ;

    term:           NUMBER_VAL                                  {   $$ = create_node(NUMBER_T, $1);   }

                    | TEXT_VAL                                  {   $$ = create_node(TEXT_T, $1);   }

                    | VARNAME                                   {   
                                                                    int var_type = get_var_type($1);
                                                                    if(var_type == -1)
                                                                        yyerror("Undefined variable");
                                                                    $$ = create_node(var_type, $1);   
                                                                }
                    
                    | VARNAME ITEM NUMBER_VAL                   {   
                                                                    int var_type = get_var_type($1);
                                                                    if(var_type == -1)
                                                                        yyerror("Undefined variable");

                                                                    // char str[MAX_VALUE_SIZE+2+4+1];
                                                                    // strcat(str,$1);
                                                                    // strcat(str,"[");
                                                                    // strcat(str,$3);
                                                                    // strcat(str,"]");
                                                                    //$$ = create_node(var_type, str);
                                                                    $$ = create_node(var_type, NULL); //TODO: revisar
                                                                    append_node($$, create_node(var_type, $1));
                                                                    append_node($$, create_node(CONSTANT,"["));
                                                                    append_node($$, create_node(NUMBER_T,$3));
                                                                    append_node($$,create_node(CONSTANT,"]"));
                                                                }

                    | VARNAME ITEM VARNAME                      {   
                                                                    int var_type = get_var_type($1);
                                                                    if(var_type == -1 || get_var_type($3) == -1)
                                                                        yyerror("Undefined variable");

                                                                    char str[MAX_VALUE_SIZE+2+MAX_VALUE_SIZE+1];
                                                                    strcat(str,$1);
                                                                    strcat(str,"[");
                                                                    strcat(str,$3);
                                                                    strcat(str,"]");
                                                                
                                                                    $$ = create_node(var_type, str); 
                                                                }
                    ;

    declaration:    CREATE type CALLED VARNAME                  {   if(exists_var($4))
                                                                        yyerror("Variable already exists");
                                                                    add_var($4, $2->type, 0); // const = false
                                                                    $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $2);
                                                                    append_node($$, create_node($2->type, $4));
                                                                    if($2->type == TEXT_T){
                                                                        append_node($$,create_node(CONSTANT," = malloc(1024)"));
                                                                    }
                                                                }

                    | CREATE CONST type CALLED VARNAME          {   if(exists_var($5))
                                                                        yyerror("Variable already exists");
                                                                    add_var($5, $3->type, 1); // const = true
                                                                    $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, $3);
                                                                    append_node($$, create_node($3->type, $5));
                                                                }
                    | CREATE LISTOF type WITH NUMBER_VAL ITEMS CALLED VARNAME   {   if(exists_var($8))
                                                                                        yyerror("Variable already exists");
                                                                                    if($3->type != NUMBER_T)
                                                                                        yyerror("Cannot create TEXT array");
                                                                                    add_var($8, $3->type, 0); // const = false
                                                                                    $$ = create_node(EMPTY,NULL);
                                                                                    append_node($$,$3);
                                                                                    append_node($$,create_node($3->type,$8));
                                                                                    append_node($$, create_node(CONSTANT,"["));
                                                                                    append_node($$, create_node(NUMBER_T,$5));
                                                                                    append_node($$,create_node(CONSTANT,"]"));
                                                                                }
                    ;

    assignment:     SAVE expression INTO VARNAME                {   check_var($4, $2->type);
                                                                    $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, create_node($2->type, $4));
                                                                    append_node($$, create_node(CONSTANT, " = "));
                                                                    append_node($$, $2);
                                                                    assignment_count++;
                                                                }
                    | PLEASE SAVE expression INTO VARNAME       {   
                                                                    check_var($5, $3->type);
                                                                    $$ = create_node(EMPTY, NULL);
                                                                    append_node($$, create_node($3->type, $5));
                                                                    append_node($$, create_node(CONSTANT, " = "));
                                                                    append_node($$, $3);
                                                                    assignment_count++;
                                                                    please_count++;
                                                                }
                                                            
                    | PLEASE SAVE expression INTO VARNAME ITEM NUMBER_VAL           {   
                                                                                        check_var($5, $3->type);
                                                                                        $$ = create_node(EMPTY, NULL);
                                                                                        define_array_var($$, $3, $5, $7);
                                                                                        assignment_count++;
                                                                                        please_count++;
                                                                                    }
                    | SAVE expression INTO VARNAME ITEM NUMBER_VAL                  {   
                                                                                        check_var($4, $2->type);
                                                                                        $$ = create_node(EMPTY, NULL);
                                                                                        define_array_var($$, $2, $4, $6);
                                                                                        assignment_count++;
                                                                                    }

                    | PLEASE SAVE expression INTO VARNAME ITEM VARNAME              {   
                                                                                        check_var($5, $3->type);
                                                                                        check_var($7, NUMBER_T);
                                                                                        $$ = create_node(EMPTY, NULL);
                                                                                        define_array_var($$, $3, $5, $7);
                                                                                        assignment_count++;
                                                                                        please_count++;
                                                                                        
                                                                                    }
                    | SAVE expression INTO VARNAME ITEM VARNAME                     {   
                                                                                        check_var($4, $2->type);
                                                                                        check_var($6, NUMBER_T);
                                                                                        $$ = create_node(EMPTY, NULL);
                                                                                        define_array_var($$, $2, $4, $6);
                                                                                        assignment_count++;
                                                                                    }
                    ;

%%

void yyerror(char *msg){
    fprintf(stderr, "Error in line %d: %s\n", line_no, msg);

    //liberar recursos

    exit(1);
}

void check_var(char *varname, type type){
    int node_type = get_var_type(varname);
    if(node_type == -1)
        yyerror("Undefined variable");
    if(type != -1 && node_type != type)
        yyerror("Incompatible types in variable assignment");
    if(is_var_const(varname) == 2)
        yyerror("Trying to modify const value");
}

void define_array_var(node_t *parent, node_t *expression, char *varname, char *val){
    append_node(parent, create_node(expression->type, varname));
    append_node(parent, create_node(CONSTANT,"["));
    append_node(parent, create_node(NUMBER_T,val));
    append_node(parent,create_node(CONSTANT,"]"));
    append_node(parent, create_node(CONSTANT, " = "));
    append_node(parent, expression);
}