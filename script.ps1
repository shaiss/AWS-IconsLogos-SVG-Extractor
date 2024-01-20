# Root directory where the script will run
$rootPath = "C:\Users\Shai\Downloads\Asset-Package_10232023.af3b989c8f30fad5f9c6161440af5cc2f0746e49\Architecture-Service-Icons_10232023"

# Output directory for the extracted SVGs
$outputDir = Join-Path $rootPath "output"

# Check if the output directory exists
if (Test-Path $outputDir) {
    # Output directory exists, prompt user for action
    $userChoice = Read-Host "Output directory exists. Choose an option: [1] Delete all files, [2] Overwrite, [3] Rename with random prefix"
    switch ($userChoice) {
        "1" { Get-ChildItem $outputDir -Recurse | Remove-Item -Force }
        "2" { Write-Host "Overwrite selected. Existing files with the same name will be overwritten." }
        "3" {
            Write-Host "Rename with random prefix selected. Existing files will be kept."
            $randomPrefix = -join ((65..90) + (97..122) | Get-Random -Count 8 | % {[char]$_})
            Get-ChildItem $outputDir -File | Rename-Item -NewName { $randomPrefix + $_.Name } -Force
        }
        Default { Write-Host "Invalid option selected. Exiting script."; exit }
    }
} else {
    # Create the output directory
    New-Item -Path $outputDir -ItemType Directory
}

# Find all SVG files in '64' subdirectories and copy them to the output directory with the new name
$directories = Get-ChildItem $rootPath -Recurse -Directory | Where-Object { $_.Name -eq "64" }
if ($directories -eq $null) {
    Write-Host "No '64' directories found."
} else {
    foreach ($dir in $directories) {
        $parentFolderName = Split-Path $dir.FullName -Parent | Split-Path -Leaf
        $svgFilesPath = Join-Path $dir.FullName "*.svg"
        $svgFiles = Get-ChildItem $svgFilesPath
        foreach ($file in $svgFiles) {
            $newFileName = "${parentFolderName}_$($file.Name)"
            $newFilePath = Join-Path $outputDir $newFileName
            Copy-Item $file.FullName -Destination $newFilePath
            Write-Host "Copied '$($file.Name)' to '$newFilePath'"
        }
    }
}

Write-Host "SVG files have been copied to the output directory."
