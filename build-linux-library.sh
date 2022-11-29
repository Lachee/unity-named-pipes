#!/bin/bash

echo "=== Unity Named Pipe Linux Build ==="
echo "Generating CMake..."
rm -rf build
mkdir build
cd build
cmake ..

echo "Generating Build..."
make
cd ..

echo "Copying Build..."
rm -rf artifacts
mkdir artifacts
cp build/UnityNamedPipe.Native/libNativeNamedPipe.so artifacts/NativeNamedPipe.so

echo "Done!"
