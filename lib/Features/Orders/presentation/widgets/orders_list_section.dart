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
          title: 'لا توجد طلبات',
          message: 'لا توجد طلبات تطابق معايير البحث الخاصة بك',
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
                _showOrderDetailsDialog(context, order);
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

  void _showOrderDetailsDialog(BuildContext context, order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الطلب #${order.displayOrderId}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('العميل', order.customerName),
              _buildDetailRow('البريد الإلكتروني', order.customerEmail),
              _buildDetailRow('العنوان', order.deliveryAddress),
              _buildDetailRow('المدينة', order.city),
              _buildDetailRow('التاريخ', order.displayDate),
              _buildDetailRow('الحالة', order.statusDisplayName),
              _buildDetailRow('عدد المنتجات', '${order.products.length}'),
              _buildDetailRow('المجموع الفرعي',
                  '${order.subtotal.toStringAsFixed(2)} ج.م   '),
              _buildDetailRow(
                  'رسوم التوصيل', '${order.delivery.toStringAsFixed(2)} ج.م'),
              _buildDetailRow(
                  'المجموع الكلي', '${order.total.toStringAsFixed(2)} ج.م'),
              if (order.trackingNumber != null)
                _buildDetailRow('رقم التتبع', order.trackingNumber!),
              if (order.adminNotes != null && order.adminNotes!.isNotEmpty)
                _buildDetailRow('ملاحظات الإدارة', order.adminNotes!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget sliver({required List orders, required String selectedStatus}) {
    if (orders.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyState(
          icon: Icons.shopping_cart_outlined,
          title: 'لا توجد طلبات',
          message: 'لا توجد طلبات تطابق معايير البحث الخاصة بك',
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final order = orders[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('تفاصيل الطلب #${order.displayOrderId}'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDetailRowStatic('العميل', order.customerName),
                          _buildDetailRowStatic(
                              'البريد الإلكتروني', order.customerEmail),
                          _buildDetailRowStatic(
                              'العنوان', order.deliveryAddress),
                          _buildDetailRowStatic('المدينة', order.city),
                          _buildDetailRowStatic('التاريخ', order.displayDate),
                          _buildDetailRowStatic(
                              'الحالة', order.statusDisplayName),
                          _buildDetailRowStatic(
                              'عدد المنتجات', '${order.products.length}'),
                          _buildDetailRowStatic('المجموع الفرعي',
                              '${order.subtotal.toStringAsFixed(2)} ج.م'),
                          _buildDetailRowStatic('رسوم التوصيل',
                              '${order.delivery.toStringAsFixed(2)} ج.م'),
                          _buildDetailRowStatic('المجموع الكلي',
                              '${order.total.toStringAsFixed(2)} ج.م'),
                          if (order.trackingNumber != null)
                            _buildDetailRowStatic(
                                'رقم التتبع', order.trackingNumber!),
                          if (order.adminNotes != null &&
                              order.adminNotes!.isNotEmpty)
                            _buildDetailRowStatic(
                                'ملاحظات الإدارة', order.adminNotes!),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('إغلاق'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        childCount: orders.length,
      ),
    );
  }

  static Widget _buildDetailRowStatic(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
