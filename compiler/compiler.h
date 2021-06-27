#ifndef COMPILER_H
#define COMPILER_H

#include <stdlib.h>
#include <stdio.h>

FILE *c_file;
#define TMP_FILE_NAME "tmp.c"

void print_headers();
void finish_parse();

#endif