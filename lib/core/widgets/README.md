# Custom Widgets Library

هذا المجلد يحتوي على مجموعة من الـ custom widgets المعاد استخدامها في جميع أنحاء التطبيق لتحسين قابلية الصيانة وتقليل تكرار الكود.

## Widgets المتاحة

### 1. SectionContainer
حاوية قياسية للأقسام مع تصميم موحد.

```dart
SectionContainer(
  child: YourContent(),
  padding: EdgeInsets.all(20), // اختياري
  margin: 16.0, // اختياري
)
```

### 2. SectionHeader
رأس موحد للأقسام مع أيقونة وعنوان.

```dart
SectionHeader(
  icon: Icons.settings,
  title: 'Product Options',
  iconColor: Colors.blue, // اختياري
)
```

### 3. FormHeader
رأس موحد للنماذج مع أيقونة وعنوان ووصف.

```dart
FormHeader(
  icon: Icons.add_shopping_cart,
  title: 'Add New Product',
  subtitle: 'Fill in the details to add a new product',
  iconColor: Colors.green, // اختياري
)
```

### 4. CustomButton
زر موحد مع دعم حالات التحميل.

```dart
CustomButton(
  onPressed: () => handleSubmit(),
  text: 'Submit',
  icon: Icons.save, // اختياري
  isLoading: false,
  loadingText: 'Loading...', // اختياري
  height: 56, // اختياري
  backgroundColor: Colors.blue, // اختياري
  textColor: Colors.white, // اختياري
)
```

### 5. CustomSnackBar
رسائل موحدة للنجاح والأخطاء.

```dart
// رسالة نجاح
CustomSnackBar.showSuccess(context, 'Product added successfully!');

// رسالة خطأ
CustomSnackBar.showError(context, 'Error: Something went wrong');
```

### 6. LoadingOverlay
شاشة تحميل موحدة.

```dart
LoadingOverlay(
  message: 'Loading products...',
)
```

### 7. EmptyState
حالة فارغة موحدة مع دعم الأزرار.

```dart
EmptyState(
  icon: Icons.inventory_2_outlined,
  title: 'No Products Yet',
  message: 'Start by adding your first product',
  buttonText: 'Add Product', // اختياري
  onButtonPressed: () => navigateToAdd(), // اختياري
  buttonIcon: Icons.add, // اختياري
)
```

### 8. ErrorState
حالة خطأ موحدة مع دعم إعادة المحاولة.

```dart
ErrorState(
  title: 'Error Loading Products', // اختياري
  message: 'Something went wrong',
  retryText: 'Retry', // اختياري
  onRetry: () => retryAction(), // اختياري
  icon: Icons.error_outline, // اختياري
)
```

## المزايا

1. **قابلية الصيانة**: تغيير التصميم في مكان واحد يؤثر على جميع الأماكن
2. **إعادة الاستخدام**: تقليل تكرار الكود
3. **التناسق**: تصميم موحد في جميع أنحاء التطبيق
4. **سهولة الاستخدام**: واجهة بسيطة وواضحة
5. **المرونة**: خيارات تخصيص متعددة

## كيفية الاستخدام

1. استورد الـ widget المطلوب:
```dart
import '../../../../core/widgets/section_container.dart';
```

2. استخدمه في الكود:
```dart
SectionContainer(
  child: Column(
    children: [
      SectionHeader(
        icon: Icons.photo_camera,
        title: 'Product Image',
      ),
      // محتوى القسم
    ],
  ),
)
```

## أمثلة عملية

### نموذج إضافة منتج محسن:
```dart
Form(
  child: Column(
    children: [
      FormHeader(
        icon: Icons.add_shopping_cart,
        title: 'Add New Product',
        subtitle: 'Fill in the details below',
      ),
      
      SectionContainer(
        child: Column(
          children: [
            SectionHeader(
              icon: Icons.photo_camera,
              title: 'Product Image',
            ),
            ImagePicker(),
          ],
        ),
      ),
      
      CustomButton(
        onPressed: submitForm,
        text: 'Add Product',
        icon: Icons.add,
        isLoading: isLoading,
      ),
    ],
  ),
)
```

### صفحة قائمة المنتجات:
```dart
BlocBuilder<ProductsCubit, ProductsState>(
  builder: (context, state) {
    if (state is ProductsLoading) {
      return LoadingOverlay(message: 'Loading products...');
    } else if (state is ProductsLoaded) {
      return state.products.isEmpty
          ? EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'No Products',
              message: 'Add your first product',
              buttonText: 'Add Product',
              onButtonPressed: () => navigateToAdd(),
            )
          : ProductsList(products: state.products);
    } else if (state is ProductsError) {
      return ErrorState(
        message: state.message,
        retryText: 'Retry',
        onRetry: () => cubit.loadProducts(),
      );
    }
    return Container();
  },
) 