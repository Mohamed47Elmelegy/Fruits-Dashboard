import 'package:get_it/get_it.dart';
import '../../Features/AddProudcuts/presentation/manager/enhanced_product_cubit.dart';
import '../../Features/AddProudcuts/domin/usecases/add_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/update_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/delete_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/get_all_products_usecase.dart';
import '../../Features/Orders/presentation/manager/order_cubit.dart';
import '../../Features/Orders/domain/usecases/get_all_orders_usecase.dart';
import '../../Features/Orders/domain/usecases/get_orders_by_status_usecase.dart';
import '../../Features/Orders/domain/usecases/update_order_status_usecase.dart';
import '../../Features/Orders/domain/usecases/get_order_statistics_usecase.dart';
import '../../Features/Orders/domain/usecases/search_orders_usecase.dart';

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

  /// Creates a new OrderCubit instance
  static OrderCubit createOrderCubit() {
    return OrderCubit(
      getAllOrdersUseCase: _getIt<GetAllOrdersUseCase>(),
      getOrdersByStatusUseCase: _getIt<GetOrdersByStatusUseCase>(),
      updateOrderStatusUseCase: _getIt<UpdateOrderStatusUseCase>(),
      getOrderStatisticsUseCase: _getIt<GetOrderStatisticsUseCase>(),
      searchOrdersUseCase: _getIt<SearchOrdersUseCase>(),
    );
  }

  /// Generic method to create any cubit (for future use)
  static T createCubit<T>(T Function() factory) {
    return factory();
  }
}
