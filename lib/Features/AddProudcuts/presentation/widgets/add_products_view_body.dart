import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/Data/model/reviews_model.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../manager/enhanced_product_cubit.dart';
import 'product_list_item.dart';
import '../../../../core/theme/application_theme_manager.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';

class AddProductsViewBody extends StatefulWidget {
  const AddProductsViewBody({Key? key}) : super(key: key);

  @override
  State<AddProductsViewBody> createState() => _AddProductsViewBodyState();
}

class _AddProductsViewBodyState extends State<AddProductsViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String productName, productCode, productDescription;
  late num productPrice, calorieDensity, unitAmount, expiryDateMonths;
  bool isFeatured = false;
  bool isOrganic = false;
  late List<ReviewsModel> reviews = [];
  File? image;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<EnhancedProductCubit>().getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationThemeManager.backgroundColor,
      body: BlocBuilder<EnhancedProductCubit, EnhancedProductState>(
        builder: (context, state) {
          if (state is EnhancedProductLoading) {
            return _buildLoadingState();
          } else if (state is EnhancedProductsLoaded) {
            return _buildProductsList(state.products);
          } else if (state is EnhancedProductFailure) {
            return ErrorState(
              title: 'Error Loading Products',
              message: state.message,
              retryText: 'Retry',
              onRetry: () {
                context.read<EnhancedProductCubit>().getAllProducts();
              },
            );
          } else {
            return EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'No Products Yet',
              message: 'Start by adding your first product to the catalog',
              buttonText: 'Add Product',
              onButtonPressed: () {
                NavigationHelper.goToAddProduct();
              },
              buttonIcon: Icons.add,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          NavigationHelper.goToAddProduct();
        },
        backgroundColor: ApplicationThemeManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: ApplicationThemeManager.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading products...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ApplicationThemeManager.textSecondaryColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(List<Map<String, dynamic>> products) {
    final filteredProducts = products.where((product) {
      final name = product['productName']?.toString().toLowerCase() ?? '';
      final code = product['productCode']?.toString().toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || code.contains(query);
    }).toList();

    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.all(20),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: ApplicationThemeManager.surfaceColor,
            ),
          ),
        ),

        // Products List
        Expanded(
          child: filteredProducts.isEmpty
              ? const EmptyState(
                  icon: Icons.search_off,
                  title: 'No Products Found',
                  message: 'Try adjusting your search criteria',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductListItem(
                      product: filteredProducts[index],
                      onEdit: () {
                        NavigationHelper.goToEditProduct(
                            filteredProducts[index]);
                      },
                      onDelete: () {
                        _showDeleteConfirmation(filteredProducts[index]);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
            'Are you sure you want to delete "${product['productName']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<EnhancedProductCubit>().deleteProduct(product['id']);
            },
            style: TextButton.styleFrom(
              foregroundColor: ApplicationThemeManager.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
