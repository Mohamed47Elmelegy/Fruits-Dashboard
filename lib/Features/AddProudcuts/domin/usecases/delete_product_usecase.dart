import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/config/ansicolor.dart';
import '../../../../core/errors/failure.dart';
import '../repos/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository _productRepo;

  DeleteProductUseCase(this._productRepo);

  Future<Either<Failure, void>> call(String productId) async {
    log(DebugConsoleMessages.info(
        '🔄 UseCase: Starting to delete product with ID: $productId'));
    final result = await _productRepo.deleteProduct(productId);
    result.fold(
      (failure) => log(DebugConsoleMessages.error(
          '❌ UseCase: Product deletion failed: ${failure.message}')),
      (_) => log(DebugConsoleMessages.success(
          '✅ UseCase: Product deleted successfully: $productId')),
    );
    return result;
  }
}
