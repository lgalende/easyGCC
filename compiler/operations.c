#include "operations.h"
#include <string.h>
#include "node.h"

node_t *plus_expression(node_t *n1, node_t *n2);
node_t *number_operation(char *op, node_t *n1, node_t *n2);
node_t *expressions(char *op, node_t *n1, node_t *n2);

typedef enum operations
{
    PLUS,
    MINUS,
    DIVIDE,
    MULTIPLY
} operation;

node_t *make_expression(node_t *n1, node_t *op, node_t *n2)
{
    node_t *ret;
    if (op->type == OPERATION)
    {
        switch (op->value[0])
        {
        case '+':
            return plus_expression(n1, n2);
            break;
        case '-':
            ret = expressions(" - ", n1, n2);
            if (ret->type == EMPTY)
            {
                //ERROR
                //TODO Poner en ret empty y devolver.
                return;
            }
            break;
        case '*':
            ret = expressions(" * ", n1, n2);
            if (ret->type == EMPTY)
            {
                //ERROR
                //TODO Poner en ret empty y devolver.
                return;
            }
            break;
        case '/':
            //VERIFICAR SI n2 ES 0
            if (is_zero(n2))
            {
                //ERRORRRRRRRR No se puede dividir por cero
            }
            else
            {
                ret = expressions(" / ", n1, n2);
                if (ret->type == EMPTY)
                {
                    //ERROR
                    //TODO Poner en ret empty y devolver.
                    return;
                }
            }
            break;

        default:
            break;
        }

        return ret;
    }
}

int is_number(node_t *n)
{
    return n->type == NUMBER_T;
}

int is_text(node_t *n)
{
    return n->type == TEXT_T;
}

int is_zero(node_t *n)
{
    return is_number(n) && n->value == 0;
}

node_t *number_operation(char *op, node_t *n1, node_t *n2)
{
    node_t *ret = create_node(EMPTY, NULL);
    append_node(ret, n1);
    append_node(ret, create_node(CONSTANT, op));
    append_node(ret, n2);
    return ret;
}

node_t *plus_expression(node_t *n1, node_t *n2)
{
    node_t *ret;
    if (is_number(n1) && is_number(n2))
        ret = number_operation(" + ", n1, n2);
    else if (is_text(n1) && is_text(n2))
    {
        ret = create_node(EMPTY, NULL);
        append_node(ret, create_node(CONSTANT, "sum_strings(")); //TODO crear esto
        append_node(ret, n1);
        append_node(ret, ",");
        append_node(ret, n2);
        append_node(ret, ");");
    }
    else
    {
        //ERROR, No se puede hacer dicha operacion
        ret = create_node(EMPTY, NULL); //Poner NULL en ret?
        return;
    }
    return ret;
}

node_t *expressions(char *op, node_t *n1, node_t *n2)
{
    node_t *ret;
    if (is_number(n1) && is_number(n2))
        ret = number_operation(op, n1, n2);
    else
        ret = create_node(EMPTY, NULL); //Poner null en ret y devolverlo?
    return ret;
}