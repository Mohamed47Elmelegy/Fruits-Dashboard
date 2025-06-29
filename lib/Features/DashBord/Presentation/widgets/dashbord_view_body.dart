import 'package:flutter/material.dart';
import '../../../../core/theme/application_theme_manager.dart';
import 'dashboard_header.dart';
import 'dashboard_choices_section.dart';

class DashbordViewBody extends StatelessWidget {
  const DashbordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ApplicationThemeManager.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Section
              DashboardHeader(),

              // Choices Section
              DashboardChoicesSection(),

              // Bottom padding for better scrolling
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
