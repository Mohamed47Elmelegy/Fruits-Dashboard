import 'package:flutter/material.dart';
import '../../../../core/theme/application_theme_manager.dart';
import '../../../../core/constants/firebase_collections.dart';

class OrderStatusFilter extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusChanged;

  const OrderStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('all', 'جميع الطلبات', Icons.list),
          const SizedBox(width: 8),
          ...OrderStatus.getAllStatuses().map((status) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                status,
                _getStatusDisplayName(status),
                _getStatusIcon(status),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String status, String label, IconData icon) {
    final isSelected = selectedStatus == status;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        onStatusChanged(status);
      },
      selectedColor: ApplicationThemeManager.primaryColor,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.grey[200],
      side: BorderSide(
        color: isSelected
            ? ApplicationThemeManager.primaryColor
            : Colors.grey[300]!,
      ),
    );
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'في الانتظار';
      case 'confirmed':
        return 'مؤكد';
      case 'processing':
        return 'قيد المعالجة';
      case 'shipped':
        return 'تم الشحن';
      case 'delivered':
        return 'تم التوصيل';
      case 'cancelled':
        return 'ملغي';
      case 'refunded':
        return 'مسترد';
      default:
        return 'غير معروف';
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'processing':
        return Icons.inventory_2_outlined;
      case 'shipped':
        return Icons.local_shipping_outlined;
      case 'delivered':
        return Icons.shopping_cart_outlined;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'refunded':
        return Icons.money_off;
      default:
        return Icons.help_outline;
    }
  }
}
