#!/bin/bash

INPUT_DIR="input"
OUTPUT_DIR="output"
EXECUTABLE="./image_processor"
MODE=0  # 0 for Grayscale, 1 for Box Blur

if [ ! -d "$INPUT_DIR" ]; then
    mkdir -p "$INPUT_DIR"
    echo "Created '$INPUT_DIR' directory."
fi

if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
    echo "Created '$OUTPUT_DIR' directory."
fi

if [ -z "$(ls -A $INPUT_DIR)" ]; then
   echo "Input directory is empty. Downloading a sample image..."
   wget -q -O "$INPUT_DIR/sample.jpg" https://upload.wikimedia.org/wikipedia/commons/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg
   echo "Downloaded sample.jpg."
fi

echo "Building the project..."
make clean
make

if [ ! -f "$EXECUTABLE" ]; then
    echo "Build failed. Exiting."
    exit 1
fi

echo "Starting batch processing..."
echo "----------------------------"
$EXECUTABLE "$INPUT_DIR" "$OUTPUT_DIR" $MODE
echo "----------------------------"

echo "Processing complete."
echo "Processed images are located in the '$OUTPUT_DIR' folder."
ls -lh "$OUTPUT_DIR"