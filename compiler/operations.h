#ifndef OPERATIONS_H
#define OPERATIONS_H

#include "node.h"

#define TRUE 1
#define FALSE 0

node_t *make_expression(node_t *n1, node_t *op, node_t *n2);

#endif