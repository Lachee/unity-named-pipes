#powershell -ExecutionPolicy ByPass -File build.ps1

Write-Host "Generating CMake..."
mkdir build --Forced
cd build
cmake ..

Write-Host "Building Project..."
msbuild NativeNamedPipe