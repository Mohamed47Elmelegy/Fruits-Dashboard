# PowerShell script to clean and reinstall CocoaPods
Write-Host "🧹 Cleaning iOS build cache..." -ForegroundColor Green

# Change to ios directory
Set-Location ios

# Remove existing Pods directory and files
Write-Host "🗑️ Removing existing Pods..." -ForegroundColor Yellow
if (Test-Path "Pods") { Remove-Item -Recurse -Force "Pods" }
if (Test-Path "Podfile.lock") { Remove-Item -Force "Podfile.lock" }
if (Test-Path ".symlinks") { Remove-Item -Recurse -Force ".symlinks" }
if (Test-Path "Flutter/Flutter.framework") { Remove-Item -Recurse -Force "Flutter/Flutter.framework" }
if (Test-Path "Flutter/Flutter.podspec") { Remove-Item -Force "Flutter/Flutter.podspec" }

# Clean Flutter
Write-Host "🧹 Cleaning Flutter..." -ForegroundColor Yellow
Set-Location ..
flutter clean
flutter pub get

# Go back to ios directory
Set-Location ios

# Install pods
Write-Host "📦 Installing CocoaPods..." -ForegroundColor Yellow
pod install --repo-update

Write-Host "✅ CocoaPods installation completed!" -ForegroundColor Green
Write-Host "📱 You can now open Runner.xcworkspace in Xcode" -ForegroundColor Cyan 