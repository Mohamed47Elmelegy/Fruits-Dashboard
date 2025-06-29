import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/get_it_services.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../main.dart';
import '../manager/enhanced_product_cubit.dart';
import '../widgets/enhanced_products_consumer.dart';
import '../../domin/usecases/add_product_usecase.dart';
import '../../domin/usecases/update_product_usecase.dart';
import '../../domin/usecases/delete_product_usecase.dart';
import '../../domin/usecases/get_all_products_usecase.dart';

class EnhancedProductsPage extends StatelessWidget {
  const EnhancedProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: 'إدارة المنتجات', onTap: () {
        navigatorKey.currentState!.pop();
      }),
      body: BlocProvider(
        create: (context) => EnhancedProductCubit(
          addProductUseCase: getIt.get<AddProductUseCase>(),
          updateProductUseCase: getIt.get<UpdateProductUseCase>(),
          deleteProductUseCase: getIt.get<DeleteProductUseCase>(),
          getAllProductsUseCase: getIt.get<GetAllProductsUseCase>(),
        ),
        child: const EnhancedProductsConsumer(),
      ),
    );
  }
}
