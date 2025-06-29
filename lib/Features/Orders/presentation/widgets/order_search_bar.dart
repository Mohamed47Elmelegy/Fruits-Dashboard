import 'package:flutter/material.dart';
import '../../../../core/theme/application_theme_manager.dart';
import '../../../../core/widgets/custom_text_field.dart';

class OrderSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String?) onChanged;

  const OrderSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hint: 'Search by customer name or order ID...',
      prefixIcon: const Icon(Icons.search),
      onChanged: onChanged,
    );
  }
}
