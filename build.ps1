#powershell -ExecutionPolicy ByPass -File build.ps1
[CmdletBinding()]
Param(
	[switch]$BuildLibrary
)

function BuildLibrary() 
{
    Write-Host "Generating CMake..."
    mkdir build
    cd build
    cmake ..
        
    Write-Host "Building Project..."
    msbuild "NativeNamedPipe.sln"
    cd ..
}

if ($BuildLibrary)
{
    BuildCMake
}