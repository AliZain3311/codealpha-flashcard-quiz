$ErrorActionPreference = "Stop"

$project = (Get-Location).Path
$scriptRoot = $PSScriptRoot

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "       FlashLearn Branding Setup" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# --------------------------------------------------
# 1. Make sure assets directory exists
# --------------------------------------------------

Write-Host "Checking assets..." -ForegroundColor Yellow

$assetsPath = Join-Path $project "assets"

New-Item -ItemType Directory -Force -Path $assetsPath | Out-Null

# --------------------------------------------------
# 2. Copy branding assets only when needed
# --------------------------------------------------

$sourceIcon = Join-Path $scriptRoot "assets\flashlearn_icon.png"
$sourceSplash = Join-Path $scriptRoot "assets\flashlearn_splash.png"

$targetIcon = Join-Path $project "assets\flashlearn_icon.png"
$targetSplash = Join-Path $project "assets\flashlearn_splash.png"

if (([System.IO.Path]::GetFullPath($sourceIcon)) -ne
    ([System.IO.Path]::GetFullPath($targetIcon))) {

    Copy-Item $sourceIcon $targetIcon -Force
}

if (([System.IO.Path]::GetFullPath($sourceSplash)) -ne
    ([System.IO.Path]::GetFullPath($targetSplash))) {

    Copy-Item $sourceSplash $targetSplash -Force
}

Write-Host "Branding assets ready." -ForegroundColor Green

# --------------------------------------------------
# 3. Copy configuration files
# --------------------------------------------------

Write-Host "Preparing Flutter configuration..." -ForegroundColor Yellow

$launcherConfigSource = Join-Path $scriptRoot "flutter_launcher_icons.yaml"
$launcherConfigTarget = Join-Path $project "flutter_launcher_icons.yaml"

$splashConfigSource = Join-Path $scriptRoot "flutter_native_splash.yaml"
$splashConfigTarget = Join-Path $project "flutter_native_splash.yaml"

if (([System.IO.Path]::GetFullPath($launcherConfigSource)) -ne
    ([System.IO.Path]::GetFullPath($launcherConfigTarget))) {

    Copy-Item $launcherConfigSource $launcherConfigTarget -Force
}

if (([System.IO.Path]::GetFullPath($splashConfigSource)) -ne
    ([System.IO.Path]::GetFullPath($splashConfigTarget))) {

    Copy-Item $splashConfigSource $splashConfigTarget -Force
}

Write-Host "Configuration files ready." -ForegroundColor Green

# --------------------------------------------------
# 4. Install required packages
# --------------------------------------------------

Write-Host ""
Write-Host "Installing branding packages..." -ForegroundColor Yellow

flutter pub add --dev flutter_launcher_icons

if ($LASTEXITCODE -ne 0) {
    throw "Failed to install flutter_launcher_icons."
}

flutter pub add --dev flutter_native_splash

if ($LASTEXITCODE -ne 0) {
    throw "Failed to install flutter_native_splash."
}

# --------------------------------------------------
# 5. Get dependencies
# --------------------------------------------------

Write-Host ""
Write-Host "Getting Flutter dependencies..." -ForegroundColor Yellow

flutter pub get

if ($LASTEXITCODE -ne 0) {
    throw "flutter pub get failed."
}

# --------------------------------------------------
# 6. Generate launcher icons
# --------------------------------------------------

Write-Host ""
Write-Host "Generating FlashLearn launcher icons..." -ForegroundColor Yellow

dart run flutter_launcher_icons -f flutter_launcher_icons.yaml

if ($LASTEXITCODE -ne 0) {
    throw "Launcher icon generation failed."
}

Write-Host "Launcher icons generated successfully." -ForegroundColor Green

# --------------------------------------------------
# 7. Generate native splash screen
# --------------------------------------------------

Write-Host ""
Write-Host "Generating FlashLearn native splash screen..." -ForegroundColor Yellow

dart run flutter_native_splash:create -p flutter_native_splash.yaml

if ($LASTEXITCODE -ne 0) {
    throw "Native splash generation failed."
}

Write-Host "Native splash screen generated successfully." -ForegroundColor Green

# --------------------------------------------------
# 8. Clean project
# --------------------------------------------------

Write-Host ""
Write-Host "Cleaning Flutter project..." -ForegroundColor Yellow

flutter clean

if ($LASTEXITCODE -ne 0) {
    throw "flutter clean failed."
}

# --------------------------------------------------
# 9. Get dependencies again
# --------------------------------------------------

Write-Host ""
Write-Host "Restoring dependencies..." -ForegroundColor Yellow

flutter pub get

if ($LASTEXITCODE -ne 0) {
    throw "Final flutter pub get failed."
}

# --------------------------------------------------
# 10. Final message
# --------------------------------------------------

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "   FlashLearn Branding Setup Completed!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

Write-Host "App icon:       READY" -ForegroundColor Green
Write-Host "Splash screen:  READY" -ForegroundColor Green
Write-Host ""

Write-Host "Next commands:" -ForegroundColor Cyan
Write-Host "flutter analyze"
Write-Host "flutter test"
Write-Host "flutter run"
Write-Host ""