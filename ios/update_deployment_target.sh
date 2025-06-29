#!/bin/bash

# Update iOS deployment target to 13.0 for Firebase compatibility

echo "Updating iOS deployment target to 13.0..."

# Update Podfile
if [ -f "Podfile" ]; then
    sed -i '' 's/platform :ios, '\''12.0'\''/platform :ios, '\''13.0'\''/g' Podfile
    sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = 12.0/IPHONEOS_DEPLOYMENT_TARGET = 13.0/g' Podfile
    echo "✅ Updated Podfile"
else
    echo "❌ Podfile not found"
fi

# Update project.pbxproj
if [ -f "Runner.xcodeproj/project.pbxproj" ]; then
    sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = 12.0/IPHONEOS_DEPLOYMENT_TARGET = 13.0/g' Runner.xcodeproj/project.pbxproj
    echo "✅ Updated project.pbxproj"
else
    echo "❌ project.pbxproj not found"
fi

# Update Info.plist if needed
if [ -f "Runner/Info.plist" ]; then
    # Add minimum deployment target if not exists
    if ! grep -q "MinimumOSVersion" Runner/Info.plist; then
        sed -i '' '/<dict>/a\
    <key>MinimumOSVersion</key>\
    <string>13.0</string>' Runner/Info.plist
        echo "✅ Added MinimumOSVersion to Info.plist"
    else
        sed -i '' 's/<string>12.0<\/string>/<string>13.0<\/string>/g' Runner/Info.plist
        echo "✅ Updated MinimumOSVersion in Info.plist"
    fi
else
    echo "❌ Info.plist not found"
fi

echo "🎉 iOS deployment target update completed!" 