#!/bin/bash

echo "=== Unity Named Pipe Linux Build ==="
echo "Generating CMake..."
mkdir build
cd build
cmake ..

echo "Generating Build..."
make
cd ..

echo "Copying Build..."
mkdir artifacts
cp build/UnityNamedPipe.Native/libNativeNamedPipe.so artifacts/NativeNamedPipe.so

echo "Done!"
