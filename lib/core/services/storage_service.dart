import 'dart:io';

abstract class StorageService {
  Future<String> uplodeFile(File file, String path);
}
