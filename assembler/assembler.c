#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include <sys/types.h>
#define ASSEMBLER "assembler"


int main(int argc, char* argv[]){

    char* input_file_name = NULL;
    char* output_file_name = "prog.mif";
    FILE* output_file = NULL;

    for(int i = 1; i < argc; i++){
        if(*argv[i] == '-'){
            if(strcmp(argv[i], "--help") == 0){
                printf(
                    "Usage: assembler [options] <file>\n"
                    "Options:\n"
                    "\t-o <file>\tPlace the output into <file>\n"
                    "\t-p\t\tPrint compilation to stdout only (no file created)\n"
                );
                return 0;
            }else if(strcmp(argv[i], "-o") == 0){
                if(i < argc-1){
                    output_file_name = argv[i+1];
                    i++;
                }else{
                    fprintf(stderr, "%s: no filename specified after \'-o\'\n", ASSEMBLER);
                    return 1;
                }
            }else if(strcmp(argv[i], "-p") == 0){
                output_file = stdout;
            }else{
                fprintf(stderr, "%s: invalid command-line option \'%s\'\n", ASSEMBLER, argv[i]);
                return 1;
            }
        }else if(input_file_name == NULL){
            input_file_name = argv[i];
        }else{
            fprintf(stderr, "%s: Too many command-line arguments passed\n", ASSEMBLER);
            return 1;
        }
    }
    if(input_file_name == NULL){
        fprintf(stderr,
            "%s: no input file selected\n"
            "Try \'%s --help\' for more information\n",
            ASSEMBLER,
            ASSEMBLER
        );
        return 1;
    }
    FILE* input_file = fopen(input_file_name, "r");
    if(input_file == NULL){
        fprintf(stderr, "%s: unable to open input file \'%s\'\n", ASSEMBLER, input_file_name);
        return 1;
    }
    if(output_file == NULL){
        output_file = fopen(output_file_name, "w");
        if(output_file == NULL){
            fprintf(stderr, "%s: unable to open output file \'%s\'\n", ASSEMBLER, output_file_name);
            return 1;
        }
    }

    int line_number = 0;
    while(1){
        char *line = NULL;
        size_t len = 0;
        ssize_t read = getline(&line, &len, input_file);
        if(read == -1){
            break;
        }
        printf("%d: %s", ++line_number, line);
        free(line);
    }
    
    fclose(input_file);
    if(output_file != stdout)
        fclose(output_file);
    return 0;
}