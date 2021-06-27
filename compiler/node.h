#ifndef NODE_H
#define NODE_H

#include <stdio.h>
#include <stdlib.h>

typedef enum types
{
    TEXT_T,
    NUMBER_T,
    CONSTANT,
    EMPTY,
    OPERATION,
    COMPARATION
} type;

typedef struct node_t
{
    type type;
    char *value;

    struct node_t *parent;
    struct node_t *children;
    struct node_t *next;
} node_t;

node_t *create_node(type type, char *value);
void append_node(node_t *parent, node_t *node);
void spit_out_code(node_t *node);
int is_number(node_t *n);
int is_text(node_t *n);
int is_zero(node_t *n);
#endif