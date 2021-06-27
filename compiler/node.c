#include "node.h"
#include "compiler.h"
#include <stdio.h>
#include <stdlib.h>

extern FILE *c_file;

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

void free_node(node_t *node)
{
    if (node->children != NULL)
        free_node(node->children);
    if (node->next != NULL)
        free_node(node->next);
    free(node);
}

void spit_out_code(node_t *node)
{
    if (node->type != EMPTY && node->value != NULL)
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