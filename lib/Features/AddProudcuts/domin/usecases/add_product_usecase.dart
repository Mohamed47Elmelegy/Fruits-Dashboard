import 'package:dartz/dartz.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/proudcuts_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/repos/add_proudcuts/enhanced_product_repo.dart';
import 'dart:io';

class AddProductUseCase {
  final EnhancedProductRepo _productRepo;

  AddProductUseCase(this._productRepo);

  Future<Either<Failure, String>> call(ProductsEntity product, File? imageFile) async {
    return await _productRepo.addProduct(product, imageFile);
  }
} 