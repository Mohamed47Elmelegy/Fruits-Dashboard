import 'package:dartz/dartz.dart';
import '../../domin/Entity/proudcuts_entity.dart';
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
      final productMap = _convertEntityToMap(product);
      final productId = await _productService.addProduct(productMap, imageFile);
      return Right(productId);
    } catch (e) {
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

  Map<String, dynamic> _convertEntityToMap(ProductsEntity product) {
    return {
      'productName': product.productName,
      'productPrice': product.productPrice,
      'productCode': product.productCode,
      'productDescription': product.productDescription,
      'isFeatured': product.isFeatured,
      'imageUrl': product.imageUrl,
      'expiryDateMonths': product.expiryDateMonths,
      'calories': product.calorieDensity,
      'unitAmount': product.unitAmount,
      'productRating': product.productRating,
      'ratingCount': product.ratingCount,
      'isOrganic': product.isOrganic,
      'reviews': product.reviews
          .map((review) => {
                'name': review.name,
                'image': review.image,
                'rating': review.rating,
                'date': review.date,
                'description': review.description,
              })
          .toList(),
    };
  }
}
