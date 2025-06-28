import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../Entity/proudcuts_entity.dart';
import 'dart:io';

abstract class ProductRepository {
  Future<Either<Failure, String>> addProduct(
      ProductsEntity product, File? imageFile);
  Future<Either<Failure, void>> updateProduct(
      String productId, ProductsEntity product, File? imageFile);
  Future<Either<Failure, void>> deleteProduct(String productId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllProducts();
}
