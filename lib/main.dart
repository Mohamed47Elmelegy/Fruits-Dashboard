import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:furute_app_dashbord/core/services/supabase_storage.dart';
import 'core/Routes/page_routes_name.dart';
import 'core/Routes/routes.dart';
import 'core/services/bloc_observer_service.dart';
import 'core/services/get_it_services.dart';
import 'core/theme/application_theme_manager.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SupabaseStorageService.initialSubabase();
  Bloc.observer = BlocObserverService();
  await Firebase.initializeApp();
  getItSetup();
  runApp(const FruitAppDashBord());
}

class FruitAppDashBord extends StatelessWidget {
  const FruitAppDashBord({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(
        builder: BotToastInit(),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: PageRoutesName.initial,
      navigatorKey: navigatorKey,
      theme: ApplicationThemeManager.applicationThemeData,
    );
  }
}
