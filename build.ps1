#powershell -ExecutionPolicy ByPass -File build.ps1
[CmdletBinding()]
Param(
	[switch]$BuildLibrary,
	[switch]$BuildPackage
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

function RunUnityExporter([string] $install_dir, [string]  $source, [string] $output) 
{    
    Write-Output "Installing Discord Unity Exporter...";
    mkdir -Force "$install_dir";

    git clone https://github.com/Lachee/Unity-Package-Exporter.git "$install_dir"  2>&1 | % { $_.ToString() }
    dotnet build "$install_dir\\UnityPackageExporter";

    Write-Output "Exporting...";
    Write-Output "$install_dir";
    Write-Output "$source";
    Write-Output "$output";
    dotnet run --project "$install_dir\\UnityPackageExporter" -project "$source" -output "$output" -a
}


if ($BuildLibrary)
{
	Write-Host "Building Library"
    BuildLibrary "Release"
	CollectArtifacts "Release"
}

if ($BuildPackage) 
{
	Write-Host "Building Unity Package..."
	mkdir "artifacts" -Force
	RunUnityExporter "tools/unity-package-exporter" "UnityNamedPipes" "artifacts/UnityNamedPipes.unitypackage"
}

Write-Host "DONE"