import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:furute_app_dashbord/core/errors/failure.dart';

import 'add_images_repo.dart';

class AddImagesRepoImplment implements AddImagesRepo {
  @override
  Future<Either<Failure, String>> addImages(File files) {
    throw UnimplementedError();
  }
}
