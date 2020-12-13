#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "common.c"

#define N 32

int main(int argc, char *argv[]) {
    char *log = (char *) malloc(200 * sizeof(char));
    int temperature;
    printf("Please enter the heat temperature:\n");
    scanf("%d", &temperature);
    printf("Temperature: %d\n", temperature);
    if (temperature < 0 || temperature > 9) {
        printf("Heat temperature should be between 0 and 9.\n");
        exit(-1);
    }

    int A[N][N];
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = 0;
        }
    }
    printMatrix("Initial Matrix", N, N, A);

    for (int i = 0; i < N; i++) {
        A[i][0] = temperature;
    }
    printMatrix("Heat Matrix", N, N, A);

    int iteration_count = 0;
    while (iteration_count >= 0) {
        int diff_sum = 0;
        int B[N][N];
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (j == 0) {
                    B[i][j] = A[i][j];
                } else if (i == 0 && j == N - 1) {
                    B[i][j] = ceil((double)(A[i][j] + A[i][j - 1] + A[i + 1][j]) / 3);
                } else if (i == 0) {
                    B[i][j] = ceil((double)(A[i][j] + A[i][j + 1] + A[i][j - 1] + A[i + 1][j]) / 4);
                } else if (i == N - 1 && j == N - 1) {
                    B[i][j] = ceil((double)(A[i][j] + A[i][j - 1] + A[i - 1][j]) / 3);
                } else if (j == N - 1) {
                    B[i][j] = ceil((double)(A[i][j] + A[i][j - 1] + A[i + 1][j] + A[i - 1][j]) / 4);
                } else if (i == N - 1) {
                    B[i][j] = ceil((double)(A[i][j] + A[i][j + 1] + A[i][j - 1] + A[i - 1][j]) / 4);
                } else {
                    B[i][j] = ceil((double)(A[i][j] + A[i][j + 1] + A[i][j - 1] + A[i + 1][j] + A[i - 1][j]) / 5);
                }

                if (B[i][j] != 0 && A[i][j] != 0) {
                    diff_sum += (B[i][j] - A[i][j]);
                }
            }
        }

        iteration_count++;

        log = (char *) malloc(200 * sizeof(char));
        sprintf(log, "Iteration: %d\nMatrix", iteration_count);
        printMatrix(log, N, N, B);

        if(iteration_count > 1) {
            double threshold = ((double) diff_sum / (N));
            printf("Total changes in the iteration is %f\n", threshold);
            if (threshold < 0.1) {
                printf("No change. Enough iterations: %d\n", iteration_count);
                exit(0);
            }
        }

        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                A[i][j] = B[i][j];
            }
        }
    }

    free(log);
    return 0;
}
