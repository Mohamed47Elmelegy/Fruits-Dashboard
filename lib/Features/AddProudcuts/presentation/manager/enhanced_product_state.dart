part of 'enhanced_product_cubit.dart';

abstract class EnhancedProductState {}

class EnhancedProductInitial extends EnhancedProductState {}

class EnhancedProductLoading extends EnhancedProductState {}

class EnhancedProductAdded extends EnhancedProductState {
  final String productId;
  EnhancedProductAdded(this.productId);
}

class EnhancedProductUpdated extends EnhancedProductState {}

class EnhancedProductDeleted extends EnhancedProductState {}

class EnhancedProductsLoaded extends EnhancedProductState {
  final List<Map<String, dynamic>> products;
  EnhancedProductsLoaded(this.products);
}

class EnhancedProductFailure extends EnhancedProductState {
  final String message;
  EnhancedProductFailure(this.message);
}
