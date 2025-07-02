import 'package:flutter/material.dart';
import '../../../../core/theme/application_theme_manager.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool> onChecked;

  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onChecked,
  });

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  void didUpdateWidget(CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      _isChecked = widget.isChecked;
    }
  }

  void _toggleCheckbox() {
    setState(() {
      _isChecked = !_isChecked;
    });
    widget.onChecked(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCheckbox,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
          color: _isChecked
              ? ApplicationThemeManager.primaryColor
              : ApplicationThemeManager.surfaceColor,
          border: Border.all(
            color: _isChecked
                ? ApplicationThemeManager.primaryColor
                : ApplicationThemeManager.textSecondaryColor
                    .withValues(alpha: 0.3),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: _isChecked
              ? [
                  BoxShadow(
                    color: ApplicationThemeManager.primaryColor
                        .withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: _isChecked
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
                weight: 900,
              )
            : null,
      ),
    );
  }
}
