#ifndef VARIABLES_H
#define VARIABLES_H

#define MAX_VAR_QTY 50

typedef struct variable {
    char *name;
    char type;  // tomara los valores TEXT o NUMBER, correspondientes a enum types definido en node.h
    char is_const;  // boolean
} variable_t;

int add_var(char *var_name, char type, char is_const);
int get_var_type(char *var_name);
int exists_var(char *var_name);
int is_var_const(char *var_name);

#endif //VARIABLES_H
