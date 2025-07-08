import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../errors/failure.dart';

abstract class AddImagesRepo {
  Future<Either<Failure, String>> uploadImage(dynamic image);
}
