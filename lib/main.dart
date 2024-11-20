import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/Routes/page_routes_name.dart';
import 'core/Routes/routes.dart';
import 'core/theme/application_theme_manager.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FruitAppDashBord());
}

class FruitAppDashBord extends StatelessWidget {
  const FruitAppDashBord({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: PageRoutesName.initial,
      navigatorKey: navigatorKey,
      theme: ApplicationThemeManager.applicationThemeData,
    );
  }
}
