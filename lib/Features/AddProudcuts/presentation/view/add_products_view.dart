import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/presentation/manager/cubit/add_product_cubit.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/presentation/manager/enhanced_product_cubit.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/add_product_usecase.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/update_product_usecase.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/delete_product_usecase.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/usecases/get_all_products_usecase.dart';
import 'package:furute_app_dashbord/core/repos/add_images/add_images_repo.dart';
import 'package:furute_app_dashbord/core/repos/add_proudcuts/add_products_repo.dart';
import 'package:furute_app_dashbord/core/services/get_it_services.dart';
import 'package:furute_app_dashbord/core/widgets/custom_app_bar.dart';
import 'package:furute_app_dashbord/main.dart';
import '../../domin/usecases/hard_delete_product_usecase.dart';
import '../widgets/add_product_view_body_consumer.dart';

class AddProductsView extends StatelessWidget {
  const AddProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: 'Add Products', onTap: () {
        navigatorKey.currentState!.pop();
      }),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AddProductCubit(
              getIt.get<AddImagesRepo>(),
              getIt.get<AddProductsRepo>(),
            ),
          ),
          BlocProvider(
            create: (context) => EnhancedProductCubit(
              addProductUseCase: getIt.get<AddProductUseCase>(),
              updateProductUseCase: getIt.get<UpdateProductUseCase>(),
              deleteProductUseCase: getIt.get<DeleteProductUseCase>(),
              hardDeleteProductUseCase: getIt.get<HardDeleteProductUseCase>(),
              getAllProductsUseCase: getIt.get<GetAllProductsUseCase>(),
            ),
          ),
        ],
        child: const AddProductsViewBodyBlocConsumer(),
      ),
    );
  }
}
