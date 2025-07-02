import 'package:flutter/material.dart';
import '../../../../core/theme/application_theme_manager.dart';

class ProductFormFields extends StatelessWidget {
  final TextEditingController productNameController;
  final TextEditingController productPriceController;
  final TextEditingController productCodeController;
  final TextEditingController productDescriptionController;
  final TextEditingController expiryDateMonthsController;
  final TextEditingController calorieDensityController;
  final TextEditingController unitAmountController;

  const ProductFormFields({
    super.key,
    required this.productNameController,
    required this.productPriceController,
    required this.productCodeController,
    required this.productDescriptionController,
    required this.expiryDateMonthsController,
    required this.calorieDensityController,
    required this.unitAmountController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Product Name
        _buildFormField(
          controller: productNameController,
          label: 'Product Name',
          icon: Icons.inventory_2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter product name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Product Price
        _buildFormField(
          controller: productPriceController,
          label: 'Price',
          icon: Icons.attach_money,
          prefixText: '\$',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter price';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Product Code
        _buildFormField(
          controller: productCodeController,
          label: 'Product Code',
          icon: Icons.qr_code,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter product code';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Product Description
        _buildFormField(
          controller: productDescriptionController,
          label: 'Description',
          icon: Icons.description,
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter description';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Two columns for numeric fields
        Row(
          children: [
            Expanded(
              child: _buildFormField(
                controller: expiryDateMonthsController,
                label: 'Expiry Date (Months)',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiry date';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFormField(
                controller: calorieDensityController,
                label: 'Calories',
                icon: Icons.local_fire_department,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calories';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Unit Amount
        _buildFormField(
          controller: unitAmountController,
          label: 'Unit Amount',
          icon: Icons.scale,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter unit amount';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? prefixText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: ApplicationThemeManager.primaryColor),
        prefixText: prefixText,
        suffixIcon: validator != null && validator(controller.text) != null
            ? const Icon(Icons.error, color: ApplicationThemeManager.errorColor)
            : null,
      ),
      validator: validator,
    );
  }
}
