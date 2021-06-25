#include "node.h"
#include <stdio.h>
#include <stdlib.h>

node_t * create_node(type type, char * value){
    node_t * n = malloc(sizeof(node_t));
    n->type = type;
    n->value = value;
    n->children = NULL;
    n->next = NULL;
    n->parent = NULL;
    return n;
}

void append_node(node_t * parent, node_t * node){
    if(node == NULL || parent == NULL)
        return;
    if(parent->children == NULL)
        parent->children = node;
    else {
        node_t * n = parent->children;
        while (n->next != NULL){
            n = n->next;
        }
        n->next = node;
    }
    node->parent = parent;
}

void spitOutCode(node_t * node) {
    if(node->type == EMPTY) {
        node_t * aux = node->children;
        while(aux != NULL) {
            printInorder(aux);
            aux = aux->next;
        }
    }else if(node->type != EMPTY && node->value != NULL) {
        FILE *output;
        fprintf(output, "%s", node->value);
    }

}