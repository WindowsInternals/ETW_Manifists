# Get technical OS details from Registry
$OSInfo = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$BuildNumber = [int]$OSInfo.CurrentBuild
$EditionID = $OSInfo.EditionID
$DisplayVersion = $OSInfo.DisplayVersion

# Determine the correct OS marketing name based on Build Number thresholds
if ($BuildNumber -ge 22000) {
    $RealOSName = "Windows_11"
} else {
    $RealOSName = "Windows_10"
}

# Configuration using script root directory
$ScriptDir = $PSScriptRoot
$FolderName = "ETW_Manifests_$($RealOSName)_$($DisplayVersion)_$($BuildNumber)_$($EditionID)"
$OutputDir = Join-Path $ScriptDir $FolderName
$ProvidersFile = Join-Path $OutputDir "providers_list.txt"
$PerfViewPath = Join-Path $ScriptDir "PerfView.exe"

# Ensure the versioned output directory exists
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Generate the provider list inside the versioned directory if it doesn't exist
if (-not (Test-Path $ProvidersFile)) {
    Write-Host "[!] Generating $ProvidersFile..."
    logman query providers | Out-File $ProvidersFile -Encoding utf8
}

# Set location to the versioned output directory
Push-Location $OutputDir

# Read the file from the current sub-directory
$Providers = Get-Content $ProvidersFile | Select-Object -Skip 3

foreach ($Line in $Providers) {
    # Extract the name before the GUID using Regex
    if ($Line -match "^(.+?)\s+\{") {
        $ProviderName = $Matches[1].Trim()
        
        if (-not [string]::IsNullOrWhiteSpace($ProviderName)) {
            Write-Host "[*] Processing: $ProviderName"
            
            # Arguments for PerfView
            $PerfArgs = @(
                "/NoGui",
                "/AcceptEula",
                "/LogFile:perfview_log.txt",
                "userCommand",
                "DumpRegisteredManifest",
                "`"$ProviderName`""
            )
            
            # Execute synchronously using the absolute path to PerfView
            Start-Process -FilePath $PerfViewPath -ArgumentList $PerfArgs -Wait -NoNewWindow
        }
    }
}

Pop-Location
Write-Host "[V] Finished. Files are located in: $OutputDir"