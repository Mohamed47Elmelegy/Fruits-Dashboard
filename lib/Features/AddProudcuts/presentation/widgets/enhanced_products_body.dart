import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../manager/enhanced_product_cubit.dart';
import 'product_list_item.dart';
import 'enhanced_add_product_form.dart';
import '../../../../core/widgets/empty_state.dart';

class EnhancedProductsBody extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const EnhancedProductsBody({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Management'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<EnhancedProductCubit>().getAllProducts();
            },
          ),
        ],
      ),
      body: _buildProductsList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigationHelper.goToAddProduct();
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductsList(BuildContext context) {
    if (products.isEmpty) {
      return EmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'No Products Found',
        message: 'No products match your current criteria',
        buttonText: 'Add Product',
        onButtonPressed: () {
          NavigationHelper.goToAddProduct();
        },
        buttonIcon: Icons.add,
      );
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductListItem(
          product: product,
          onEdit: () {
            NavigationHelper.goToEditProduct(product);
          },
          onDelete: () {
            context.read<EnhancedProductCubit>().deleteProduct(product['id']);
          },
        );
      },
    );
  }
}
