import 'package:dartz/dartz.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/proudcuts_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/repos/add_proudcuts/enhanced_product_repo.dart';
import 'dart:io';

class UpdateProductUseCase {
  final EnhancedProductRepo _productRepo;

  UpdateProductUseCase(this._productRepo);

  Future<Either<Failure, void>> call(
      String productId, ProductsEntity product, File? imageFile) async {
    return await _productRepo.updateProduct(productId, product, imageFile);
  }
}
