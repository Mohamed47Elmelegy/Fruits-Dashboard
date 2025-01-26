import 'dart:developer';
import 'dart:io';
import 'package:furute_app_dashbord/core/config/ansicolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/constants.dart';
import 'storage_service.dart';
import 'package:path/path.dart' as b;

class SupabaseStorageService implements StorageService {
  static late Supabase _supabase;
  static Future<void> createBucket(String bucketName) async {
    var buckets = await _supabase.client.storage.listBuckets();
    bool bucketExists = false;
    for (var bucket in buckets) {
      if (bucket.name == bucketName) {
        bucketExists = true;
        break;
      }
    }
    if (!bucketExists) {
      await _supabase.client.storage.createBucket(bucketName);
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
  try {
    log(DebugConsoleMessages.success('Uploading file: ${file.path}'));
    String fileName = b.basename(file.path);
    // رفع الملف إلى Supabase
    await _supabase.client.storage
        .from(Constatns.supabaseBucket)
        .upload('$path/$fileName', file);
    log(DebugConsoleMessages.success('File uploaded: $fileName'));

    // الحصول على الرابط العام للملف
    final String publicUrl = _supabase.client.storage
        .from(Constatns.supabaseBucket)
        .getPublicUrl('$path/$fileName'); // تأكد من وجود / بين path و fileName

    log(DebugConsoleMessages.success('File public url: $publicUrl'));
    return publicUrl; // إرجاع الرابط العام
  } catch (e) {
    log(DebugConsoleMessages.error('Failed to upload file: $e'));
    throw Exception('Failed to upload file: $e');
  }
}

}
