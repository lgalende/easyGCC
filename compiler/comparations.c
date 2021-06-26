#include "comparations.h"
#include <string.h>

node_t *make_comparation(node_t *n1, node_t *comp, node_t *n2)
{
    node_t *ret;
    if (comp->type == COMPARATION)
    {
        if (is_number(n1) && is_number(n2))
        {
            ret = create_node(NUMBER_T, NULL); // Esta bien que sea null???
            append_node(ret, n1);
            append_node(ret, create_node(CONSTANT, " "));
            append_node(ret, comp);
            append_node(ret, create_node(CONSTANT, " "));
            append_node(ret, n2);
        }
        else if (is_text(n1) && is_text(n2))
        {
            ret = create_node(TEXT_T, NULL);
            append_node(ret, create_node(CONSTANT, "strcmp("));
            append_node(ret, n1);
            append_node(ret, create_node(CONSTANT, ", "));
            append_node(ret, n2);
            append_node(ret, create_node(CONSTANT, ")"));
            append_node(ret, comp);
            append_node(ret, create_node(CONSTANT, "0"));
        }
        else
            yyerror("Plus operation can only be made with both expressions of the same type(eg.NUMBER plus NUMBER).\n");
        return ret;
    }
}