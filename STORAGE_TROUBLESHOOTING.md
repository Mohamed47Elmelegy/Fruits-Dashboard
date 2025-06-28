# Storage Troubleshooting Guide

## Common Storage Issues and Solutions

### 1. StorageException Error

#### Problem:
```
StorageException: Failed to upload file: [Error details]
```

#### Possible Causes:
1. **Bucket doesn't exist**
2. **Incorrect bucket name**
3. **File doesn't exist**
4. **Network connectivity issues**
5. **Supabase configuration problems**

#### Solutions:

##### Check Bucket Configuration
```dart
// In constants.dart
static const supabaseBucket = 'fruits_images'; // Make sure this matches your Supabase bucket
```

##### Verify Supabase Setup
```dart
// In main.dart
await SupabaseStorageService.initSupabase();
await SupabaseStorageService.createBucket('fruits_images');
```

##### Check File Existence
```dart
// Before uploading, verify file exists
if (!await file.exists()) {
  throw Exception('File does not exist: ${file.path}');
}
```

### 2. Bucket Name Conflicts

#### Problem:
Different parts of the code use different bucket names.

#### Solution:
Use consistent bucket name from constants:

```dart
// ✅ Correct - Use constant
await _supabase.storage.from(Constatns.supabaseBucket).upload(path, file);

// ❌ Wrong - Hardcoded bucket name
await _supabase.storage.from('product-images').upload(path, file);
```

### 3. File Upload Path Issues

#### Problem:
Files uploaded to wrong path or path doesn't exist.

#### Solution:
Use consistent path structure:

```dart
// ✅ Correct path structure
String fullPath = '$path/$fileName';
// Example: 'images/product_123.jpg'

// ❌ Wrong - Missing path separator
String fullPath = '$path$fileName';
```

### 4. Supabase Initialization Issues

#### Problem:
Supabase not initialized properly.

#### Solution:
Ensure proper initialization order:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase first
  await SupabaseStorageService.initSupabase();
  
  // Create bucket if needed
  await SupabaseStorageService.createBucket('fruits_images');
  
  // Then initialize other services
  await Firebase.initializeApp();
  setupGetit();
  
  runApp(const MyApp());
}
```

### 5. Network and Permission Issues

#### Problem:
Network connectivity or permission problems.

#### Solution:
Add proper error handling:

```dart
Future<String> uploadFile(File file, String path) async {
  try {
    // Check network connectivity
    if (!await _checkNetworkConnectivity()) {
      throw Exception('No internet connection');
    }
    
    // Check file permissions
    if (!await file.exists()) {
      throw Exception('File does not exist');
    }
    
    // Upload with timeout
    await _supabase.client.storage
        .from(Constatns.supabaseBucket)
        .upload(path, file)
        .timeout(Duration(seconds: 30));
        
  } catch (e) {
    log('Upload error: $e');
    rethrow;
  }
}
```

## Debugging Steps

### 1. Enable Detailed Logging
```dart
// Add this to see detailed upload logs
log(DebugConsoleMessages.info('Starting upload: ${file.path}'));
log(DebugConsoleMessages.info('Bucket: ${Constatns.supabaseBucket}'));
log(DebugConsoleMessages.info('Path: $path'));
```

### 2. Check Supabase Dashboard
1. Go to your Supabase project dashboard
2. Navigate to Storage section
3. Verify bucket exists: `fruits_images`
4. Check bucket permissions
5. Verify RLS (Row Level Security) policies

### 3. Test Bucket Creation
```dart
// Test bucket creation manually
try {
  await SupabaseStorageService.createBucket('fruits_images');
  print('Bucket created successfully');
} catch (e) {
  print('Bucket creation failed: $e');
}
```

### 4. Test File Upload
```dart
// Test upload with a simple file
try {
  final testFile = File('test.txt');
  await testFile.writeAsString('test content');
  
  final url = await SupabaseStorageService().uploadFile(testFile, 'test');
  print('Upload successful: $url');
} catch (e) {
  print('Upload failed: $e');
}
```

## Common Error Messages and Solutions

### "Bucket not found"
**Solution:** Create bucket or check bucket name
```dart
await SupabaseStorageService.createBucket('fruits_images');
```

### "File does not exist"
**Solution:** Check file path and permissions
```dart
if (!await file.exists()) {
  throw Exception('File not found: ${file.path}');
}
```

### "Network error"
**Solution:** Check internet connection and Supabase URL
```dart
// Verify Supabase URL in constants.dart
static const supabaseUrl = 'https://your-project.supabase.co';
```

### "Permission denied"
**Solution:** Check Supabase RLS policies
```dart
// In Supabase dashboard, ensure bucket has proper policies
```

## Best Practices

### 1. Use Consistent Bucket Names
```dart
// Always use constant
static const supabaseBucket = 'fruits_images';
```

### 2. Add Proper Error Handling
```dart
try {
  final url = await uploadFile(file, path);
  return url;
} catch (e) {
  log('Upload failed: $e');
  throw Exception('Failed to upload file: $e');
}
```

### 3. Validate Files Before Upload
```dart
// Check file size, type, and existence
if (await file.length() > maxFileSize) {
  throw Exception('File too large');
}

if (!allowedFileTypes.contains(file.extension)) {
  throw Exception('File type not allowed');
}
```

### 4. Use Meaningful File Names
```dart
// Generate unique, meaningful file names
String fileName = '${productCode}_${DateTime.now().millisecondsSinceEpoch}.jpg';
```

### 5. Implement Retry Logic
```dart
Future<String> uploadWithRetry(File file, String path, {int maxRetries = 3}) async {
  for (int i = 0; i < maxRetries; i++) {
    try {
      return await uploadFile(file, path);
    } catch (e) {
      if (i == maxRetries - 1) rethrow;
      await Future.delayed(Duration(seconds: 1 * (i + 1)));
    }
  }
  throw Exception('Upload failed after $maxRetries attempts');
}
```

## Testing Storage

### 1. Unit Test
```dart
test('should upload file successfully', () async {
  final file = File('test.txt');
  await file.writeAsString('test');
  
  final url = await SupabaseStorageService().uploadFile(file, 'test');
  
  expect(url, isNotEmpty);
  expect(url, contains('supabase.co'));
});
```

### 2. Integration Test
```dart
testWidgets('should upload product image', (tester) async {
  // Test complete flow from UI to storage
});
```

This guide should help resolve most storage-related issues in the application. 