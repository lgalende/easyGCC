#include "compiler.h"
#include "y.tab.h"
#include <ctype.h>
#include <getopt.h>

extern FILE *yyin;

struct input_output {
    char *input;
    char *output;
}input_output;

void print_headers() {
    fprintf(tmpFile, "#include <stdio.h>\n");
    fprintf(tmpFile, "#include <stdlib.h>\n");
    fprintf(tmpFile, "#include <math.h>\n");
    fprintf(tmpFile, "#include <time.h>\n");
    fprintf(tmpFile, "#include <unistd.h>\n");
    fprintf(tmpFile, "#include <string.h>\n");
    fprintf(tmpFile, "#include <termios.h>\n");
    fprintf(tmpFile, "#include <stdio.h>\n");
}

void initialize_yacc_input(char *easygcc_script ) {
    FILE * read_file = fopen(inputFile, "r");
    if (read_file == NULL)
    {
        printf ("File not found or could not be opened.\n");
        exit(1);
    }
    yyin = read_file;
    tmpFile = fopen(TMP_FILE_NAME, "w");
    if (tmpFile == NULL) {
        printf ("Error - Could not create a C temporary file.\n");
        exit(1);
    }
}

void finish_parse() {
    fclose(tmpFile);
    fclose(yyin);
}

void arg_parse(int argc, char *argv[], input_output *ip) {
    if(argc == 1)
    {
      fprintf(stderr, "Provide a file written in easyGCC language so that I can compile...\n");
	    exit(1);
    }
    ip->input = argv[1];
    opterr = 0;
}

int main(int argc, char *argv[])
{ 
   arg_parse(argc, argv, &input_output);
   initialize_yacc_input();
   yyparse();
   finish_parse();
   //todo: compile here
   return 0;
}