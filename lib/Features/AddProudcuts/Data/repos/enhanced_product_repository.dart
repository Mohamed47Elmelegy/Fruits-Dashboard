import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/config/ansicolor.dart';
import '../../domin/Entity/proudcuts_entity.dart';
import '../../domin/repos/product_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/product_integration_service.dart';
import 'dart:io';
import 'dart:typed_data';

class EnhancedProductRepository implements ProductRepository {
  final ProductIntegrationService _productService;

  EnhancedProductRepository(this._productService);

  @override
  Future<Either<Failure, String>> addProduct(
      ProductsEntity product, dynamic imageFile) async {
    try {
      log(DebugConsoleMessages.info(
          '🔄 Repository: Starting to add product...'));
      log(DebugConsoleMessages.info(
          '📦 Repository: Product entity: ${product.productName}'));

      final productMap = _convertEntityToMap(product);
      log(DebugConsoleMessages.info(
          '🗺️ Repository: Converted to map: $productMap'));

      String productId;
      if (imageFile is Uint8List || imageFile is File) {
        productId = await _productService.addProduct(productMap, imageFile);
      } else {
        productId = await _productService.addProduct(productMap, null);
      }
      log(DebugConsoleMessages.success(
          '✅ Repository: Product added successfully with ID: $productId'));

      return Right(productId);
    } catch (e) {
      log(DebugConsoleMessages.error('❌ Repository: Error adding product: $e'));
      log(DebugConsoleMessages.info(
          '🔍 Repository: Error type: ${e.runtimeType}'));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(
      String productId, ProductsEntity product, dynamic imageFile) async {
    try {
      final productMap = _convertEntityToMap(product);
      if (imageFile is Uint8List || imageFile is File) {
        await _productService.updateProduct(productId, productMap, imageFile);
      } else {
        await _productService.updateProduct(productId, productMap, null);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) async {
    try {
      log(DebugConsoleMessages.info(
          '🔄 Repository: Starting to soft delete product with ID: $productId'));
      await _productService.deleteProduct(productId);
      log(DebugConsoleMessages.success(
          '✅ Repository: Product soft deleted successfully: $productId'));
      return const Right(null);
    } catch (e) {
      log(DebugConsoleMessages.error(
          '❌ Repository: Error soft deleting product: $e'));
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Hard delete product (completely remove from Firebase)
  @override
  Future<Either<Failure, void>> hardDeleteProduct(String productId) async {
    try {
      log(DebugConsoleMessages.info(
          '🔄 Repository: Starting to hard delete product with ID: $productId'));
      await _productService.hardDeleteProduct(productId);
      log(DebugConsoleMessages.success(
          '✅ Repository: Product hard deleted successfully: $productId'));
      return const Right(null);
    } catch (e) {
      log(DebugConsoleMessages.error(
          '❌ Repository: Error hard deleting product: $e'));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllProducts() async {
    try {
      final products = await _productService.getAllProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Convert ProductsEntity to Map for Firestore
  Map<String, dynamic> _convertEntityToMap(ProductsEntity entity) {
    return {
      'productName': entity.productName,
      'productPrice': entity.productPrice,
      'productCode': entity.productCode,
      'productDescription': entity.productDescription,
      'isFeatured': entity.isFeatured,
      'imageUrl': entity.imageUrl,
      'expiryDateMonths': entity.expiryDateMonths,
      'calorieDensity': entity.calorieDensity, // Keep original name
      'unitAmount': entity.unitAmount, // Now int type
      'productRating': entity.productRating,
      'ratingCount': entity.ratingCount,
      'isOrganic': entity.isOrganic,
      'reviews': entity.reviews
          .map((e) => {
                'name': e.name,
                'image': e.image,
                'rating': e.rating,
                'date': e.date,
                'description': e.description,
              })
          .toList(),
      'sellingCount': 0, // Default value for new products
    };
  }
}
