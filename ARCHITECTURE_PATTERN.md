# Architecture Pattern Documentation

## Overview
This project follows a clean architecture pattern with clear separation of concerns using the View-Consumer-Body pattern.

## Pattern Structure

### 1. View Layer (View)
- **Purpose**: Contains BlocProvider and manages dependency injection
- **Responsibility**: 
  - Creates and provides BlocProvider
  - Handles dependency injection (GetIt, etc.)
  - No UI logic, only provider setup
- **File Naming**: `*_view.dart` or `*_page.dart`

### 2. Consumer Layer (Consumer)
- **Purpose**: Contains BlocConsumer and handles state management
- **Responsibility**:
  - Listens to state changes
  - Handles navigation based on state
  - Shows loading states, error states, success messages
  - Manages side effects (SnackBars, dialogs, etc.)
- **File Naming**: `*_consumer.dart`

### 3. Body Layer (Body)
- **Purpose**: Contains pure UI components
- **Responsibility**:
  - Renders UI based on props
  - Handles user interactions
  - No state management logic
  - No BlocProvider or BlocConsumer
- **File Naming**: `*_body.dart`

## Example Implementation

### Enhanced Products Feature

```
lib/Features/AddProudcuts/presentation/
├── view/
│   └── enhanced_products_page.dart          # View (BlocProvider)
├── widgets/
│   ├── enhanced_products_consumer.dart      # Consumer (BlocConsumer)
│   ├── enhanced_products_body.dart          # Body (Pure UI)
│   ├── enhanced_add_product_form.dart       # View (BlocProvider)
│   ├── enhanced_add_product_consumer.dart   # Consumer (BlocConsumer)
│   ├── enhanced_add_product_body.dart       # Body (Pure UI)
│   └── product_list_item.dart              # Reusable UI Component
└── manager/
    └── enhanced_product_cubit.dart          # Business Logic
```

### Code Examples

#### View (enhanced_products_page.dart)
```dart
class EnhancedProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _createCubit(),
      child: const EnhancedProductsConsumer(),
    );
  }
}
```

#### Consumer (enhanced_products_consumer.dart)
```dart
class EnhancedProductsConsumer extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EnhancedProductCubit, EnhancedProductState>(
      listener: (context, state) {
        // Handle side effects
      },
      builder: (context, state) {
        if (state is EnhancedProductLoading) {
          return LoadingWidget();
        } else if (state is EnhancedProductsLoaded) {
          return EnhancedProductsBody(products: state.products);
        }
        // Handle other states
      },
    );
  }
}
```

#### Body (enhanced_products_body.dart)
```dart
class EnhancedProductsBody extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ProductListItem(
            product: products[index],
            onEdit: () => context.read<EnhancedProductCubit>().editProduct(),
            onDelete: () => context.read<EnhancedProductCubit>().deleteProduct(),
          );
        },
      ),
    );
  }
}
```

## Navigation Pattern

### Using NavigatorKey
```dart
// In main.dart
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// In MaterialApp
MaterialApp(
  navigatorKey: navigatorKey,
  onGenerateRoute: Routes.generateRoute,
)

// Navigation from anywhere
navigatorKey.currentState!.pushNamed(PageRoutesName.enhancedProducts);
```

### Navigation with BlocProvider.value
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider.value(
      value: context.read<EnhancedProductCubit>(),
      child: const EnhancedAddProductView(),
    ),
  ),
);
```

## Benefits

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Testability**: Easy to test each layer independently
3. **Reusability**: Body components can be reused with different consumers
4. **Maintainability**: Clear structure makes code easier to maintain
5. **Scalability**: Pattern scales well for large applications
6. **Error Handling**: Centralized error handling in consumer layer
7. **State Management**: Clear state flow from cubit to UI

## Best Practices

1. **View Layer**:
   - Only contain BlocProvider setup
   - Handle dependency injection
   - Keep minimal logic

2. **Consumer Layer**:
   - Handle all state transitions
   - Manage side effects
   - Control navigation flow
   - Show loading/error states

3. **Body Layer**:
   - Pure UI components
   - No state management
   - Use context.read() for actions
   - Keep components focused and reusable

4. **Navigation**:
   - Use navigatorKey for global navigation
   - Use BlocProvider.value when passing cubits
   - Define routes in centralized location

## Migration Guide

To migrate existing code to this pattern:

1. **Extract View**: Move BlocProvider to separate view file
2. **Create Consumer**: Extract BlocConsumer logic to consumer file
3. **Refactor Body**: Move UI logic to body file
4. **Update Imports**: Update all references to use new structure
5. **Test Navigation**: Ensure navigation works with new pattern 