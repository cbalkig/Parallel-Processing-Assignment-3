Hocam,

main.cu ve main --> 32 * 32 matrix için.
4 grid, 256 thread ile çalýþýr.
Threshold 0.001

small_main.cu ve small_main --> 4 * 4 matrix için.
4 grid, 4 thread ile çalýþýr.
Threshold 0.001

Kodlarý ayný sadece matrix size ve CUDA dimensionlarý farklý.
2 log dosyasýný örnek olarak ekledim.

matrix_output.log main'i 9 temperature ile çalýþtýrma örneði.
small_matrix_output.log da small_main'i 5 temperature ile çalýþtýrma örneði.