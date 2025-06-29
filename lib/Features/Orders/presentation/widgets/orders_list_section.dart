import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/application_theme_manager.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';
import '../manager/order_cubit.dart';
import 'order_list_item.dart';

class OrdersListSection extends StatelessWidget {
  final OrderState state;
  final String selectedStatus;

  const OrdersListSection({
    super.key,
    required this.state,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (state is OrderLoaded) {
      final loadedState = state as OrderLoaded;
      if (loadedState.orders.isEmpty) {
        return const EmptyState(
          icon: Icons.shopping_cart_outlined,
          title: 'No Orders Found',
          message: 'There are no orders matching your criteria',
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: loadedState.orders.length,
        itemBuilder: (context, index) {
          final order = loadedState.orders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OrderListItem(
              order: order,
              onStatusUpdate: (newStatus, notes) {
                context.read<OrderCubit>().updateOrderStatus(
                      order.id,
                      newStatus,
                      notes: notes,
                    );
              },
              onViewDetails: () {
                // Navigate to order details
                // TODO: Implement order details navigation
              },
            ),
          );
        },
      );
    }

    if (state is OrderFailure) {
      final failureState = state as OrderFailure;
      return ErrorState(
        message: failureState.message,
        onRetry: () {
          if (selectedStatus == 'all') {
            context.read<OrderCubit>().loadAllOrders();
          } else {
            context.read<OrderCubit>().loadOrdersByStatus(selectedStatus);
          }
        },
      );
    }

    return const Center(
      child: CircularProgressIndicator(
        color: ApplicationThemeManager.primaryColor,
      ),
    );
  }
}
