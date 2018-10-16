#powershell -ExecutionPolicy ByPass -File build.ps1
function BuildLibrary([string] $target) 
{
    Write-Host "Generating CMake..."
    mkdir build -Force
    cd build
    cmake ..
        
    Write-Host "Generating Build..."
    msbuild "NativeNamedPipe.sln" /p:Configuration=$target
	if ($LASTEXITCODE -ne  0)
	{
		cd ..
		throw "Error occured while building project."
	}
    
	cd ..

	Write-Host "Collecting Artifacts..."
	mkdir "artifacts" -Force
	cp "build\\NativeNamedPipe\\$target\\NativeNamedPipe.dll" "artifacts\\NativeNamedPipe.dll"
}

Write-Host "=== Unity Named Pipe Windows Build ==="
BuildLibrary "Release"

Write-Host "Done!"