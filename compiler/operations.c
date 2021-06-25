#include "operations.h"
#include <string.h>

typedef enum operations {PLUS, MINUS, DIVIDE, MULTIPLY} operation;

node_t * make_expression(node_t * n1, node_t * op, node_t * n2){
    node_t * ret;
    if(op->type == OPERATION){
        switch (op->value[0])
        {
        case '+':
            return plus_expression(n1, n2);
            break;
        case '-':
            ret = expressions(" - ", n1, n2);
            if( ret->type == EMPTY){
                //ERROR
                //TODO Poner en ret empty y devolver.
                return;
            } 
            break;
        case '*':
            ret = expressions(" * ", n1, n2);
            if( ret->type == EMPTY){
                //ERROR
                //TODO Poner en ret empty y devolver.
                return;
            }
            break;
        case '/':
            ret = expressions(" / ", n1, n2);
            if( ret->type == EMPTY){
                //ERROR
                //TODO Poner en ret empty y devolver.
                return;
            } 
            break;
        
        default:
            break;
        }

        return ret;
    }
    
}

int isNumber(node_t * n){
    if(n->type == NUMBER || n->type == NUMBER_VARIABLE)
        return TRUE;
    return FALSE;
}

int isText(node_t * n){
    if(n->type == TEXT)
        return TRUE;
    return FALSE;
}

int isNumberVariable(node_t * n){
    if(n->type == NUMBER_VARIABLE)
        return TRUE;
    return FALSE;
}

/*int isTextVariable(node_t * n){
    if(n->type == TEXT_VARIABLE)
        return TRUE;
    return FALSE;
}*/

node_t * number_operation(char * op, node_t * n1, node_t * n2){
    node_t * ret = create_node(EMPTY, NULL);
    append(ret, n1);
    append(ret, op);
    append(ret, n2);
    return ret;
}

node_t * plus_expression(node_t * n1, node_t * n2){
    node_t * ret;
    if(isNumber(n1) && isNumber(n2))
        ret = number_operation(" + ", n1, n2);
    else if(isText(n1) && isText(n2)){
        ret = create_node(EMPTY, NULL);
        /*append(ret, "strcat(strcat(");
        append(ret, n1);
        append(ret, ",\" + \"), ");
        append(ret, n2);*/
        //ACA HACER EL STRCAT. Crear funcion para concatenar strings?
    } else {
        //ERROR, No se puede hacer dicha operacion
        ret = create_node(EMPTY, NULL); //Poner NULL en ret?
        return;
    }
    return ret;
}

node_t * minus_expression(node_t * n1, node_t * n2){
    node_t * ret;
    if(isNumber(n1) && isNumber(n2))
        ret = number_operation(" - ", n1, n2);
    else{
        //ERROR, unicamente se puede restar dos NUMBER
        ret = create_node(EMPTY, NULL); //Poner NULL en ret?
        return;
    }
    return ret;
}

node_t * divide_expression(char * op, node_t * n1, node_t * n2){
    node_t * ret;
    if(isNumber(n1) && isNumber(n2)){
        if(isNumberVariable(n2)){
            //Verificar que esa variable no sea 0
        }else if(n2->value == 0){
                //ERRORRRR NO se puede dividir por cero
                return create_node(EMPTY, NULL);
            }
        ret = number_operation(op, n1, n2);
    }
    ret = create_node(EMPTY, NULL); //Poner null en ret y devolverlo?
    return ret;
}

node_t * expressions(char * op, node_t * n1, node_t * n2){
    node_t * ret;
    if(isNumber(n1) && isNumber(n2))
        ret = number_operation(op, n1, n2);
    else
        ret = create_node(EMPTY, NULL); //Poner null en ret y devolverlo?
    return ret;
}