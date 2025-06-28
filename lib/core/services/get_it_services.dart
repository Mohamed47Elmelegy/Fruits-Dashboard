import 'dart:developer';
import 'package:furute_app_dashbord/core/repos/add_images/add_images_repo.dart';
import 'package:furute_app_dashbord/core/repos/add_images/add_images_repo_implment.dart';
import 'package:furute_app_dashbord/core/repos/add_proudcuts/add_products_repo_implment.dart';
import 'package:furute_app_dashbord/core/services/database_service.dart';
import 'package:furute_app_dashbord/core/services/firebase_firestore.dart';
import 'package:furute_app_dashbord/core/services/storage_service.dart';
import 'package:furute_app_dashbord/core/services/supabase_storage.dart';
import 'package:get_it/get_it.dart';

import '../repos/add_proudcuts/add_products_repo.dart';
import '../services/product_integration_service.dart';
import '../repos/add_proudcuts/enhanced_product_repo.dart';
import '../../Features/AddProudcuts/domin/usecases/add_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/update_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/delete_product_usecase.dart';
import '../../Features/AddProudcuts/domin/usecases/get_all_products_usecase.dart';
import '../config/ansicolor.dart';

final getIt = GetIt.instance;

void setupGetit() {
  try {
    // Register existing services
    try {
      getIt.registerSingleton<StorageService>(SupabaseStorageService());
    } catch (e) {
      log('Failed to register StorageService: $e');
    }

    try {
      getIt.registerSingleton<DatabaseService>(FirebaseFirestoreService());
    } catch (e) {
      log('Failed to register DatabaseService: $e');
    }

    try {
      getIt.registerSingleton<AddImagesRepo>(
          AddImagesRepoImplment(getIt.get<StorageService>()));
    } catch (e) {
      log('Failed to register AddImagesRepo: $e');
    }

    try {
      getIt.registerSingleton<AddProductsRepo>(
          AddProductRepoImplment(getIt.get<DatabaseService>()));
    } catch (e) {
      log('Failed to register AddProductsRepo: $e');
    }

    // Register Enhanced Product Management dependencies
    try {
      getIt.registerSingleton<ProductIntegrationService>(
          ProductIntegrationService());
    } catch (e) {
      log('Failed to register ProductIntegrationService: $e');
    }

    try {
      if (getIt.isRegistered<ProductIntegrationService>()) {
        getIt.registerSingleton<EnhancedProductRepo>(
          EnhancedProductRepoImpl(getIt<ProductIntegrationService>()),
        );
      }
    } catch (e) {
      log('Failed to register EnhancedProductRepo: $e');
    }

    try {
      if (getIt.isRegistered<EnhancedProductRepo>()) {
        getIt.registerSingleton<AddProductUseCase>(
          AddProductUseCase(getIt<EnhancedProductRepo>()),
        );
      }
    } catch (e) {
      log('Failed to register AddProductUseCase: $e');
    }

    try {
      if (getIt.isRegistered<EnhancedProductRepo>()) {
        getIt.registerSingleton<UpdateProductUseCase>(
          UpdateProductUseCase(getIt<EnhancedProductRepo>()),
        );
      }
    } catch (e) {
      log('Failed to register UpdateProductUseCase: $e');
    }

    try {
      if (getIt.isRegistered<EnhancedProductRepo>()) {
        getIt.registerSingleton<DeleteProductUseCase>(
          DeleteProductUseCase(getIt<EnhancedProductRepo>()),
        );
      }
    } catch (e) {
      log('Failed to register DeleteProductUseCase: $e');
    }

    try {
      if (getIt.isRegistered<EnhancedProductRepo>()) {
        getIt.registerSingleton<GetAllProductsUseCase>(
          GetAllProductsUseCase(getIt<EnhancedProductRepo>()),
        );
      }
    } catch (e) {
      log('Failed to register GetAllProductsUseCase: $e');
    }

    DebugConsoleMessages.success('✅ All dependencies registered successfully');
  } catch (e) {
    DebugConsoleMessages.error('❌ Error registering dependencies: $e');
    // Don't rethrow - let the app continue with partial functionality
  }
}
