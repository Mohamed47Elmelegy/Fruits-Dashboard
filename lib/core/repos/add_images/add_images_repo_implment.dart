import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:furute_app_dashbord/core/errors/failure.dart';
import 'package:furute_app_dashbord/core/services/storage_service.dart';
import '../../utils/backend_endpoints.dart';
import 'add_images_repo.dart';

class AddImagesRepoImplment implements AddImagesRepo {
  final StorageService storageService;

  AddImagesRepoImplment(this.storageService);
  @override
  Future<Either<Failure, String>> uploadImage(dynamic image) async {
    try {
      String url;
      if (kIsWeb && image is Uint8List) {
        // رفع صورة من الويب
        url = await storageService.uploadBytes(image, Backendpoint.images,
            'web_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
      } else if (image is File) {
        // رفع صورة من الموبايل
        url = await storageService.uploadFile(image, Backendpoint.images);
      } else {
        return Left(ServerFailure('Invalid image type'));
      }
      return Right(url);
    } catch (e) {
      return Left(ServerFailure('Failed to upload image'));
    }
  }
}
