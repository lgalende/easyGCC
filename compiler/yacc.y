%{

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
    program:        START code FINISH                      {}
                    ;

    code:           instruction                                 {}

                    | instruction code                          {}
                    ;

    instruction:    declaration END_OF_LINE                     {}

                    | assignment END_OF_LINE                    {}

                    | PRINT term END_OF_LINE                    {}

                    | READ INTO VARNAME END_OF_LINE             {}

                    | WHILE OPEN_PAR condition CLOSE_PAR REPEAT COLON code END         {}

                    | IF OPEN_PAR condition CLOSE_PAR DO COLON code END                {}

                    | IF OPEN_PAR condition CLOSE_PAR DO COLON code END else           {}
                    ;
    
    else:           ELSE DO COLON code END                      {}
                    ;

    condition:      expression comparator expression            {}

                    | condition AND condition                   {}

                    | condition OR condition                    {}

                    | OPEN_PAR condition CLOSE_PAR              {}
                    ;

    type:           NUMBER                                      {}
                    
                    | TEXT                                      {}
                    ;

    op:             PLUS                                        {}
                    
                    | MINUS                                     {}
                    
                    | MULTIPLY                                  {}

                    | DIVIDE                                    {}
                    ;
                    
    comparator:     GREATER                                     {}

                    | LOWER                                     {}

                    | EQUAL                                     {}

                    | DIFF                                      {}
                    ;

    expression:     term                                        {}

                    | expression op expression                  {}

                    | OPEN_PAR expression CLOSE_PAR             {}
                    ;

    term:           NUMBER_VAL                                  {}

                    | TEXT_VAL                                  {}

                    | VARNAME                                   {}
                    ;

    declaration:    CREATE type CALLED VARNAME                  {}
                    ;

    assignment:     SAVE term INTO VARNAME                      {}

                    | SAVE expression INTO VARNAME              {}
                    ;

%%