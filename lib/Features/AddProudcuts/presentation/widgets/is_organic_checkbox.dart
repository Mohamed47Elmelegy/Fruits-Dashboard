import 'package:flutter/material.dart';
import '../../../../core/theme/application_theme_manager.dart';
import 'custom_checkbox.dart';

class IsOrganicCheckbox extends StatefulWidget {
  const IsOrganicCheckbox({super.key, required this.onChanged});
  final ValueChanged<bool> onChanged;
  @override
  IsOrganicCheckboxState createState() => IsOrganicCheckboxState();
}

class IsOrganicCheckboxState extends State<IsOrganicCheckbox> {
  bool isOrganic = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ApplicationThemeManager.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ApplicationThemeManager.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  ApplicationThemeManager.secondaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.eco,
              color: ApplicationThemeManager.secondaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organic Product',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ApplicationThemeManager.textPrimaryColor,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mark this product as organic',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ApplicationThemeManager.textSecondaryColor,
                      ),
                ),
              ],
            ),
          ),
          CustomCheckbox(
            onChecked: (value) {
              isOrganic = value;
              widget.onChanged(value);
              setState(() {});
            },
            isChecked: isOrganic,
          ),
        ],
      ),
    );
  }
}
