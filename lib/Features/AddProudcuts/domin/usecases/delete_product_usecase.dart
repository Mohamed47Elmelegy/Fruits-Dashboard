import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/repos/add_proudcuts/enhanced_product_repo.dart';

class DeleteProductUseCase {
  final EnhancedProductRepo _productRepo;

  DeleteProductUseCase(this._productRepo);

  Future<Either<Failure, void>> call(String productId) async {
    return await _productRepo.deleteProduct(productId);
  }
}
