#include "compiler.h"
#include "y.tab.h"
#include <ctype.h>
#include <getopt.h>

extern FILE *yyin;

FILE *c_file;

struct input_output
{
    int keep;
    char *input;
    char *output;
} input_output;

static char *add_function = "char* sum_strings(char * str1, char * str2){\n"
                            "char* aux = malloc(strlen(str1) + strlen(str2) + 1);\n"
                            "strcpy(aux, str1);\n"
                            "strcat(aux, str2);\n"
                            "return aux;}\n\n";

void print_headers()
{
    fprintf(c_file, "#include <stdlib.h>\n");
    fprintf(c_file, "#include <string.h>\n");
    fprintf(c_file, "#include <stdio.h>\n");
    fprintf(c_file, "%s", add_function);
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

static void
usage(const char *progname)
{
    fprintf(stdout,
            "Usage: %s [file.ecc] [OPTION]...\n"
            "\n"
            "   -k               Keeps the temporal .c file.\n"
            "   -o <filename>    Binary/executable filename.\n"
            "\n"
            "Usage: %s [OPTION]...\n"
            "   -h               Print help and exit.\n"
            "   -v               Print version information and exit.\n"
            "\n",
            progname, progname);
}

static void
version(void)
{
    fprintf(stdout, "easyGCC version 1.0\n"
                    "ITBA - Automatas, Teoria de lenguajes y Compiladores -- Galende, Itokazu, Ratti, Rosenblatt\n");
}

void arg_parse(int argc, char *argv[], struct input_output *ip)
{
    if (argc == 1)
    {
        fprintf(stderr, "Provide a file written in easyGCC language so that I can compile...\n");
        exit(1);
    }
    //default values
    ip->keep = 0;
    ip->input = argv[1];
    ip->output = "program.out";
    opterr = 0;

    static const struct option op_list[] = {
        {.name = "keep-temp", .has_arg = no_argument, .val = 'k'},
        {.name = "output", .has_arg = required_argument, .val = 'o'},
        {},
    };
    while (1)
    {
        int opt = getopt_long(argc, argv, ":o:kvh", op_list, NULL);
        if (opt == -1)
            break;
        switch (opt)
        {
        case 'h':
            usage(argv[0]);
            exit(0);
            break;
        case 'k':
            ip->keep = 1;
            break;
        case 'o':
            ip->output = optarg;
            break;
        case 'v':
            version();
            exit(0);
        case ':':
            fprintf(stdout, "Option '%s' requires one argument\n", argv[optind - 1]);
            exit(1);
            break;
        case '?':
        default:
            fprintf(stderr, "Unknown argument %s\n", argv[optind - 1]);
            exit(1);
        }
    }
}

void compile_c_file(char *output_file, int keep_temp)
{
    char command_buffer[256];
    sprintf(command_buffer, "gcc %s -o %s", TMP_FILE_NAME, output_file);

    int gcc_status = system(command_buffer);

    if (!keep_temp && remove(TMP_FILE_NAME))
    {
        fprintf(stderr, "An error has ocurred during removal of temporal file.\n");
        exit(1);
    }

    if (gcc_status != 0)
    {
        printf("An error has ocurred during compilation of temporal C code.\n");
        exit(1);
    }
}

int main(int argc, char *argv[])
{
    arg_parse(argc, argv, &input_output);
    initialize_yacc_input(input_output.input);
    yyparse();
    finish_parse();
    compile_c_file(input_output.output, input_output.keep);
    return 0;
}