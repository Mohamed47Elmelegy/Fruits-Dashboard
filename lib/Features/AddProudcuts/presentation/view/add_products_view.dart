import 'package:flutter/material.dart';
import 'package:furute_app_dashbord/core/widgets/custom_app_bar.dart';
import 'package:furute_app_dashbord/main.dart';

import '../widgets/add_products_view_body.dart';

class AddProductsView extends StatelessWidget {
  const AddProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: 'Add Products', onTap: () {
        navigatorKey.currentState!.pop();
      }),
      body: const AddProductsViewBody(),
    );
  }
}
