import 'package:dartz/dartz.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/proudcuts_entity.dart';
import '../../errors/failure.dart';
import '../../services/product_integration_service.dart';
import 'dart:io';

abstract class EnhancedProductRepo {
  Future<Either<Failure, String>> addProduct(
      ProductsEntity product, File? imageFile);
  Future<Either<Failure, void>> updateProduct(
      String productId, ProductsEntity product, File? imageFile);
  Future<Either<Failure, void>> deleteProduct(String productId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllProducts();
  Future<Either<Failure, Map<String, dynamic>?>> getProductById(
      String productId);
  Future<Either<Failure, List<Map<String, dynamic>>>> searchProducts(
      String query);
  Future<Either<Failure, List<Map<String, dynamic>>>> getActiveProducts();
  Future<Either<Failure, List<Map<String, dynamic>>>> getFeaturedProducts();
  Future<Either<Failure, List<Map<String, dynamic>>>> getBestSellingProducts(
      {int limit = 10});
  Future<Either<Failure, void>> updateProductSellingCount(
      String productId, int quantity);
}

class EnhancedProductRepoImpl implements EnhancedProductRepo {
  final ProductIntegrationService _productService;

  EnhancedProductRepoImpl(this._productService);

  @override
  Future<Either<Failure, String>> addProduct(
      ProductsEntity product, File? imageFile) async {
    try {
      final productData = _convertEntityToMap(product);
      final productId =
          await _productService.addProduct(productData, imageFile);
      return Right(productId);
    } catch (e) {
      return Left(ServerFailure('Failed to add product: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(
      String productId, ProductsEntity product, File? imageFile) async {
    try {
      final productData = _convertEntityToMap(product);
      await _productService.updateProduct(productId, productData, imageFile);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update product: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) async {
    try {
      await _productService.deleteProduct(productId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete product: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllProducts() async {
    try {
      final products = await _productService.getAllProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure('Failed to get products: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getProductById(
      String productId) async {
    try {
      final product = await _productService.getProductById(productId);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure('Failed to get product: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> searchProducts(
      String query) async {
    try {
      final products = await _productService.searchProducts(query);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure('Failed to search products: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
      getActiveProducts() async {
    try {
      final products = await _productService.getActiveProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure('Failed to get active products: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
      getFeaturedProducts() async {
    try {
      final products = await _productService.getFeaturedProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure('Failed to get featured products: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getBestSellingProducts(
      {int limit = 10}) async {
    try {
      final products =
          await _productService.getBestSellingProducts(limit: limit);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure('Failed to get best selling products: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProductSellingCount(
      String productId, int quantity) async {
    try {
      await _productService.updateProductSellingCount(productId, quantity);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update product selling count: $e'));
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
      'calories': entity.calorieDensity, // Note: matches Fruit App structure
      'unitAmount': entity.unitAmount,
      'productRating': entity.productRating,
      'ratingCount': entity.ratingCount,
      'isOrganic': entity.isOrganic,
      'reviews': entity.reviews.map((e) => e.toJson()).toList(),
      'sellingCount': 0, // Default value for new products
    };
  }
}
