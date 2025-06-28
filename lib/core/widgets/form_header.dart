import 'package:flutter/material.dart';
import '../theme/application_theme_manager.dart';

class FormHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const FormHeader({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ApplicationThemeManager.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: iconColor ?? ApplicationThemeManager.primaryColor,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ApplicationThemeManager.textPrimaryColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ApplicationThemeManager.textSecondaryColor,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
