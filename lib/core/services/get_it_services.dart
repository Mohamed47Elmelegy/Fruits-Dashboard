import 'package:furute_app_dashbord/core/repos/add_images/add_images_repo.dart';
import 'package:furute_app_dashbord/core/repos/add_images/add_images_repo_implment.dart';
import 'package:furute_app_dashbord/core/repos/add_proudcuts/add_product_repo.dart';
import 'package:furute_app_dashbord/core/repos/add_proudcuts/add_product_repo_implment.dart';
import 'package:furute_app_dashbord/core/services/database_service.dart';
import 'package:furute_app_dashbord/core/services/firebase_firestore.dart';
import 'package:furute_app_dashbord/core/services/storage_service.dart';
import 'package:furute_app_dashbord/core/services/supabase_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void getItSetup() {
  getIt.registerSingleton<StorageService>(SupabaseStorageService());
  getIt.registerSingleton<DatabaseService>(FirebaseFirestoreService());
  getIt.registerSingleton<AddImagesRepo>(
      AddImagesRepoImplment(getIt.get<StorageService>()));
  getIt.registerSingleton<AddProductsRepo>(
      AddProductRepoImplment(getIt.get<DatabaseService>()));
}
