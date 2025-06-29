#!/bin/bash

echo "🧹 Cleaning iOS build cache..."
cd ios

# Remove existing Pods directory and files
echo "🗑️ Removing existing Pods..."
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec

# Clean Flutter
echo "🧹 Cleaning Flutter..."
cd ..
flutter clean
flutter pub get

# Go back to ios directory
cd ios

# Install pods
echo "📦 Installing CocoaPods..."
pod install --repo-update

echo "✅ CocoaPods installation completed!"
echo "📱 You can now open Runner.xcworkspace in Xcode" 