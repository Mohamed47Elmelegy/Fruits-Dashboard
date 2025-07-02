import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/constants/firebase_collections.dart';

class OrderStatusUpdateDialog extends StatefulWidget {
  final String currentStatus;
  final Function(String status, String? notes) onStatusUpdate;

  const OrderStatusUpdateDialog({
    super.key,
    required this.currentStatus,
    required this.onStatusUpdate,
  });

  @override
  State<OrderStatusUpdateDialog> createState() =>
      _OrderStatusUpdateDialogState();
}

class _OrderStatusUpdateDialogState extends State<OrderStatusUpdateDialog> {
  String _selectedStatus = '';
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تحديث حالة الطلب'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Dropdown
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'حالة الطلب',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment),
              ),
              items: OrderStatus.getAllStatuses().map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Row(
                    children: [
                      Icon(_getStatusIcon(status), size: 16),
                      const SizedBox(width: 8),
                      Text(_getStatusDisplayName(status)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Notes Field
            CustomTextField(
              controller: _notesController,
              hint: 'أضف ملاحظات حول هذا التحديث...',
              maxLines: 3,
              prefixIcon: const Icon(Icons.note),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        CustomButton(
          onPressed: () {
            if (_selectedStatus.isNotEmpty) {
              widget.onStatusUpdate(
                _selectedStatus,
                _notesController.text.isNotEmpty ? _notesController.text : null,
              );
              Navigator.of(context).pop();
            }
          },
          text: 'تحديث الحالة',
          icon: Icons.save,
        ),
      ],
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
