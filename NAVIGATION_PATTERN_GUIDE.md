# Navigation Pattern Guide

## Overview
This guide explains the standardized navigation pattern used throughout the application, replacing direct Navigator calls with centralized navigation methods.

## Navigation Helper

### Basic Usage
Instead of using direct Navigator calls, use the `NavigationHelper` class:

```dart
// ❌ Old way
Navigator.pushNamed(context, '/add-product');
navigatorKey.currentState?.pushNamed('/add-product');

// ✅ New way
NavigationHelper.goToAddProduct();
```

### Available Navigation Methods

#### Product Management
```dart
NavigationHelper.goToAddProducts();           // Go to add products page
NavigationHelper.goToEnhancedProducts();      // Go to enhanced products page
NavigationHelper.goToAddProduct();            // Go to add product form
NavigationHelper.goToEditProduct(product);    // Go to edit product form
```

#### Main Navigation
```dart
NavigationHelper.goToDashboard();             // Go to dashboard
NavigationHelper.goToHome();                  // Go to home
NavigationHelper.goToProfile();               // Go to profile
```

#### Orders Management
```dart
NavigationHelper.goToOrdersView();            // Go to orders view
NavigationHelper.goToOrderTracking();         // Go to order tracking
NavigationHelper.goToOrderConfirmed();        // Go to order confirmed
NavigationHelper.goToActiveOrders();          // Go to active orders
NavigationHelper.goToInactiveOrders();        // Go to inactive orders
```

#### Shopping
```dart
NavigationHelper.goToProducts();              // Go to products
NavigationHelper.goToProductDetails();        // Go to product details
NavigationHelper.goToCart();                  // Go to cart
NavigationHelper.goToCheckout();              // Go to checkout
```

#### Authentication
```dart
NavigationHelper.goToSignIn();                // Go to sign in
NavigationHelper.goToSignUp();                // Go to sign up
```

### Advanced Navigation Methods

#### Basic Navigation
```dart
NavigationHelper.pushNamed('/custom-route');
NavigationHelper.pushNamed('/custom-route', arguments: data);
```

#### Navigation with Replacement
```dart
NavigationHelper.pushReplacementNamed('/route');  // Clear current route
```

#### Navigation and Clear Stack
```dart
NavigationHelper.pushNamedAndRemoveUntil('/route');  // Clear all previous routes
```

#### Pop Navigation
```dart
NavigationHelper.pop();                        // Pop current route
NavigationHelper.popWithResult(data);          // Pop with result
```

### Context-Based Navigation (When Context is Required)

For cases where context is needed (like in dialogs or specific widgets):

```dart
NavigationHelper.pushNamedWithContext(context, '/route');
NavigationHelper.pushReplacementNamedWithContext(context, '/route');
NavigationHelper.pushNamedAndRemoveUntilWithContext(context, '/route');
NavigationHelper.popWithContext(context);
NavigationHelper.popWithResultWithContext(context, data);
```

## Route Constants

All route names are defined in `PageRoutesName` class:

```dart
class PageRoutesName {
  static const String initial = '/';
  static const String datshbord = '/datshbord';
  static const String addProducts = '/addProducts';
  static const String enhancedProducts = '/enhancedProducts';
  static const String addProduct = '/add-product';
  static const String editProduct = '/edit-product';
  // ... more routes
}
```

## Migration Examples

### Before (Old Pattern)
```dart
// Direct Navigator calls
Navigator.pushNamed(context, '/add-product');
Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductView()));
navigatorKey.currentState?.pushNamed('/add-product');

// Mixed patterns
Navigator.pushReplacementNamed(context, '/home');
Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
```

### After (New Pattern)
```dart
// Centralized navigation
NavigationHelper.goToAddProduct();
NavigationHelper.goToHome();
NavigationHelper.pushNamedAndRemoveUntil('/login');
```

## Implementation in Different Scenarios

### 1. Button Navigation
```dart
ElevatedButton(
  onPressed: () => NavigationHelper.goToAddProduct(),
  child: Text('Add Product'),
)
```

### 2. List Item Navigation
```dart
ListTile(
  onTap: () => NavigationHelper.goToEditProduct(product),
  title: Text(product.name),
)
```

### 3. Floating Action Button
```dart
FloatingActionButton(
  onPressed: () => NavigationHelper.goToAddProduct(),
  child: Icon(Icons.add),
)
```

### 4. App Bar Actions
```dart
AppBar(
  actions: [
    IconButton(
      onPressed: () => NavigationHelper.goToProfile(),
      icon: Icon(Icons.person),
    ),
  ],
)
```

### 5. Dialog Navigation
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    actions: [
      TextButton(
        onPressed: () => NavigationHelper.popWithContext(context),
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          NavigationHelper.popWithContext(context);
          NavigationHelper.goToHome();
        },
        child: Text('OK'),
      ),
    ],
  ),
)
```

## Benefits

1. **Consistency**: All navigation follows the same pattern
2. **Maintainability**: Route changes only need to be updated in one place
3. **Type Safety**: Compile-time checking for route names
4. **Centralized Control**: Easy to add navigation logging, analytics, or middleware
5. **Testing**: Easier to mock navigation in tests
6. **Documentation**: Clear overview of all available navigation options

## Best Practices

1. **Always use NavigationHelper**: Never use direct Navigator calls
2. **Use specific methods**: Prefer `goToAddProduct()` over `pushNamed('/add-product')`
3. **Pass arguments correctly**: Use the dedicated methods for routes that need arguments
4. **Handle context properly**: Use context-based methods when context is required
5. **Keep routes organized**: Add new routes to PageRoutesName class
6. **Update NavigationHelper**: Add new navigation methods when adding new routes

## Adding New Routes

1. Add route constant to `PageRoutesName`:
```dart
static const String newFeature = '/new-feature';
```

2. Add route to `Routes.generateRoute()`:
```dart
case PageRoutesName.newFeature:
  return MaterialPageRoute(builder: (context) => NewFeatureView());
```

3. Add navigation method to `NavigationHelper`:
```dart
static void goToNewFeature() {
  pushNamed(PageRoutesName.newFeature);
}
```

4. Use the new method in your code:
```dart
NavigationHelper.goToNewFeature();
```

This pattern ensures consistent, maintainable navigation throughout the application. 