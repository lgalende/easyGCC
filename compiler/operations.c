#include "operations.h"
#include <string.h>

node_t *plus_expression(node_t *op, node_t *n1, node_t *n2);
node_t *number_operation(node_t *op, node_t *n1, node_t *n2);
node_t *expressions(node_t *op, node_t *n1, node_t *n2);

extern int yyerror(char *msg);

node_t *make_expression(node_t *n1, node_t *op, node_t *n2)
{
    node_t *ret;
    if (op->type == OPERATION)
    {
        switch (op->value[0])
        {
        case '+':
            ret = plus_expression(op, n1, n2);
            break;
        case '-':
        case '*':
            ret = expressions(op, n1, n2);
            break;
        case '%':
        case '/':
            if (is_zero(n2))
                yyerror("Cannot divide by cero. Expression on the rigth of the division must not be equal to cero.\n");
            else
                ret = expressions(op, n1, n2);
            break;
        }
        return ret;
    }
}

node_t *number_operation(node_t *op, node_t *n1, node_t *n2)
{
    node_t *ret = create_node(NUMBER_T, NULL); //TODO: revisar. Es NUMBER_T o EMPTY?
    append_node(ret, n1);
    append_node(ret, op);
    append_node(ret, n2);
    return ret;
}

node_t *plus_expression(node_t *op, node_t *n1, node_t *n2)
{
    node_t *ret;
    if (is_number(n1) && is_number(n2))
        ret = number_operation(op, n1, n2);
    else if (is_text(n1) && is_text(n2))
    {
        ret = create_node(TEXT_T, NULL);
        append_node(ret, create_node(CONSTANT, "sum_strings("));
        append_node(ret, n1);
        append_node(ret, create_node(CONSTANT, ", "));
        append_node(ret, n2);
        append_node(ret, create_node(CONSTANT, ");"));
    }
    else
        yyerror("Plus operation can only be made with both expressions of the same type(eg.NUMBER plus NUMBER).\n");
    return ret;
}

node_t *expressions(node_t *op, node_t *n1, node_t *n2)
{
    node_t *ret;
    if (is_number(n1) && is_number(n2))
        ret = number_operation(op, n1, n2);
    else
        yyerror("The operation can only be made with both expressions as a NUMBER type.\n");
    return ret;
}