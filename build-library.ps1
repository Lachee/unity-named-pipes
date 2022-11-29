#powershell -ExecutionPolicy ByPass -File build-library.ps1

param(
	[switch] $make64bit
)

#https://gist.github.com/IlyaFinkelshteyn/79af78657660e118b15d3ab9d62ab8a1
function BuildLibrary([bool] $is64bit) 
{
    Write-Host "Generating CMake..."
	rd /s build
    mkdir build -Force
    cd build

	if ($is64bit) 
	{
		Write-Host "Generating 64bit..."
    	cmake .. -DCMAKE_GENERATOR_PLATFORM=x64
        
		Write-Host "Generating Build Target..."
		#msbuild "NativeNamedPipe.sln" /p:Configuration=$target /p:Platform=x64
		msbuild "NativeNamedPipe.sln" /p:Configuration=Release /p:Platform=x64
	}
	else
	{
		Write-Host "Generating 32bit..."
    	cmake ..
        
		Write-Host "Generating Build Target..."
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
	rd /s "artifacts"
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
if ($make64bit) 
{
	BuildLibrary $true
}
else
{
	BuildLibrary $false
}

Write-Host "Done!"