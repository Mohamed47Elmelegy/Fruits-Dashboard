import 'package:dartz/dartz.dart';
import '../../domin/Entity/proudcuts_entity.dart';
import '../../domin/Entity/reviews_entity.dart';
import '../../domin/repos/product_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/product_integration_service.dart';
import 'dart:io';

class EnhancedProductRepository implements ProductRepository {
  final ProductIntegrationService _productService;

  EnhancedProductRepository(this._productService);

  @override
  Future<Either<Failure, String>> addProduct(
      ProductsEntity product, File? imageFile) async {
    try {
      print('🔄 Repository: Starting to add product...');
      print('📦 Repository: Product entity: ${product.productName}');

      final productMap = _convertEntityToMap(product);
      print('🗺️ Repository: Converted to map: $productMap');

      final productId = await _productService.addProduct(productMap, imageFile);
      print('✅ Repository: Product added successfully with ID: $productId');

      return Right(productId);
    } catch (e) {
      print('❌ Repository: Error adding product: $e');
      print('🔍 Repository: Error type: ${e.runtimeType}');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(
      String productId, ProductsEntity product, File? imageFile) async {
    try {
      final productMap = _convertEntityToMap(product);
      await _productService.updateProduct(productId, productMap, imageFile);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) async {
    try {
      await _productService.deleteProduct(productId);
      return const Right(null);
    } catch (e) {
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
