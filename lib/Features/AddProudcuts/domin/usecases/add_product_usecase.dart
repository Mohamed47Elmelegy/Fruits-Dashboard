import 'package:dartz/dartz.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/proudcuts_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repos/product_repository.dart';
import 'dart:io';

class AddProductUseCase {
  final ProductRepository _productRepo;

  AddProductUseCase(this._productRepo);

  Future<Either<Failure, String>> call(
      ProductsEntity product, File? imageFile) async {
    print('🎯 UseCase: Starting to add product...');
    print('📦 UseCase: Product name: ${product.productName}');

    try {
      final result = await _productRepo.addProduct(product, imageFile);
      print('✅ UseCase: Product addition completed');
      return result;
    } catch (e) {
      print('❌ UseCase: Error in use case: $e');
      return Left(ServerFailure('Use case error: $e'));
    }
  }
}
