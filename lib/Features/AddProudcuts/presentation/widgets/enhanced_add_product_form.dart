import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/factories/cubit_factory.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../manager/enhanced_product_cubit.dart';
import 'enhanced_add_product_consumer.dart';

class EnhancedAddProductView extends StatelessWidget {
  final Map<String, dynamic>? productToEdit;

  const EnhancedAddProductView({super.key, this.productToEdit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getOrCreateCubit(context),
      child: EnhancedAddProductConsumer(productToEdit: productToEdit),
    );
  }

  /// Get existing cubit from context or create new one using factory
  EnhancedProductCubit _getOrCreateCubit(BuildContext context) {
    // Try to get existing cubit from context
    final existingCubit = context.tryRead<EnhancedProductCubit>();

    if (existingCubit != null) {
      return existingCubit;
    }

    // If no cubit in context, create a new one using factory
    return CubitFactory.createEnhancedProductCubit();
  }
}
