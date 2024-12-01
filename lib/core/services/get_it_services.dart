import 'package:furute_app_dashbord/core/services/storage_service.dart';
import 'package:furute_app_dashbord/core/services/supabase_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void getItSetup() {
  getIt.registerLazySingleton<StorageService>(() => (SupabaseStorageService()));
}
