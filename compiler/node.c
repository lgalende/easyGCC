#include "node.h"
#include "compiler.h"
#include <stdio.h>
#include <stdlib.h>

node_t *create_node(type type, char *value)
{
    node_t *n = malloc(sizeof(node_t));
    n->value = value;
    n->type = type;
    n->children = NULL;
    n->next = NULL;
    n->parent = NULL;

    return n;
}

void append_node(node_t *parent, node_t *node)
{
    if (node == NULL || parent == NULL)
        return;
    if (parent->children == NULL)
        parent->children = node;
    else
    {
        node_t *n = parent->children;
        while (n->next != NULL)
        {
            n = n->next;
        }
        n->next = node;
    }
    node->parent = parent;
}

void spit_out_code(node_t *node)
{
    // if (node->type == EMPTY)
    // {
    //     node_t *aux = node->children;
    //     while (aux != NULL)
    //     {
    //         spit_out_code(aux);
    //         aux = aux->next;
    //     }
    // }
    // else if (node->type != EMPTY && node->value != NULL)
    // {
    //     fprintf(c_file, "%s", node->value);
    // }
    if (node->value != EMPTY && node->value != NULL)
    {
        fprintf(c_file, "%s", node->value);
    }
    else
    {
        node_t *aux = node->children;
        while (aux != NULL)
        {
            spit_out_code(aux);
            aux = aux->next;
        }
    }
}