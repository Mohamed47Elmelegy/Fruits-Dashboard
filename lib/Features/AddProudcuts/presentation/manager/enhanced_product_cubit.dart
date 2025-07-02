import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/proudcuts_entity.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/add_product_usecase.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/update_product_usecase.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/delete_product_usecase.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/hard_delete_product_usecase.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/get_all_products_usecase.dart';
import 'dart:io';

import '../../../../core/config/ansicolor.dart';

part 'enhanced_product_state.dart';

class EnhancedProductCubit extends Cubit<EnhancedProductState> {
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final HardDeleteProductUseCase _hardDeleteProductUseCase;
  final GetAllProductsUseCase _getAllProductsUseCase;

  EnhancedProductCubit({
    required AddProductUseCase addProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required HardDeleteProductUseCase hardDeleteProductUseCase,
    required GetAllProductsUseCase getAllProductsUseCase,
  })  : _addProductUseCase = addProductUseCase,
        _updateProductUseCase = updateProductUseCase,
        _deleteProductUseCase = deleteProductUseCase,
        _hardDeleteProductUseCase = hardDeleteProductUseCase,
        _getAllProductsUseCase = getAllProductsUseCase,
        super(EnhancedProductInitial());

  /// Add new product
  Future<void> addProduct(ProductsEntity product, File? imageFile) async {
    log(DebugConsoleMessages.info('🎯 Cubit: Starting to add product...'));
    log(DebugConsoleMessages.info(
        '📦 Cubit: Product name: ${product.productName}'));

    if (isClosed) {
      log(DebugConsoleMessages.warning(
          '⚠️ Cubit: Cannot add product - cubit is closed'));
      return;
    }

    emit(EnhancedProductLoading());

    final result = await _addProductUseCase(product, imageFile);

    if (!isClosed) {
      result.fold(
        (failure) {
          log(DebugConsoleMessages.error(
              '❌ Cubit: Product addition failed: ${failure.message}'));
          emit(EnhancedProductFailure(failure.message));
        },
        (productId) {
          log(DebugConsoleMessages.success(
              '✅ Cubit: Product added successfully with ID: $productId'));
          emit(EnhancedProductAdded(productId));
        },
      );
    } else {
      log(DebugConsoleMessages.warning(
          '⚠️ Cubit: Cannot emit state - cubit is closed'));
    }
  }

  /// Update existing product
  Future<void> updateProduct(
      String productId, ProductsEntity product, File? imageFile) async {
    if (isClosed) {
      log(DebugConsoleMessages.warning(
          '⚠️ Cubit: Cannot update product - cubit is closed'));
      return;
    }

    emit(EnhancedProductLoading());

    final result = await _updateProductUseCase(productId, product, imageFile);

    if (!isClosed) {
      result.fold(
        (failure) => emit(EnhancedProductFailure(failure.message)),
        (_) => emit(EnhancedProductUpdated()),
      );
    } else {
      log(DebugConsoleMessages.warning(
          '⚠️ Cubit: Cannot emit state - cubit is closed'));
    }
  }

  /// Delete product (Soft Delete)
  Future<void> deleteProduct(String productId) async {
    log(DebugConsoleMessages.info(
        '🗑️ Cubit: Starting to soft delete product with ID: $productId'));

    if (isClosed) {
      log(DebugConsoleMessages.warning(
          '⚠️ Cubit: Cannot delete product - cubit is closed'));
      return;
    }

    emit(EnhancedProductLoading());

    final result = await _deleteProductUseCase(productId);

    if (!isClosed) {
      result.fold(
        (failure) {
          log(DebugConsoleMessages.error(
              '❌ Cubit: Product soft deletion failed: ${failure.message}'));
          emit(EnhancedProductFailure(failure.message));
        },
        (_) {
          log(DebugConsoleMessages.success(
              '✅ Cubit: Product soft deleted successfully: $productId'));
          emit(EnhancedProductDeleted());
        },
      );
    } else {
      log(DebugConsoleMessages.warning(
          '⚠️ Cubit: Cannot emit state - cubit is closed'));
    }
  }

  /// Hard delete product (completely remove from Firebase)
  Future<void> hardDeleteProduct(String productId) async {
    log(DebugConsoleMessages.info(
        '🗑️ Cubit: Starting to hard delete product with ID: $productId'));

    if (isClosed) {
      log(DebugConsoleMessages.warning(
          '⚠️ Cubit: Cannot hard delete product - cubit is closed'));
      return;
    }

    emit(EnhancedProductLoading());

    final result = await _hardDeleteProductUseCase(productId);

    if (!isClosed) {
      result.fold(
        (failure) {
          log(DebugConsoleMessages.error(
              '❌ Cubit: Product hard deletion failed: ${failure.message}'));
          emit(EnhancedProductFailure(failure.message));
        },
        (_) {
          log(DebugConsoleMessages.success(
              '✅ Cubit: Product hard deleted successfully: $productId'));
          emit(EnhancedProductDeleted());
        },
      );
    } else {
      log(DebugConsoleMessages.warning(
          '⚠️ Cubit: Cannot emit state - cubit is closed'));
    }
  }

  /// Get all products
  Future<void> getAllProducts() async {
    // Don't reload if cubit is closed
    if (isClosed) {
      return;
    }

    // Allow reload even if loading to ensure fresh data
    if (!isClosed) {
      emit(EnhancedProductLoading());
    }

    final result = await _getAllProductsUseCase();

    if (!isClosed) {
      result.fold(
        (failure) => emit(EnhancedProductFailure(failure.message)),
        (products) => emit(EnhancedProductsLoaded(products)),
      );
    }
  }

  /// Reset state to initial
  void resetState() {
    if (!isClosed) {
      emit(EnhancedProductInitial());
    }
  }
}
