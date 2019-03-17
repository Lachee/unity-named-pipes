#powershell -ExecutionPolicy ByPass -File build-library.ps1

param(
	[string] $target,
	[bool] $64bit
)

#https://gist.github.com/IlyaFinkelshteyn/79af78657660e118b15d3ab9d62ab8a1
function BuildLibrary([string] $target, [bool] $is64bit) 
{
    Write-Host "Generating CMake..."
    mkdir build -Force
    cd build

	if ($is64bit) 
	{
		Write-Host "Generating 64bit..."
    	cmake .. -DCMAKE_GENERATOR_PLATFORM=x64
        
		Write-Host "Generating Build Target {$target} ..."
		#msbuild "NativeNamedPipe.sln" /p:Configuration=$target /p:Platform=x64
		msbuild "NativeNamedPipe.sln" /p:Configuration=Release /p:Platform=x64
	}
	else
	{
		Write-Host "Generating 32bit..."
    	cmake ..
        
		Write-Host "Generating Build Target {$target} ..."
		#msbuild "NativeNamedPipe.sln" /p:Configuration=$target
		msbuild "NativeNamedPipe.sln" /p:Configuration=Release
	}
	
	if ($LASTEXITCODE -ne  0)
	{
		cd ..
		throw "Error occured while building project."
	}
    
	cd ..

	Write-Host "Collecting Artifacts..."
	mkdir "artifacts" -Force
	cp "build\\UnityNamedPipe.Native\\$target\\NativeNamedPipe.dll" "artifacts\\NativeNamedPipe.dll"
}

Write-Host "=== Unity Named Pipe Windows Build ==="
BuildLibrary $target $64bit

Write-Host "Done!"