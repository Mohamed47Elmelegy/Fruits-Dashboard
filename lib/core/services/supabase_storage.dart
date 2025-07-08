import 'dart:developer';
import 'dart:io';
import 'dart:typed_data'; // Added for Uint8List
import 'package:furute_app_dashbord/core/config/ansicolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/constants.dart';
import 'storage_service.dart';
import 'package:path/path.dart' as b;

class SupabaseStorageService implements StorageService {
  static late Supabase _supabase;

  static Future<void> createBucket(String bucketName) async {
    try {
      log(DebugConsoleMessages.info('Checking if bucket exists: $bucketName'));
      var buckets = await _supabase.client.storage.listBuckets();
      bool bucketExists = false;
      for (var bucket in buckets) {
        if (bucket.name == bucketName) {
          bucketExists = true;
          log(DebugConsoleMessages.success('Bucket found: ${bucket.name}'));
          break;
        }
      }
      if (!bucketExists) {
        log(DebugConsoleMessages.info('Creating bucket: $bucketName'));
        await _supabase.client.storage.createBucket(bucketName);
        log(DebugConsoleMessages.success(
            'Bucket created successfully: $bucketName'));
      }
    } catch (e) {
      log(DebugConsoleMessages.error('Error creating bucket: $e'));
      rethrow;
    }
  }

  static initSupabase() async {
    try {
      log(DebugConsoleMessages.info('Initializing Supabase...'));
      _supabase = await Supabase.initialize(
        url: Constatns.supabaseUrl,
        anonKey: Constatns.supabaseKey,
      );
      log(DebugConsoleMessages.success('Supabase initialized successfully'));
    } catch (e) {
      log(DebugConsoleMessages.error('Error initializing Supabase: $e'));
      rethrow;
    }
  }

  @override
  Future<String> uploadFile(File file, String path) async {
    try {
      log(DebugConsoleMessages.info('Starting file upload: ${file.path}'));
      log(DebugConsoleMessages.info('Upload path: $path'));
      log(DebugConsoleMessages.info(
          'Bucket name: ${Constatns.supabaseBucket}'));

      // Check if file exists
      if (!await file.exists()) {
        throw Exception('File does not exist: ${file.path}');
      }

      String fileName = b.basename(file.path);
      String fullPath = '$path/$fileName';

      log(DebugConsoleMessages.info('Full upload path: $fullPath'));
      log(DebugConsoleMessages.info('File size: ${await file.length()} bytes'));

      // Check if bucket exists before uploading
      var buckets = await _supabase.client.storage.listBuckets();
      bool bucketExists =
          buckets.any((bucket) => bucket.name == Constatns.supabaseBucket);

      if (!bucketExists) {
        log(DebugConsoleMessages.warning(
            'Bucket ${Constatns.supabaseBucket} not found, creating it...'));
        await createBucket(Constatns.supabaseBucket);
      }

      // Upload file to Supabase
      await _supabase.client.storage
          .from(Constatns.supabaseBucket)
          .upload(fullPath, file);

      log(DebugConsoleMessages.success(
          'File uploaded successfully: $fileName'));

      // Get public URL
      final String publicUrl = _supabase.client.storage
          .from(Constatns.supabaseBucket)
          .getPublicUrl(fullPath);

      log(DebugConsoleMessages.success('Public URL generated: $publicUrl'));
      return publicUrl;
    } catch (e) {
      log(DebugConsoleMessages.error('Failed to upload file: $e'));
      log(DebugConsoleMessages.error('File path: ${file.path}'));
      log(DebugConsoleMessages.error('Upload path: $path'));
      log(DebugConsoleMessages.error('Bucket: ${Constatns.supabaseBucket}'));
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<String> uploadBytes(
      Uint8List bytes, String path, String fileName) async {
    try {
      log(DebugConsoleMessages.info('Starting bytes upload: $fileName'));
      log(DebugConsoleMessages.info('Upload path: $path'));
      log(DebugConsoleMessages.info(
          'Bucket name: ${Constatns.supabaseBucket}'));

      String fullPath = '$path/$fileName';
      log(DebugConsoleMessages.info('Full upload path: $fullPath'));
      log(DebugConsoleMessages.info('Bytes size: ${bytes.length} bytes'));

      // Check if bucket exists before uploading
      var buckets = await _supabase.client.storage.listBuckets();
      bool bucketExists =
          buckets.any((bucket) => bucket.name == Constatns.supabaseBucket);

      if (!bucketExists) {
        log(DebugConsoleMessages.warning(
            'Bucket ${Constatns.supabaseBucket} not found, creating it...'));
        await createBucket(Constatns.supabaseBucket);
      }

      // Upload bytes to Supabase
      await _supabase.client.storage
          .from(Constatns.supabaseBucket)
          .uploadBinary(fullPath, bytes);

      log(DebugConsoleMessages.success(
          'Bytes uploaded successfully: $fileName'));

      // Get public URL
      final String publicUrl = _supabase.client.storage
          .from(Constatns.supabaseBucket)
          .getPublicUrl(fullPath);

      log(DebugConsoleMessages.success('Public URL generated: $publicUrl'));
      return publicUrl;
    } catch (e) {
      log(DebugConsoleMessages.error('Failed to upload bytes: $e'));
      log(DebugConsoleMessages.error('Upload path: $path'));
      log(DebugConsoleMessages.error('Bucket: ${Constatns.supabaseBucket}'));
      throw Exception('Failed to upload bytes: $e');
    }
  }
}
