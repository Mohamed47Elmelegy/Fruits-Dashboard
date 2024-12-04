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
  Future<Either<Failure, String>> uploadImage(File image) async {
    try {
      String url = await storageService.uploadFile(image, Backendpoint.images);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure('Failed to upload image'));
    }
  }
}
