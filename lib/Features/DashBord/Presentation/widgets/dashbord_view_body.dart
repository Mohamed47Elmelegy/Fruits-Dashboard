import 'package:flutter/material.dart';
import 'package:furute_app_dashbord/core/widgets/butn.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../../../core/theme/colors_theme.dart';

import '../../../../core/Routes/page_routes_name.dart';

class DashbordViewBody extends StatelessWidget {
  const DashbordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Butn(
        text: 'Manage Products',
        color: AppColors.green1_500,
        onPressed: () {
          NavigationHelper.goToEnhancedProducts();
        },
      ),
    );
  }
}
