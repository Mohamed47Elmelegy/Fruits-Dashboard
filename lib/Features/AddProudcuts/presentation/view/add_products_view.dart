import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/presentation/manager/cubit/add_product_cubit.dart';
import 'package:furute_app_dashbord/core/repos/add_images/add_images_repo.dart';
import 'package:furute_app_dashbord/core/repos/add_proudcuts/add_product_repo.dart';
import 'package:furute_app_dashbord/core/services/get_it_services.dart';
import 'package:furute_app_dashbord/core/widgets/custom_app_bar.dart';
import 'package:furute_app_dashbord/main.dart';
import '../widgets/add_product_view_body_consumer.dart';

class AddProductsView extends StatelessWidget {
  const AddProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: 'Add Products', onTap: () {
        navigatorKey.currentState!.pop();
      }),
      body: BlocProvider(
        create: (context) => AddProductCubit(
          getIt.get<AddImagesRepo>(),
          getIt.get<AddProductsRepo>(),
        ),
        child: const AddProductsViewBodyBlocConsumer(),
      ),
    );
  }
}
