#ifndef NODE_H
#define NODE_H

#include <stdio.h>
#include <stdlib.h>

typedef enum types {TEXT, NUM, SIMBOL, EMPTY} type;

typedef struct Node_t {
    type type;
    char * value;

    struct Node_t * parent;
    struct Node_t * children;
    struct Node_t * next;
} Node_t;

Node_t * createNode(type type, char * value);
void appendNode(Node_t * parent, Node_t * node);
#endif