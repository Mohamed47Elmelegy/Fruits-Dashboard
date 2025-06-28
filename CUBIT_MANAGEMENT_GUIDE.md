# Cubit Management Guide

## Overview
This guide explains the standardized patterns for managing cubits throughout the application, ensuring proper availability and lifecycle management.

## Cubit Management Patterns

### 1. Context Extensions

#### Safe Cubit Reading
```dart
// ❌ Old way - throws exception if cubit not found
final cubit = context.read<EnhancedProductCubit>();

// ✅ New way - returns null if cubit not found
final cubit = context.tryRead<EnhancedProductCubit>();

// ✅ New way - throws descriptive exception if cubit not found
final cubit = context.safeRead<EnhancedProductCubit>();
```

#### Usage Examples
```dart
// Safe reading with null check
final cubit = context.tryRead<EnhancedProductCubit>();
if (cubit != null) {
  cubit.addProduct(product);
}

// Safe reading with fallback
final cubit = context.tryRead<EnhancedProductCubit>() ?? createNewCubit();
```

### 2. Cubit Factory

#### Centralized Cubit Creation
```dart
// ❌ Old way - scattered cubit creation
final getIt = GetIt.instance;
final cubit = EnhancedProductCubit(
  addProductUseCase: getIt<AddProductUseCase>(),
  updateProductUseCase: getIt<UpdateProductUseCase>(),
  deleteProductUseCase: getIt<DeleteProductUseCase>(),
  getAllProductsUseCase: getIt<GetAllProductsUseCase>(),
);

// ✅ New way - centralized factory
final cubit = CubitFactory.createEnhancedProductCubit();
```

#### Factory Methods
```dart
class CubitFactory {
  // Specific cubit creation
  static EnhancedProductCubit createEnhancedProductCubit() {
    return EnhancedProductCubit(
      addProductUseCase: _getIt<AddProductUseCase>(),
      updateProductUseCase: _getIt<UpdateProductUseCase>(),
      deleteProductUseCase: _getIt<DeleteProductUseCase>(),
      getAllProductsUseCase: _getIt<GetAllProductsUseCase>(),
    );
  }

  // Generic cubit creation
  static T createCubit<T>(T Function() factory) {
    return factory();
  }
}
```

### 3. View Layer Cubit Management

#### Pattern 1: Create New Cubit (Default)
```dart
class EnhancedProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CubitFactory.createEnhancedProductCubit(),
      child: const EnhancedProductsConsumer(),
    );
  }
}
```

#### Pattern 2: Reuse Existing Cubit (When Available)
```dart
class EnhancedAddProductView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getOrCreateCubit(context),
      child: EnhancedAddProductConsumer(productToEdit: productToEdit),
    );
  }

  EnhancedProductCubit _getOrCreateCubit(BuildContext context) {
    // Try to get existing cubit from context
    final existingCubit = context.tryRead<EnhancedProductCubit>();
    
    if (existingCubit != null) {
      return existingCubit;
    }
    
    // If no cubit in context, create a new one using factory
    return CubitFactory.createEnhancedProductCubit();
  }
}
```

#### Pattern 3: BlocProvider.value (For Passing Existing Cubit)
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

### 4. Cubit Lifecycle Management

#### Proper Disposal
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final EnhancedProductCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CubitFactory.createEnhancedProductCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: MyChildWidget(),
    );
  }
}
```

#### Automatic Disposal with BlocProvider
```dart
// BlocProvider automatically disposes the cubit when the widget is disposed
BlocProvider(
  create: (context) => CubitFactory.createEnhancedProductCubit(),
  child: MyWidget(),
)
```

### 5. Cubit Availability Scenarios

#### Scenario 1: Direct Route Navigation
```dart
// User navigates directly to /add-product
// No existing cubit in context
// Solution: Create new cubit
NavigationHelper.goToAddProduct();
```

#### Scenario 2: Navigation from Products List
```dart
// User is in products list (has cubit) and navigates to add product
// Existing cubit available in context
// Solution: Reuse existing cubit
NavigationHelper.goToAddProduct();
```

#### Scenario 3: Deep Linking
```dart
// User opens app directly to specific route
// No cubit context available
// Solution: Create new cubit with proper dependencies
```

### 6. Best Practices

#### 1. Always Use Factory for Cubit Creation
```dart
// ✅ Good
final cubit = CubitFactory.createEnhancedProductCubit();

// ❌ Bad
final cubit = EnhancedProductCubit(
  addProductUseCase: GetIt.instance<AddProductUseCase>(),
  // ... more dependencies
);
```

#### 2. Use Safe Context Reading
```dart
// ✅ Good
final cubit = context.tryRead<EnhancedProductCubit>();

// ❌ Bad
final cubit = context.read<EnhancedProductCubit>(); // May throw
```

#### 3. Handle Cubit Availability Gracefully
```dart
// ✅ Good
EnhancedProductCubit _getOrCreateCubit(BuildContext context) {
  final existingCubit = context.tryRead<EnhancedProductCubit>();
  return existingCubit ?? CubitFactory.createEnhancedProductCubit();
}

// ❌ Bad
EnhancedProductCubit _getOrCreateCubit(BuildContext context) {
  try {
    return context.read<EnhancedProductCubit>();
  } catch (e) {
    return createNewCubit();
  }
}
```

#### 4. Use Appropriate BlocProvider Pattern
```dart
// For new cubits
BlocProvider(create: (context) => CubitFactory.createCubit())

// For existing cubits
BlocProvider.value(value: existingCubit)

// For conditional cubit creation
BlocProvider(create: (context) => getOrCreateCubit(context))
```

### 7. Testing Cubit Management

#### Mock Cubit Factory
```dart
class MockCubitFactory {
  static EnhancedProductCubit createEnhancedProductCubit() {
    return MockEnhancedProductCubit();
  }
}
```

#### Test Cubit Availability
```dart
testWidgets('should create new cubit when none available', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: EnhancedAddProductView(),
    ),
  );

  // Verify new cubit was created
  expect(find.byType(BlocProvider), findsOneWidget);
});
```

### 8. Adding New Cubits

#### Step 1: Add to CubitFactory
```dart
class CubitFactory {
  static NewFeatureCubit createNewFeatureCubit() {
    return NewFeatureCubit(
      useCase: _getIt<NewFeatureUseCase>(),
    );
  }
}
```

#### Step 2: Create View with Proper Management
```dart
class NewFeatureView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getOrCreateCubit(context),
      child: NewFeatureConsumer(),
    );
  }

  NewFeatureCubit _getOrCreateCubit(BuildContext context) {
    final existingCubit = context.tryRead<NewFeatureCubit>();
    return existingCubit ?? CubitFactory.createNewFeatureCubit();
  }
}
```

#### Step 3: Add Navigation Method
```dart
class NavigationHelper {
  static void goToNewFeature() {
    pushNamed(PageRoutesName.newFeature);
  }
}
```

This pattern ensures consistent, maintainable cubit management throughout the application with proper lifecycle handling and availability checking. 