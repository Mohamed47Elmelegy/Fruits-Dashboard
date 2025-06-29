# iOS Setup Guide

## Prerequisites

1. **Xcode**: Make sure you have Xcode installed (version 12.0 or later)
2. **CocoaPods**: Install CocoaPods if not already installed
   ```bash
   sudo gem install cocoapods
   ```
3. **Flutter**: Ensure Flutter is properly configured for iOS development

## Setup Steps

### 1. Install Dependencies
```bash
cd ios
pod install
```

### 2. Firebase Configuration
1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to the `Runner` folder in Xcode
3. Make sure it's included in the target

### 3. Permissions
The following permissions are already configured in `Info.plist`:
- **Photo Library**: For selecting product images
- **Camera**: For taking product photos

### 4. Build and Run
```bash
flutter build ios
flutter run
```

## Troubleshooting

### Common Issues

1. **Pod Install Fails**
   ```bash
   cd ios
   pod deintegrate
   pod install
   ```

2. **Build Errors**
   - Clean the project: `flutter clean`
   - Get dependencies: `flutter pub get`
   - Reinstall pods: `cd ios && pod install`

3. **Signing Issues**
   - Open project in Xcode
   - Go to Runner target settings
   - Configure signing with your Apple Developer account

## Notes

- Minimum iOS version: 12.0
- Supports both iPhone and iPad
- Uses Firebase for backend services
- Image picker requires photo library and camera permissions 