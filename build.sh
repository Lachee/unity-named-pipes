#!/bin/bash

echo "Generating CMake..."
mkdir build
cd build
cmake ..

echo "Generating Build..."
make
cd ..

echo "Copying Build..."
mkdir artifacts
cp build/NativeNamedPipe/libNativeNamedPipe.so artifacts/libNativeNamedPipe.so

echo "Done!"
