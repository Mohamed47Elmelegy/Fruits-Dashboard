import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repos/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository _productRepo;

  GetAllProductsUseCase(this._productRepo);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    return await _productRepo.getAllProducts();
  }
}
