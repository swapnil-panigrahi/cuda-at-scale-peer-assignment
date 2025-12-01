#ifndef KERNELS_H
#define KERNELS_H

#include <cuda_runtime.h>
#include <string>

// CUDA Kernel Declaration
void runImageProcessing(unsigned char* inputImage, unsigned char* outputImage, 
                        int width, int height, int channels, int mode);

#endif