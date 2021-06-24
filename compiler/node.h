#ifndef NODE_H
#define NODE_H

#include <stdio.h>
#include <stdlib.h>

typedef enum types {TEXT, NUMBER, CONSTANT, EMPTY, OPERATION} type;

typedef struct node_t {
    type type;
    char * value;

    struct node_t * parent;
    struct node_t * children;
    struct node_t * next;
} node_t;

node_t * create_node(type type, char * value);
void append_node(node_t * parent, node_t * node);
#endif