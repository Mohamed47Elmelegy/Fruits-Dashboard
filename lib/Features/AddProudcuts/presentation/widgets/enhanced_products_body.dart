import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/theme/application_theme_manager.dart';
import '../../../../core/widgets/error_state.dart';
import '../manager/enhanced_product_cubit.dart';

class EnhancedProductsBody extends StatefulWidget {
  const EnhancedProductsBody({super.key});

  @override
  State<EnhancedProductsBody> createState() => _EnhancedProductsBodyState();
}

class _EnhancedProductsBodyState extends State<EnhancedProductsBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnhancedProductCubit, EnhancedProductState>(
      builder: (context, state) {
        if (state is EnhancedProductLoading) {
          return _buildLoadingState();
        } else if (state is EnhancedProductsLoaded) {
          return _buildProductsList(state.products);
        } else if (state is EnhancedProductFailure) {
          return ErrorState(
            title: 'خطأ في تحميل المنتجات',
            message: state.message,
            retryText: 'إعادة المحاولة',
            onRetry: () {
              context.read<EnhancedProductCubit>().getAllProducts();
            },
          );
        } else {
          return EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'لا توجد منتجات بعد',
            message: 'ابدأ بإضافة أول منتج إلى الكتالوج',
            buttonText: 'إضافة منتج',
            onButtonPressed: () => NavigationHelper.goToAddProduct(),
            buttonIcon: Icons.add,
          );
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: ApplicationThemeManager.primaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'جاري تحميل المنتجات...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(List<dynamic> products) {
    if (products.isEmpty) {
      return EmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'لا توجد منتجات',
        message: 'ابدأ بإضافة أول منتج إلى المتجر',
        buttonText: 'إضافة منتج',
        onButtonPressed: () {
          NavigationHelper.goToAddProduct();
        },
        buttonIcon: Icons.add,
      );
    }

    return Column(
      children: [
        // Header with product count and add button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المنتجات (${products.length})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ApplicationThemeManager.primaryColor,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => NavigationHelper.goToAddProduct(),
                icon: const Icon(Icons.add),
                label: const Text('إضافة منتج'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ApplicationThemeManager.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Products list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(context, product, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, dynamic product, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product Image or Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ApplicationThemeManager.primaryColor.withOpacity(0.1),
              ),
              child: _buildProductImage(product),
            ),
            const SizedBox(width: 16),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getProductName(product),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'السعر: ${_getProductPrice(product)} ج.م',
                    style: TextStyle(
                      fontSize: 14,
                      color: ApplicationThemeManager.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_getProductDescription(product).isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _getProductDescription(product),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Action Buttons
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    NavigationHelper.goToEditProduct(product);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    final productId = _getProductId(product);
                    if (productId.isNotEmpty) {
                      _showDeleteConfirmation(context, productId);
                    } else {
                      // Show error message if product ID is null
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'خطأ: لا يمكن حذف المنتج - معرف المنتج غير موجود'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(dynamic product) {
    if (product['imageUrl'] != null &&
        product['imageUrl'].toString().isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product['imageUrl'].toString(),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.image,
              color: ApplicationThemeManager.primaryColor,
              size: 30,
            );
          },
        ),
      );
    } else {
      return Icon(
        Icons.image,
        color: ApplicationThemeManager.primaryColor,
        size: 30,
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, String productId) {
    if (productId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('خطأ: معرف المنتج غير صحيح'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد من حذف هذا المنتج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final cubit = context.read<EnhancedProductCubit>();
                cubit.deleteProduct(productId);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }

  String _getProductName(dynamic product) {
    if (product['name'] != null) {
      return product['name'].toString();
    } else if (product['productName'] != null) {
      return product['productName'].toString();
    } else {
      return 'منتج بدون اسم';
    }
  }

  String _getProductPrice(dynamic product) {
    if (product['price'] != null) {
      return product['price'].toString();
    } else if (product['productPrice'] != null) {
      return product['productPrice'].toString();
    } else {
      return '0';
    }
  }

  String _getProductDescription(dynamic product) {
    if (product['description'] != null) {
      return product['description'].toString();
    } else if (product['productDescription'] != null) {
      return product['productDescription'].toString();
    } else {
      return '';
    }
  }

  String _getProductId(dynamic product) {
    if (product['id'] != null) {
      return product['id'].toString();
    } else {
      return '';
    }
  }
}
