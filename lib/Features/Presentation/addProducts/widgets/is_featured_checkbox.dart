import 'package:flutter/material.dart';
import '../../../../../core/theme/colors_theme.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../core/constants/constants.dart';
import 'custom_checkbox.dart';

class IsFeaturedCheckbox extends StatefulWidget {
  const IsFeaturedCheckbox({super.key, required this.onChanged});
  final ValueChanged<bool> onChanged;
  @override
  IsFeaturedCheckboxState createState() => IsFeaturedCheckboxState();
}

class IsFeaturedCheckboxState extends State<IsFeaturedCheckbox> {
  bool isFeatured = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: Constants.mediaQuery.width * 0.7,
          child: Text(
            'Is Featured item?',
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
