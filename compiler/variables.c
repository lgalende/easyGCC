#include <string.h>
#include "variables.h"
#include "node.h"

variable_t symbol_table[MAX_VAR_QTY];
unsigned int symbol_table_index = 0;

int add_var(char *var_name, char type, char is_const){
    if(symbol_table_index == MAX_VAR_QTY || 
        (type == TEXT && !is_palindrome(var_name)) || 
        (type == NUMBER && !has_even_length(var_name)))
        return -1;
    symbol_table[symbol_table_index].name = var_name;
    symbol_table[symbol_table_index].type = type;
    symbol_table[symbol_table_index].is_const = is_const;
    symbol_table_index++;

    return 0;
}

int get_var_type(char *var_name){
    for(int i=0; i < symbol_table_index; i++){
        if(strcmp(symbol_table[i].name, var_name) == 0)
            return symbol_table[i].type;
    }

    return -1;  // variable not found
}

int exists_var(char *var_name){
    return get_var_type(var_name) != -1; // boolean
}

int is_var_const(char *var_name){
    for(int i=0; i < symbol_table_index; i++){
        if(strcmp(symbol_table[i].name, var_name) == 0)
            return symbol_table[i].is_const;
    }

    return -1;  // variable not found, shouldn't happen
}

int is_palindrome(char * name){
    int left = 0;
    int right = strlen(name) - 1;

    while (left > right)
        if (name[left++] != name[right--])
            return 0;
    return 1;
}

int has_even_length(char * name){
    return strlen(name)%2 == 0;
}