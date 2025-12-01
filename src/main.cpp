#include <iostream>
#include <vector>
#include <string>
#include <filesystem>
#include "kernels.h"

// STB Image definitions must be done in one source file
#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image.h"       // You need to add this header to your repo
#include "stb_image_write.h" // You need to add this header to your repo

namespace fs = std::filesystem;

int main(int argc, char* argv[]) {
    if (argc < 4) {
        std::cerr << "Usage: ./image_processor <input_folder> <output_folder> <mode (0=gray, 1=blur)>\n";
        return 1;
    }

    std::string inputFolder = argv[1];
    std::string outputFolder = argv[2];
    int mode = std::stoi(argv[3]);

    if (!fs::exists(outputFolder)) {
        fs::create_directory(outputFolder);
    }

    for (const auto& entry : fs::directory_iterator(inputFolder)) {
        std::string inputPath = entry.path().string();
        std::string filename = entry.path().filename().string();
        std::string outputPath = outputFolder + "/" + filename;

        std::cout << "Processing: " << filename << std::endl;

        int width, height, channels;
        unsigned char* img_data = stbi_load(inputPath.c_str(), &width, &height, &channels, 0);

        if (img_data == nullptr) {
            std::cerr << "Error loading image: " << inputPath << std::endl;
            continue;
        }

        // Output size depends on mode (grayscale has 1 channel, blur keeps original)
        int out_channels = (mode == 0) ? 1 : channels;
        unsigned char* out_data = (unsigned char*)malloc(width * height * out_channels);

        runImageProcessing(img_data, out_data, width, height, channels, mode);

        stbi_write_png(outputPath.c_str(), width, height, out_channels, out_data, width * out_channels);

        stbi_image_free(img_data);
        free(out_data);
    }

    std::cout << "Batch processing complete.\n";
    return 0;
}