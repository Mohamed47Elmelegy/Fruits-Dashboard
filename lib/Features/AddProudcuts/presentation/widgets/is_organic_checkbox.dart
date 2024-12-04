import 'package:flutter/material.dart';
import '../../../../../core/theme/colors_theme.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../core/constants/constants.dart';
import 'custom_checkbox.dart';

class IsOrganicCheckbox extends StatefulWidget {
  const IsOrganicCheckbox({super.key, required this.onChanged});
  final ValueChanged<bool> onChanged;
  @override
  IsOrganicCheckboxState createState() => IsOrganicCheckboxState();
}

class IsOrganicCheckboxState extends State<IsOrganicCheckbox> {
  bool isFeatured = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: Constatns.mediaQuery.width * 0.7,
          child: Text(
            'Is Organic item?',
            style: AppTextStyles.bodySmallSemiBold13
                .copyWith(color: AppColors.grayscale950),
          ),
        ),
        CustomCheckbox(
          onChecked: (value) {
            isFeatured = value;
            widget.onChanged(value);
            setState(() {});
          },
          isChecked: isFeatured,
        ),
      ],
    );
  }
}
