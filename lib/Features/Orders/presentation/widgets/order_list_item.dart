import 'package:flutter/material.dart';
import '../../../../core/theme/application_theme_manager.dart';
import '../../../../core/widgets/section_container.dart';
import '../../domain/entity/order_entity.dart';
import 'order_status_update_dialog.dart';

class OrderListItem extends StatelessWidget {
  final OrderEntity order;
  final Function(String status, String? notes) onStatusUpdate;
  final VoidCallback onViewDetails;

  const OrderListItem({
    super.key,
    required this.order,
    required this.onStatusUpdate,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return SectionContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'طلب #${order.displayOrderId}',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isSmallScreen ? 2 : 4),
                        Text(
                          order.customerName,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),

              // Order Details
              _buildOrderDetails(isSmallScreen),
              SizedBox(height: isSmallScreen ? 12 : 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: isSmallScreen ? 50 : 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ApplicationThemeManager.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => _showStatusUpdateDialog(context),
                        child: const Text('تحديث الحالة'),
                      ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: SizedBox(
                      height: isSmallScreen ? 50 : 40,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ApplicationThemeManager.primaryColor,
                          side: const BorderSide(
                              color: ApplicationThemeManager.primaryColor,
                              width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: onViewDetails,
                        child: const Text('عرض التفاصيل'),
                      ),
                    ),
                  ),
                  if (!order.isDelivered && !order.isCancelled) ...[
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    Expanded(
                      child: SizedBox(
                        height: isSmallScreen ? 50 : 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => _showCancelOrderDialog(context),
                          child: const Text('إلغاء الطلب'),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;

    switch (order.status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        statusText = 'في الانتظار';
        break;
      case 'confirmed':
        chipColor = Colors.blue;
        statusText = 'مؤكد';
        break;
      case 'processing':
        chipColor = Colors.purple;
        statusText = 'قيد المعالجة';
        break;
      case 'shipped':
        chipColor = Colors.indigo;
        statusText = 'تم الشحن';
        break;
      case 'delivered':
        chipColor = Colors.green;
        statusText = 'تم التوصيل';
        break;
      case 'cancelled':
        chipColor = Colors.red;
        statusText = 'ملغي';
        break;
      case 'refunded':
        chipColor = Colors.grey;
        statusText = 'مسترد';
        break;
      default:
        chipColor = Colors.grey;
        statusText = order.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor, width: 1),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildOrderDetails(bool isSmallScreen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDetailRow('التاريخ', order.displayDate, isSmallScreen),
        _buildDetailRow(
            'المنتجات', '${order.products.length} منتج', isSmallScreen),
        _buildDetailRow(
            'المجموع', '${order.total.toStringAsFixed(2)} ج.م', isSmallScreen),
        if (order.trackingNumber != null)
          _buildDetailRow('رقم التتبع', order.trackingNumber!, isSmallScreen),
        if (order.adminNotes != null && order.adminNotes!.isNotEmpty)
          _buildDetailRow('ملاحظات', order.adminNotes!, isSmallScreen),
        if (order.lastUpdated != null)
          _buildDetailRow(
              'آخر تحديث', _formatDateTime(order.lastUpdated!), isSmallScreen),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 6 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isSmallScreen ? 60 : 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showStatusUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => OrderStatusUpdateDialog(
        currentStatus: order.status,
        onStatusUpdate: onStatusUpdate,
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: const Text('هل أنت متأكد من إلغاء هذا الطلب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              onStatusUpdate('cancelled', 'تم إلغاء الطلب بواسطة الإدارة');
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('تأكيد الإلغاء'),
          ),
        ],
      ),
    );
  }
}
