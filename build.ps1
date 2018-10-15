#powershell -ExecutionPolicy ByPass -File build.ps1
[CmdletBinding()]
Param(
	[switch]$BuildLibrary
)

function BuildLibrary([string] $target) 
{
    Write-Host "Generating CMake..."
    mkdir build -Force
    cd build
    cmake ..
        
    Write-Host "Building Project..."
    msbuild "NativeNamedPipe.sln" /p:Configuration=$target
	if ($LASTEXITCODE -ne  0)
	{
		cd ..
		throw "Error occured while building project."
	}
    
	cd ..
}

function CollectArtifacts([string] $target)
{
	Write-Host "Collecting Artifacts..."
	mkdir "artifacts" -Force
	cp "build\\NativeNamedPipe\\$target\\NativeNamedPipe.dll" "artifacts\\NativeNamedPipe.dll"
}

if ($BuildLibrary)
{
	Write-Host "Building Library"
    BuildLibrary "Release"
	CollectArtifacts "Release"
}

Write-Host "DONE"