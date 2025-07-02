import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/config/ansicolor.dart';
import '../../../../core/errors/failure.dart';
import '../repos/product_repository.dart';

class HardDeleteProductUseCase {
  final ProductRepository _productRepo;

  HardDeleteProductUseCase(this._productRepo);

  Future<Either<Failure, void>> call(String productId) async {
    log(DebugConsoleMessages.info(
        '🔄 UseCase: Starting to hard delete product with ID: $productId'));
    final result = await _productRepo.hardDeleteProduct(productId);
    result.fold(
      (failure) => log(DebugConsoleMessages.error(
          '❌ UseCase: Product hard deletion failed: ${failure.message}')),
      (_) => log(DebugConsoleMessages.success(
          '✅ UseCase: Product hard deleted successfully: $productId')),
    );
    return result;
  }
}
