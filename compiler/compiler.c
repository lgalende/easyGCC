#include "compiler.h"
#include "y.tab.h"
#include <ctype.h>
#include <getopt.h>

extern FILE *yyin;

struct input_output
{
    char *input;
    char *output;
} input_output;

void print_headers()
{
    fprintf(c_file, "#include <stdlib.h>\n");
    // fprintf(c_file, "#include <math.h>\n");
    // fprintf(c_file, "#include <time.h>\n");
    // fprintf(c_file, "#include <unistd.h>\n");
    fprintf(c_file, "#include <string.h>\n");
    // fprintf(c_file, "#include <termios.h>\n");
    fprintf(c_file, "#include <stdio.h>\n");
}

void initialize_yacc_input(char *easygcc_script)
{
    FILE *read_file = fopen(easygcc_script, "r");
    if (read_file == NULL)
    {
        printf("File not found or could not be opened.\n");
        exit(1);
    }
    yyin = read_file;
    c_file = fopen(TMP_FILE_NAME, "w");
    if (c_file == NULL)
    {
        printf("Error - Could not create a C temporary file.\n");
        exit(1);
    }
}

void finish_parse()
{
    fclose(c_file);
    fclose(yyin);
}

void arg_parse(int argc, char *argv[], struct input_output *ip)
{
    if (argc == 1)
    {
        fprintf(stderr, "Provide a file written in easyGCC language so that I can compile...\n");
        exit(1);
    }
    ip->input = argv[1];
    ip->output = "program.out";
    opterr = 0;
}

void compile_c_file(char *output_file)
{
    char command_buffer[256];
    sprintf(command_buffer, "gcc %s -o %s", TMP_FILE_NAME, output_file);

    int gcc_status = system(command_buffer);

    // if (!preserveTmp && remove(TMP_FILE_NAME))
    // {
    //     printf("Error al eliminar el archivo de código intermedio.\n");
    //     exit(1);
    // }

    if (gcc_status != 0)
    {
        printf("Error al compilar el código intermedio generado.\n");
        exit(1);
    }
}

int main(int argc, char *argv[])
{
    arg_parse(argc, argv, &input_output);
    initialize_yacc_input(input_output.input);
    yyparse();
    finish_parse();
    compile_c_file(input_output.output);
    return 0;
}