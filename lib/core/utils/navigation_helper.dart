import 'package:flutter/material.dart';
import '../Routes/page_routes_name.dart';
import '../../main.dart';

class NavigationHelper {
  // Basic navigation with navigatorKey
  static void pushNamed(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  // Navigation with replacement (clear stack)
  static void pushReplacementNamed(String routeName, {Object? arguments}) {
    navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  // Navigation and remove until (clear all previous routes)
  static void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Pop current route
  static void pop() {
    navigatorKey.currentState?.pop();
  }

  static void goToSettings() {
    pushNamed(PageRoutesName.settings);
  }

  // Pop with result
  static void popWithResult(dynamic result) {
    navigatorKey.currentState?.pop(result);
  }

  // Specific navigation methods for common routes
  static void goToDashboard() {
    pushNamed(PageRoutesName.datshbord);
  }

  static void goToAddProducts() {
    pushNamed(PageRoutesName.addProducts);
  }

  static void goToEnhancedProducts() {
    pushNamed(PageRoutesName.enhancedProducts);
  }

  static void goToAddProduct() {
    pushNamed(PageRoutesName.addProduct);
  }

  static void goToEditProduct(Map<String, dynamic> product) {
    pushNamed(PageRoutesName.editProduct, arguments: product);
  }

  static void goToHome() {
    pushNamed(PageRoutesName.home);
  }

  static void goToOrdersView() {
    pushNamed(PageRoutesName.ordersView);
  }

  static void goToOrders() {
    pushNamed(PageRoutesName.orders);
  }

  static void goToOrderTracking() {
    pushNamed(PageRoutesName.orderTracking);
  }

  static void goToOrderConfirmed() {
    pushNamed(PageRoutesName.orderConfirmed);
  }

  static void goToActiveOrders() {
    pushNamed(PageRoutesName.activeOrders);
  }

  static void goToInactiveOrders() {
    pushNamed(PageRoutesName.inactiveOrders);
  }

  static void goToProfile() {
    pushNamed(PageRoutesName.profile);
  }

  static void goToProducts() {
    pushNamed(PageRoutesName.products);
  }

  static void goToProductDetails() {
    pushNamed(PageRoutesName.productDetails);
  }

  static void goToCart() {
    pushNamed(PageRoutesName.cart);
  }

  static void goToCheckout() {
    pushNamed(PageRoutesName.checkout);
  }

  static void goToSignIn() {
    pushNamed(PageRoutesName.signIn);
  }

  static void goToSignUp() {
    pushNamed(PageRoutesName.signUp);
  }

  // Navigation with context (for cases where context is needed)
  static void pushNamedWithContext(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void pushReplacementNamedWithContext(
      BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void pushNamedAndRemoveUntilWithContext(
      BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void popWithContext(BuildContext context) {
    Navigator.pop(context);
  }

  static void popWithResultWithContext(BuildContext context, dynamic result) {
    Navigator.pop(context, result);
  }
}
