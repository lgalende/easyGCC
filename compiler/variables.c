#include <string.h>
#include "variables.h"
#include "node.h"

variable_t symbol_table[MAX_VAR_QTY];
unsigned int symbol_table_index = 0;

char add_var(char *var_name, char type, char is_const)
{
    if (symbol_table_index == MAX_VAR_QTY ||
        (type == TEXT_T && !is_palindrome(var_name)) ||
        (type == NUMBER_T && !has_even_length(var_name)))
        return -1;

    symbol_table[symbol_table_index].name = var_name;
    symbol_table[symbol_table_index].type = type;
    symbol_table[symbol_table_index].is_const = is_const;
    symbol_table_index++;

    return 0;
}

char get_var_type(char *var_name)
{
    char ret = -1;

    for (int i = 0; i < symbol_table_index; i++)
    {
        if (strcmp(symbol_table[i].name, var_name) == 0)
        {
            ret = symbol_table[i].type;
            break;
        }
    }
    return ret; // if -1 --> variable not found
}

char exists_var(char *var_name)
{
    return get_var_type(var_name) != -1; // boolean
}

char is_var_const(char *var_name)
{
    char ret = -1;

    for (int i = 0; i < symbol_table_index; i++)
    {
        if (strcmp(symbol_table[i].name, var_name) == 0)
        {
            ret = symbol_table[i].is_const;
            if (ret == 1)                     // constante sin inicializar
                symbol_table[i].is_const = 2; // constante inicializada
            break;
        }
    }

    return ret; // if -1 --> variable not found, shouldn't happen
}

int is_palindrome(char *name)
{
    int left = 0;
    int right = strlen(name) - 1;

    while (left > right)
        if (name[left++] != name[right--])
            return 0;
    return 1;
}

int has_even_length(char *name)
{
    return strlen(name) % 2 == 0;
}