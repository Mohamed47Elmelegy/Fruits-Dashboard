import 'package:flutter/material.dart';
import '../../../../core/theme/application_theme_manager.dart';
import '../../../../core/widgets/section_container.dart';
import '../../../../core/widgets/custom_button.dart';
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
                          'Order #${order.displayOrderId}',
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
                    child: CustomButton(
                      text: 'تحديث الحالة',
                      onPressed: () => _showStatusUpdateDialog(context),
                      backgroundColor: ApplicationThemeManager.primaryColor,
                      textColor: Colors.white,
                      height: isSmallScreen ? 50 : 40,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: CustomButton(
                      text: 'عرض التفاصيل',
                      onPressed: onViewDetails,
                      backgroundColor: Colors.transparent,
                      textColor: ApplicationThemeManager.primaryColor,
                      height: isSmallScreen ? 50 : 40,
                    ),
                  ),
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
      case 'processing':
        chipColor = Colors.blue;
        statusText = 'قيد المعالجة';
        break;
      case 'shipped':
        chipColor = Colors.purple;
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
      default:
        chipColor = Colors.grey;
        statusText = order.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
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
        _buildDetailRow('Date', order.displayDate, isSmallScreen),
        _buildDetailRow(
            'Items', '${order.products.length} products', isSmallScreen),
        _buildDetailRow(
            'Total', '\$${order.total.toStringAsFixed(2)}', isSmallScreen),
        if (order.trackingNumber != null)
          _buildDetailRow('Tracking', order.trackingNumber!, isSmallScreen),
        if (order.adminNotes != null && order.adminNotes!.isNotEmpty)
          _buildDetailRow('Notes', order.adminNotes!, isSmallScreen),
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

  void _showStatusUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => OrderStatusUpdateDialog(
        currentStatus: order.status,
        onStatusUpdate: onStatusUpdate,
      ),
    );
  }
}
