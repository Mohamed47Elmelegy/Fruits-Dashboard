import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/constants.dart';
import 'storage_service.dart';
import 'package:path/path.dart' as b;

class SupabaseStorageService implements StorageService {
  @override
  static late Supabase _supabase;
  static initialSubabase() async {
    _supabase = await Supabase.initialize(
      url: Constants.supabaseUrl,
      anonKey: Constants.supabaseKey,
    );
  }

  @override
  Future<String> uplodeFile(File file, String path) async {
    String fileName = b.basename(file.path);
    String extencionName = b.extension(file.path);
    final result = await _supabase.client.storage
        .from(Constants.imgaeBucket)
        .upload('$path/$fileName.$extencionName', file);
    return result;
  }
}
