import 'package:flutter/material.dart';
import 'package:furute_app_dashbord/Features/DashBord/Presentation/view/dashbord_view.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/presentation/view/add_products_view.dart';

import '../../Features/Splash/view/splash_view.dart';
import 'page_routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PageRoutesName.initial:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case PageRoutesName.datshbord:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.addProducts:
        return MaterialPageRoute(builder: (context) => const AddProductsView());
      default:
        return MaterialPageRoute(builder: (context) => const SplashView());
    }
  }
}
