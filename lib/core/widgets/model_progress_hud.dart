import 'package:flutter/material.dart';
import 'package:furute_app_dashbord/core/theme/colors_theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CustomModelProgressHud extends StatelessWidget {
  const CustomModelProgressHud(
      {super.key, required this.isLoding, required this.child});
  final bool isLoding;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: LoadingAnimationWidget.inkDrop(
        color: AppColors.green300,
        size: 80,
      ),
      inAsyncCall: isLoding,
      blur: 0.6,
      child: child,
    );
  }
}
