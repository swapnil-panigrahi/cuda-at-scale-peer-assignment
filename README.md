# High-Throughput Batch Image Processing with CUDA

## Project Description
This project implements a high-performance image processing pipeline using NVIDIA CUDA. It is designed to process large batches of images efficiently by parallelizing pixel operations on the GPU. The application currently supports two image processing kernels:
1.  **Grayscale Conversion:** Converts RGB images to single-channel grayscale.
2.  **Box Blur:** Applies a 3x3 box blur filter to smooth images.

## Project Structure
* **`src/`**: Contains the C++ host code (`main.cpp`) and CUDA device kernels (`kernels.cu`).
* **`input/`**: Directory for source images (JPEG, PNG, etc.).
* **`output/`**: Directory where processed images are saved.
* **`run.sh`**: Automated script to build and execute the pipeline.
* **`Makefile`**: Compilation instructions for `nvcc` and `g++`.

## Prerequisites
* NVIDIA GPU with CUDA Compute Capability.
* CUDA Toolkit (installed and added to PATH).
* GCC/G++ compiler.
* `stb_image.h` and `stb_image_write.h` (single-header libraries included in `src/`).

## How to Run

### Automated Run
The easiest way to build and run the project is using the helper script:

```bash
chmod +x run.sh
./run.sh
