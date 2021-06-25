#include "operations.h"
#include <string.h>

typedef enum operations {PLUS, MINUS, DIVIDE, MULTIPLY} operation;

node_t * make_expression(node_t * exp1, node_t * op, node_t * exp2){
    node_t * ret;
    if(op->type == OPERATION){
        switch (op->value[0])
        {
        case '+':
            return plus_expression(exp1, exp2);
            break;
        case '-':
            return minus_expression(exp1, exp2);
            break;
        case '*':
            return multiply_expression(exp1, exp2);
            break;
        case '/':
            return divide_expression(exp1, exp2);
            break;
        
        default:
            break;
        }
    }
    
}

node_t * number_operation(operation op, node_t * n1, node_t * n2){

}

node_t * plus_expression(node_t * n1, node_t * n2){
    node_t * ret;
    if(n1->type == NUMBER && n2->type == NUMBER)
        ret = number_operation(PLUS, n1, n2);
    else
        //SEGUIR DESDE ACA
    return ret;
}

node_t * minus_expression(node_t * exp1, node_t * exp2){

}

node_t * multiply_expression(node_t * exp1, node_t * exp2){

}

node_t * divide_expression(node_t * exp1, node_t * exp2){

}