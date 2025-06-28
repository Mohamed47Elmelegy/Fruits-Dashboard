import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/repos/add_proudcuts/enhanced_product_repo.dart';

class GetAllProductsUseCase {
  final EnhancedProductRepo _productRepo;

  GetAllProductsUseCase(this._productRepo);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    return await _productRepo.getAllProducts();
  }
}
