import 'package:flutter/material.dart';
import 'package:furute_app_dashbord/Features/DashBord/Presentation/view/dashbord_view.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/presentation/view/add_products_view.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/presentation/view/enhanced_products_page.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/presentation/widgets/enhanced_add_product_form.dart';
import 'package:furute_app_dashbord/Features/Orders/presentation/view/orders_view.dart';

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
      case PageRoutesName.enhancedProducts:
        return MaterialPageRoute(
            builder: (context) => const EnhancedProductsPage());
      case PageRoutesName.addProduct:
        return MaterialPageRoute(
            builder: (context) => const EnhancedAddProductView());
      case PageRoutesName.editProduct:
        final product = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => EnhancedAddProductView(productToEdit: product),
        );
      case PageRoutesName.home:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.orders:
        return MaterialPageRoute(builder: (context) => const OrdersView());
      case PageRoutesName.ordersView:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.orderTracking:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.orderConfirmed:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.activeOrders:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.inactiveOrders:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.profile:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.products:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.productDetails:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.cart:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.checkout:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.signIn:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      case PageRoutesName.signUp:
        return MaterialPageRoute(builder: (context) => const DashbordView());
      default:
        return MaterialPageRoute(builder: (context) => const SplashView());
    }
  }
}
