import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repos/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository _productRepo;

  DeleteProductUseCase(this._productRepo);

  Future<Either<Failure, void>> call(String productId) async {
    return await _productRepo.deleteProduct(productId);
  }
}
