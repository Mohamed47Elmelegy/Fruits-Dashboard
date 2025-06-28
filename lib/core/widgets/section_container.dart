import 'package:flutter/material.dart';
import '../theme/application_theme_manager.dart';

class SectionContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? margin;

  const SectionContainer({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin != null ? EdgeInsets.all(margin!) : null,
      padding: padding ?? const EdgeInsets.all(20),
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
      child: child,
    );
  }
}
