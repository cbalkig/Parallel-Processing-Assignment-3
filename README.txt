Hocam,

main.cu ve main --> 32 * 32 matrix i�in.
4 grid, 256 thread ile �al���r.
Threshold 0.001

small_main.cu ve small_main --> 4 * 4 matrix i�in.
4 grid, 4 thread ile �al���r.
Threshold 0.001

Kodlar� ayn� sadece matrix size ve CUDA dimensionlar� farkl�.
2 log dosyas�n� �rnek olarak ekledim.

matrix_output.log main'i 9 temperature ile �al��t�rma �rne�i.
small_matrix_output.log da small_main'i 5 temperature ile �al��t�rma �rne�i.