import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/factories/cubit_factory.dart';
import '../manager/enhanced_product_cubit.dart';
import '../widgets/enhanced_products_consumer.dart';

class EnhancedProductsPage extends StatelessWidget {
  const EnhancedProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CubitFactory.createEnhancedProductCubit(),
      child: const EnhancedProductsConsumer(),
    );
  }
}
