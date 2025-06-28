import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../manager/enhanced_product_cubit.dart';
import 'enhanced_products_body.dart';
import 'enhanced_add_product_form.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';

class EnhancedProductsConsumer extends StatefulWidget {
  const EnhancedProductsConsumer({Key? key}) : super(key: key);

  @override
  State<EnhancedProductsConsumer> createState() =>
      _EnhancedProductsConsumerState();
}

class _EnhancedProductsConsumerState extends State<EnhancedProductsConsumer> {
  @override
  void initState() {
    super.initState();
    // Load products when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EnhancedProductCubit>().getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EnhancedProductCubit, EnhancedProductState>(
      listener: (context, state) {
        if (state is EnhancedProductDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product deleted successfully!')),
          );
          // Reload products after deletion
          context.read<EnhancedProductCubit>().getAllProducts();
        } else if (state is EnhancedProductFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is EnhancedProductLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is EnhancedProductsLoaded) {
          return EnhancedProductsBody(products: state.products);
        } else if (state is EnhancedProductFailure) {
          return Scaffold(
            body: ErrorState(
              title: 'Error Loading Products',
              message: state.message,
              retryText: 'Retry',
              onRetry: () {
                context.read<EnhancedProductCubit>().getAllProducts();
              },
            ),
          );
        } else {
          return Scaffold(
            body: EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'No Products Yet',
              message: 'Start by adding your first product to the catalog',
              buttonText: 'Add Product',
              onButtonPressed: () {
                NavigationHelper.goToAddProduct();
              },
              buttonIcon: Icons.add,
            ),
          );
        }
      },
    );
  }
}
