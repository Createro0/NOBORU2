# Improved Build NOBORU2 test VPK
$sevenzip = "C:\Program Files\7-Zip\7z.exe"
$vitamksfox = ".\vita-mksfoex.exe"
$outputVpk = "NOBORU2-test.vpk"

# Create param.sfo
Write-Host "Creating param.sfo..."
& $vitamksfox -s TITLE_ID=NOBO20001 "NOBORU 2" param.sfo

# Copy param.sfo to sce_sys
if (Test-Path param.sfo) {
    Copy-Item param.sfo vpk_extract\sce_sys\ -Force
    Write-Host "param.sfo copied to vpk_extract/sce_sys/"
}

# Create VPK with proper structure
Write-Host "Creating VPK with proper structure..."
Remove-Item $outputVpk -ErrorAction SilentlyContinue

# Change to vpk_extract directory and create archive from there
Push-Location vpk_extract
& $sevenzip a -tzip "..\$outputVpk" "*" -r
Pop-Location

Write-Host "VPK created: $outputVpk"
Write-Host "Build complete!"
