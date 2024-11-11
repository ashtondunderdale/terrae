#include <stdio.h>
#include <stdlib.h>

#include "interpreter.h"

int main() {
    FILE *fptr = fopen("example/src.txt", "r");
    if (!fptr) {
        perror("Error occured opening file");
        return 1;
    }

    fseek(fptr, 0, SEEK_END);
    long sz = ftell(fptr);
    rewind(fptr);

    char *buff = (char *)malloc(sz + 1);
    if (!buff) {
        perror("Error allocating memory for file");
        return 1;
    }

    size_t read_size = fread(buff, 1, sz, fptr);
    buff[read_size] = '\0';
    fclose(fptr);

    Token* tokens = tokenize(buff);

    free(buff);
    fclose(fptr);

    return 0;
}