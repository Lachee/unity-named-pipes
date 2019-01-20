function RunUnityExporter([string] $install_dir, [string]  $source, [string] $output) 
{    
    Write-Output "Installing Discord Unity Exporter...";
    mkdir "$install_dir";

    git clone https://github.com/Lachee/Unity-Package-Exporter.git "$install_dir"  2>&1 | % { $_.ToString() }
    dotnet build "$install_dir/UnityPackageExporter";

    Write-Output "Exporting Unity Package";
    Write-Output "Install:	$install_dir";
    Write-Output "Source:	$source";
    Write-Output "Output:	$output";
    dotnet run --project "$install_dir/UnityPackageExporter" -project "$source" -output "$output" -a
}

Write-Host "=== Unity Named Pipe Unity Build ==="
mkdir "artifacts"
RunUnityExporter "tools/unity-package-exporter" "Unity Package" "artifacts/UnityNamedPipes.unitypackage"

Write-Host "Done!"