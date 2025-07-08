import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/application_theme_manager.dart';
import '../../../../Features/AddProudcuts/presentation/manager/enhanced_product_cubit.dart';
import '../../../Orders/presentation/manager/order_cubit.dart';
import '../../../Orders/domain/entity/order_entity.dart';
import 'dashboard_header.dart';
import 'dashboard_choices_section.dart';

class DashbordViewBody extends StatelessWidget {
  const DashbordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final productState = context.watch<EnhancedProductCubit>().state;
    final orderState = context.watch<OrderCubit>().state;
    int productsCount = 0;
    if (productState is EnhancedProductsLoaded) {
      productsCount = productState.products.length;
    }
    int ordersCount = 0;
    double revenue = 0;
    if (orderState is OrderLoaded) {
      ordersCount = OrderEntity.totalOrders(orderState.orders);
      revenue = OrderEntity.totalRevenue(orderState.orders);
    }
    return Scaffold(
      backgroundColor: ApplicationThemeManager.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Section
              DashboardHeader(
                productsCount: productsCount,
                ordersCount: ordersCount,
                revenue: revenue.toInt(),
              ),
              // Choices Section
              const DashboardChoicesSection(),
              // Products State Example
              if (productState is EnhancedProductsLoaded)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Products count: ${productState.products.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              else if (productState is EnhancedProductLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              else if (productState is EnhancedProductFailure)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${productState.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              // Bottom padding for better scrolling
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
