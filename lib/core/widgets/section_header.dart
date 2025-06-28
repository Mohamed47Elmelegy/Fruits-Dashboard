import 'package:flutter/material.dart';
import '../theme/application_theme_manager.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;

  const SectionHeader({
    Key? key,
    required this.icon,
    required this.title,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor ?? ApplicationThemeManager.primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: ApplicationThemeManager.textPrimaryColor,
              ),
        ),
      ],
    );
  }
}
