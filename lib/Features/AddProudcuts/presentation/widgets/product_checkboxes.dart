import 'package:flutter/material.dart';
import 'is_featured_checkbox.dart';
import 'is_organic_checkbox.dart';

class ProductCheckboxes extends StatelessWidget {
  final bool isFeatured;
  final bool isOrganic;
  final Function(bool?) onFeaturedChanged;
  final Function(bool?) onOrganicChanged;

  const ProductCheckboxes({
    Key? key,
    required this.isFeatured,
    required this.isOrganic,
    required this.onFeaturedChanged,
    required this.onOrganicChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IsFeaturedCheckbox(
          onChanged: (value) => onFeaturedChanged(value),
        ),
        const SizedBox(height: 16),
        IsOrganicCheckbox(
          onChanged: (value) => onOrganicChanged(value),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
