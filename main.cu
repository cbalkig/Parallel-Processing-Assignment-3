#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define  N           32
#define  NUM_BLOCKS  N * N / NUM_THREADS
#define  NUM_THREADS 4

void printMatrix(char *id, int matrix[N * N]) {
    char *s = (char *) malloc(10000 * sizeof(char));
    sprintf(s, "%s\n", id);
    for (int row = 0; row < N; row++) {
        sprintf(s, "%s\t\t\t\t\t", s);
        for (int columns = 0; columns < N; columns++) {
            sprintf(s, "%s%d ", s, matrix[row * N + columns]);
        }
        sprintf(s, "%s\n", s);
    }
    printf("%s", s);
    free(s);
}

__global__ void calc(int *a, int *b) {
    //printf("Grid Dimension: %d,%d,%d Block Dimension: %d,%d,%d\n", gridDim.x, gridDim.y, gridDim.z, blockDim.x, blockDim.y, blockDim.z);
    int i = blockIdx.x * blockDim.x + blockIdx.y * blockDim.y + threadIdx.x + threadIdx.y;
    //printf("I'm Block:%d,%d,%d Thread:%d,%d,%d I'll operated on %d\n", blockIdx.x, blockIdx.y, blockIdx.z, threadIdx.x, threadIdx.y, threadIdx.z, i);

    if (i % N == 0) {
        b[i] = a[i];
    } else if (i / N == 0 && i % N == N - 1) {
        b[i] = ceil((double) (a[i] + a[i - 1] + a[i + N]) / 3);
    } else if (i / N == 0) {
        b[i] = ceil((double) (a[i] + a[i + 1] + a[i - 1] + a[i + N]) / 4);
    } else if (i / N == N - 1 && i % N == N - 1) {
        b[i] = ceil((double) (a[i] + a[i - 1] + a[i - N]) / 3);
    } else if (i % N == N - 1) {
        b[i] = ceil((double) (a[i] + a[i - 1] + a[i + N] + a[i - N]) / 4);
    } else if (i / N == N - 1) {
        b[i] = ceil((double) (a[i] + a[i + 1] + a[i - 1] + a[i - N]) / 4);
    } else {
        b[i] = ceil((double) (a[i] + a[i + 1] + a[i - 1] + a[i + N] + a[i - N]) / 5);
    }

    __syncthreads();
}

int main() {
    // CUDA configs
    // We will have Grid Dimension: 256,1,1 Block Dimension: 4,1,1
    dim3 dimGrid(NUM_BLOCKS, 1, 1);
    dim3 dimBlock(NUM_THREADS, 1, 1);
    int size = N * N * sizeof(int);
    int *a, *b;

    char *log = (char *) malloc(200 * sizeof(char));
    int temperature;
    printf("Please enter the heat temperature:\n");
    scanf("%d", &temperature);
    printf("Temperature: %d\n", temperature);
    if (temperature < 0 || temperature > 9) {
        printf("Heat temperature should be between 0 and 9.\n");
        exit(-1);
    }

    int A[N * N], B[N * N];
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i * N + j] = 0;
        }
    }
    printMatrix("Initial Matrix", A);

    for (int i = 0; i < N; i++) {
        A[i * N] = temperature;
    }
    printMatrix("Heat Matrix", A);

    int iteration_count = 0;
    while (iteration_count >= 0) {
        // Ready for CUDA
        cudaMalloc(&a, size);
        cudaMalloc(&b, size);

        cudaMemcpy(a, A, size, cudaMemcpyHostToDevice);
        calc <<<dimGrid, dimBlock>>>(a, b);
        cudaMemcpy(B, b, size, cudaMemcpyDeviceToHost);

        iteration_count++;

        log = (char *) malloc(200 * sizeof(char));
        sprintf(log, "Iteration: %d\nMatrix", iteration_count);
        printMatrix(log, B);

        int diff_sum = 0;
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                int idx = i * N + j;
                if (B[idx] != 0) {
                    diff_sum += (B[idx] - A[idx]);
                }

                A[idx] = B[idx];
            }
        }

        double threshold = ((double) diff_sum / (N));
        printf("Total changes in the iteration: %d, Threshold: %f\n", diff_sum, threshold);
        if (threshold < 0.1) {
            printf("No change. Enough iterations: %d\n", iteration_count);
            exit(0);
        }
    }

    cudaFree(a);
    cudaFree(b);
    free(log);
    return 0;
}
