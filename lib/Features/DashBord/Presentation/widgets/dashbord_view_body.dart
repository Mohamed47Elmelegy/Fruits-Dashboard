import 'package:flutter/material.dart';
import 'package:furute_app_dashbord/core/widgets/butn.dart';
import 'package:furute_app_dashbord/main.dart';

import '../../../../core/Routes/page_routes_name.dart';
import '../../../../core/theme/colors_theme.dart';

class DashbordViewBody extends StatelessWidget {
  const DashbordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Butn(
        text: 'Add Data',
        color: AppColors.green1_500,
        onPressed: () {
          navigatorKey.currentState!.pushNamed(
            PageRoutesName.addProducts,
          );
        },
      ),
    );
  }
}
