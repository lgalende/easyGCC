#include "node.h"
#include <stdio.h>

Node_t * createNode(type type, char * value){
    Node_t * n = malloc(sizeof(Node_t));
    n->type = type;
    n->value = value;
    n->children = NULL;
    n->next = NULL;
    n->parent = NULL;
    return n;
}

void appendNode(Node_t * parent, Node_t * node){
    if(node == NULL || parent == NULL)
        return;
    if(parent->children == NULL)
        parent->children = node;
    else {
        Node_t * n = parent->children;
        while (n->next != NULL){
            n = n->next;
        }
        n->next = node;
    }
    node->parent = parent;
}