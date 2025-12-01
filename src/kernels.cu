#include "kernels.h"
#include <iostream>

// Kernel 1: Grayscale Conversion
__global__ void grayscaleKernel(unsigned char* input, unsigned char* output, int width, int height, int channels) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x < width && y < height) {
        int idx = (y * width + x) * channels;
        // Simple average for grayscale
        unsigned char r = input[idx];
        unsigned char g = input[idx + 1];
        unsigned char b = input[idx + 2];
        unsigned char gray = (unsigned char)((r + g + b) / 3);
        
        // Output is single channel
        output[y * width + x] = gray;
    }
}

// Kernel 2: Simple Box Blur
__global__ void blurKernel(unsigned char* input, unsigned char* output, int width, int height, int channels) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x > 0 && x < width - 1 && y > 0 && y < height - 1) {
        int idx = (y * width + x) * channels;
        int pixValR = 0;
        int pixValG = 0;
        int pixValB = 0;

        // 3x3 Box Filter
        for(int i = -1; i <= 1; i++) {
            for(int j = -1; j <= 1; j++) {
                int neighborIdx = ((y + j) * width + (x + i)) * channels;
                pixValR += input[neighborIdx];
                pixValG += input[neighborIdx+1];
                pixValB += input[neighborIdx+2];
            }
        }
        output[idx] = (unsigned char)(pixValR / 9);
        output[idx+1] = (unsigned char)(pixValG / 9);
        output[idx+2] = (unsigned char)(pixValB / 9);
    }
}

// Wrapper function to handle memory allocation and kernel launch
void runImageProcessing(unsigned char* h_input, unsigned char* h_output, int width, int height, int channels, int mode) {
    size_t imgSize = width * height * channels * sizeof(unsigned char);
    size_t outSize = (mode == 0) ? width * height * sizeof(unsigned char) : imgSize;

    unsigned char *d_input, *d_output;

    // Allocate Device Memory
    cudaMalloc((void**)&d_input, imgSize);
    cudaMalloc((void**)&d_output, outSize);

    // Copy Data to GPU
    cudaMemcpy(d_input, h_input, imgSize, cudaMemcpyHostToDevice);

    // Grid Dimensions
    dim3 blockSize(16, 16);
    dim3 gridSize((width + blockSize.x - 1) / blockSize.x, (height + blockSize.y - 1) / blockSize.y);

    if (mode == 0) {
        grayscaleKernel<<<gridSize, blockSize>>>(d_input, d_output, width, height, channels);
    } else {
        blurKernel<<<gridSize, blockSize>>>(d_input, d_output, width, height, channels);
    }

    cudaDeviceSynchronize();

    // Copy result back
    cudaMemcpy(h_output, d_output, outSize, cudaMemcpyDeviceToHost);

    cudaFree(d_input);
    cudaFree(d_output);
}