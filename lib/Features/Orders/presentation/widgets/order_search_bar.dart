import 'package:flutter/material.dart';
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
      hint: 'البحث باسم العميل أو رقم الطلب...',
      prefixIcon: const Icon(Icons.search),
      onChanged: onChanged,
    );
  }
}
