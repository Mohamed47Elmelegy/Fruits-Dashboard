import 'dart:developer';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/constants.dart';
import 'storage_service.dart';
import 'package:path/path.dart' as b;

class SupabaseStorageService implements StorageService {
  static late Supabase _supabase;
  static Future<void> createBucket(String bucketName) async {
    try {
      await _supabase.client.storage.getBucket(bucketName);
      log('Bucket already exists');
    } catch (e) {
      if (e.toString().contains('404')) {
        // إذا لم يتم العثور على الـ bucket، قم بإنشائه
        await _supabase.client.storage.createBucket(bucketName);
      } else {
        rethrow;
      }
    }
  }

  static initSupabase() async {
    _supabase = await Supabase.initialize(
      url: Constatns.supabaseUrl,
      anonKey: Constatns.supabaseKey,
    );
  }

  @override
  Future<String> uploadFile(File file, String path) async {
    String fileName = b.basename(file.path);
    String extensionName = b.extension(file.path);
    var result = await _supabase.client.storage
        .from('fruits_images')
        .upload('$path/$fileName.$extensionName', file);
    return result;
  }
}
