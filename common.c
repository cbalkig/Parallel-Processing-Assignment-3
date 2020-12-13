//
// Created by Cavide Balki Gemirter on 13.12.2020.
//
#include <stdio.h>
#include <stdlib.h>

typedef enum {
    false, true
} bool;

void printMatrix(char *id, int rowCount, int columnCount, int matrix[rowCount][columnCount]) {
    char *s = (char *) malloc(10000 * sizeof(char));
    sprintf(s, "%s\n", id);
    for (int row = 0; row < rowCount; row++) {
        sprintf(s, "%s\t\t\t\t\t", s);
        for (int columns = 0; columns < columnCount; columns++) {
            sprintf(s, "%s%d\t", s, matrix[row][columns]);
        }
        sprintf(s, "%s\n", s);
    }
    printf("%s", s);
    free(s);
}