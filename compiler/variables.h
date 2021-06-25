#ifndef VARIABLES_H
#define VARIABLES_H

#define MAX_VAR_QTY 50

typedef struct variable
{
    char *name;
    char type;     // tomara los valores TEXT o NUMBER, correspondientes a enum types definido en node.h
    char is_const; // 0 si es variable, 1 si es constante sin inicializar, 2 si es constante inicializada
} variable_t;

char add_var(char *var_name, char type, char is_const);
char get_var_type(char *var_name);
char exists_var(char *var_name);
char is_var_const(char *var_name);

#endif //VARIABLES_H
