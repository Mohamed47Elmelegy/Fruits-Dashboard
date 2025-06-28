import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/proudcuts_entity.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/add_product_usecase.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/update_product_usecase.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/delete_product_usecase.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/get_all_products_usecase.dart';
import '../../../../core/errors/failure.dart';
import 'dart:io';

part 'enhanced_product_state.dart';

class EnhancedProductCubit extends Cubit<EnhancedProductState> {
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final GetAllProductsUseCase _getAllProductsUseCase;

  EnhancedProductCubit({
    required AddProductUseCase addProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required GetAllProductsUseCase getAllProductsUseCase,
  })  : _addProductUseCase = addProductUseCase,
        _updateProductUseCase = updateProductUseCase,
        _deleteProductUseCase = deleteProductUseCase,
        _getAllProductsUseCase = getAllProductsUseCase,
        super(EnhancedProductInitial());

  /// Add new product
  Future<void> addProduct(ProductsEntity product, File? imageFile) async {
    emit(EnhancedProductLoading());

    final result = await _addProductUseCase(product, imageFile);

    result.fold(
      (failure) => emit(EnhancedProductFailure(failure.message)),
      (productId) => emit(EnhancedProductAdded(productId)),
    );
  }

  /// Update existing product
  Future<void> updateProduct(
      String productId, ProductsEntity product, File? imageFile) async {
    emit(EnhancedProductLoading());

    final result = await _updateProductUseCase(productId, product, imageFile);

    result.fold(
      (failure) => emit(EnhancedProductFailure(failure.message)),
      (_) => emit(EnhancedProductUpdated()),
    );
  }

  /// Delete product
  Future<void> deleteProduct(String productId) async {
    emit(EnhancedProductLoading());

    final result = await _deleteProductUseCase(productId);

    result.fold(
      (failure) => emit(EnhancedProductFailure(failure.message)),
      (_) => emit(EnhancedProductDeleted()),
    );
  }

  /// Get all products
  Future<void> getAllProducts() async {
    emit(EnhancedProductLoading());

    final result = await _getAllProductsUseCase();

    result.fold(
      (failure) => emit(EnhancedProductFailure(failure.message)),
      (products) => emit(EnhancedProductsLoaded(products)),
    );
  }

  /// Reset state to initial
  void resetState() {
    emit(EnhancedProductInitial());
  }
}
