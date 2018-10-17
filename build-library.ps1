#powershell -ExecutionPolicy ByPass -File build-library.ps1
#https://gist.github.com/IlyaFinkelshteyn/79af78657660e118b15d3ab9d62ab8a1
function BuildLibrary([string] $target) 
{
    Write-Host "Generating CMake..."
    mkdir build -Force
    cd build
    cmake .. -DCMAKE_GENERATOR_PLATFORM=x64
        
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