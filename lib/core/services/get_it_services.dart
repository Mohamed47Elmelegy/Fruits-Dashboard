import 'package:get_it/get_it.dart';
import '../config/ansicolor.dart';
import '../../Features/Orders/domain/usecases/get_all_orders_usecase.dart';
import '../../Features/Orders/domain/usecases/get_orders_by_status_usecase.dart';
import '../../Features/Orders/domain/usecases/update_order_status_usecase.dart';
import '../../Features/Orders/domain/usecases/get_order_statistics_usecase.dart';
import '../../Features/Orders/domain/usecases/search_orders_usecase.dart';
import '../../Features/Orders/data/repositories/order_repository_impl.dart';
import '../../Features/Orders/domain/repositories/order_repository.dart';
import '../services/order_management_service.dart';
import '../../Features/AddProudcuts/domin/usecases/add_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/update_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/delete_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/hard_delete_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/get_all_products_usecase.dart';
import '../../Features/AddProudcuts/domin/repos/product_repository.dart';
import '../../Features/AddProudcuts/Data/repos/enhanced_product_repository.dart';
import 'package:furute_app_dashbord/core/services/product_integration_service.dart';

final getIt = GetIt.instance;

void setupGetit() {
  try {
    // Register Order Management Services
    getIt.registerLazySingleton<OrderManagementService>(
      () => OrderManagementService(),
    );

    // Register Order Repository
    getIt.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(getIt<OrderManagementService>()),
    );

    // Register Order Use Cases
    getIt.registerLazySingleton<GetAllOrdersUseCase>(
      () => GetAllOrdersUseCase(getIt<OrderRepository>()),
    );

    getIt.registerLazySingleton<GetOrdersByStatusUseCase>(
      () => GetOrdersByStatusUseCase(getIt<OrderRepository>()),
    );

    getIt.registerLazySingleton<UpdateOrderStatusUseCase>(
      () => UpdateOrderStatusUseCase(getIt<OrderRepository>()),
    );

    getIt.registerLazySingleton<GetOrderStatisticsUseCase>(
      () => GetOrderStatisticsUseCase(getIt<OrderRepository>()),
    );

    getIt.registerLazySingleton<SearchOrdersUseCase>(
      () => SearchOrdersUseCase(getIt<OrderRepository>()),
    );

    // Register Product Integration Service first (before other services that depend on it)
    getIt.registerLazySingleton<ProductIntegrationService>(
      () => ProductIntegrationService(),
    );

    // Register Product Repository
    getIt.registerLazySingleton<ProductRepository>(
      () => EnhancedProductRepository(getIt<ProductIntegrationService>()),
    );

    // Register Product Use Cases
    getIt.registerLazySingleton<AddProductUseCase>(
      () => AddProductUseCase(getIt<ProductRepository>()),
    );

    getIt.registerLazySingleton<UpdateProductUseCase>(
      () => UpdateProductUseCase(getIt<ProductRepository>()),
    );

    getIt.registerLazySingleton<DeleteProductUseCase>(
      () => DeleteProductUseCase(getIt<ProductRepository>()),
    );

    getIt.registerLazySingleton<HardDeleteProductUseCase>(
      () => HardDeleteProductUseCase(getIt<ProductRepository>()),
    );

    getIt.registerLazySingleton<GetAllProductsUseCase>(
      () => GetAllProductsUseCase(getIt<ProductRepository>()),
    );

    DebugConsoleMessages.success('✅ All dependencies registered successfully');
  } catch (e) {
    DebugConsoleMessages.error('❌ Error registering dependencies: $e');
    DebugConsoleMessages.info('💡 Error details: $e');
    // Don't rethrow - let the app continue with partial functionality
  }
}
