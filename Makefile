NVCC = nvcc
CXXFLAGS = -std=c++17

INCLUDES = -I./src -I/usr/local/cuda/include
LDFLAGS = 

SRCS = src/main.cpp src/kernels.cu

OBJS = $(SRCS:.cpp=.o)
OBJS := $(OBJS:.cu=.o)

TARGET = image_processor

all: $(TARGET)

$(TARGET): $(OBJS)
	$(NVCC) $(CXXFLAGS) $(INCLUDES) -o $@ $^ $(LDFLAGS)

%.o: %.cpp
	g++ $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Compile CUDA files
%.o: %.cu
	$(NVCC) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Clean up build files
clean:
	rm -f src/*.o $(TARGET)