import 'package:flutter/material.dart';
import '../../../../core/theme/application_theme_manager.dart';
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
      title: const Text('Update Order Status'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Dropdown
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Order Status',
                border: OutlineInputBorder(),
              ),
              items: OrderStatus.getAllStatuses().map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(OrderStatus.getDisplayName(status)),
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
              hint: 'Add any notes about this status update...',
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
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
          text: 'Update Status',
          icon: Icons.save,
        ),
      ],
    );
  }
}
