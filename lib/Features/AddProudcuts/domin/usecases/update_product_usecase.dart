import 'package:dartz/dartz.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/proudcuts_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repos/product_repository.dart';
import 'dart:io';

class UpdateProductUseCase {
  final ProductRepository _productRepo;

  UpdateProductUseCase(this._productRepo);

  Future<Either<Failure, void>> call(
      String productId, ProductsEntity product, File? imageFile) async {
    return await _productRepo.updateProduct(productId, product, imageFile);
  }
}
