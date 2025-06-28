import 'package:get_it/get_it.dart';
import '../../Features/AddProudcuts/presentation/manager/enhanced_product_cubit.dart';
import '../../Features/AddProudcuts/domin/usecases/add_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/update_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/delete_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/get_all_products_usecase.dart';

class CubitFactory {
  static final GetIt _getIt = GetIt.instance;

  /// Creates a new EnhancedProductCubit instance
  static EnhancedProductCubit createEnhancedProductCubit() {
    return EnhancedProductCubit(
      addProductUseCase: _getIt<AddProductUseCase>(),
      updateProductUseCase: _getIt<UpdateProductUseCase>(),
      deleteProductUseCase: _getIt<DeleteProductUseCase>(),
      getAllProductsUseCase: _getIt<GetAllProductsUseCase>(),
    );
  }

  /// Generic method to create any cubit (for future use)
  static T createCubit<T>(T Function() factory) {
    return factory();
  }
}
