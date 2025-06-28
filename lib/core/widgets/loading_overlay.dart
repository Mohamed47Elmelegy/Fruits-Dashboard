import 'package:flutter/material.dart';
import '../theme/application_theme_manager.dart';

class LoadingOverlay extends StatelessWidget {
  final String message;

  const LoadingOverlay({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ApplicationThemeManager.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: ApplicationThemeManager.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ApplicationThemeManager.textPrimaryColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
