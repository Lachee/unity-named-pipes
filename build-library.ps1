#powershell -ExecutionPolicy ByPass -File build-library.ps1

param(
	[string] $target,
	[switch] $64bit
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
	
	if ($is64bit)  
	{
		cp "build\\UnityNamedPipe.Native\\Release\\NativeNamedPipe.dll" "artifacts\\NativeNamedPipe.dll"
	}
	else
	{
		cp "build\\UnityNamedPipe.Native\\Release\\NativeNamedPipe.dll" "artifacts\\NativeNamedPipe_x86.dll"
	}

	
	Write-Host "Cleaning Up..."
	Remove-Item -path build -recurse -force
}

Write-Host "=== Unity Named Pipe Windows Build ==="
if ($64bit) 
{
	BuildLibrary $target $true
}
else
{
	BuildLibrary $target $false
}

Write-Host "Done!"