#!/bin/bash

echo "=== Unity Named Pipe Mac Build ==="
echo "Generating CMake..."
mkdir build
cd build
cmake ..

echo "Generating Build..."
make
cd ..

echo "Copying Build..."
mkdir artifacts
cp build/UnityNamedPipe.Native/libNativeNamedPipe.dylib artifacts/libNativeNamedPipe.dylib

echo "Done!"
