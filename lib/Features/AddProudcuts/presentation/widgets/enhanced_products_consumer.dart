import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/snack_bar_service.dart';
import '../../../../core/widgets/model_progress_hud.dart';
import '../manager/enhanced_product_cubit.dart';
import 'enhanced_products_body.dart';

class EnhancedProductsConsumer extends StatefulWidget {
  const EnhancedProductsConsumer({super.key});

  @override
  State<EnhancedProductsConsumer> createState() =>
      _EnhancedProductsConsumerState();
}

class _EnhancedProductsConsumerState extends State<EnhancedProductsConsumer> {
  @override
  void initState() {
    super.initState();
    // Load products when the page starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<EnhancedProductCubit>();
      cubit.getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EnhancedProductCubit, EnhancedProductState>(
      listener: (context, state) {
        if (state is EnhancedProductAdded) {
          SnackBarService.showSuccessMessage('تم إضافة المنتج بنجاح');
          // Reload products after adding
          context.read<EnhancedProductCubit>().getAllProducts();
        } else if (state is EnhancedProductUpdated) {
          SnackBarService.showSuccessMessage('تم تحديث المنتج بنجاح');
          // Reload products after updating
          context.read<EnhancedProductCubit>().getAllProducts();
        } else if (state is EnhancedProductDeleted) {
          SnackBarService.showSuccessMessage('تم حذف المنتج بنجاح');
          // Reload products after deleting
          context.read<EnhancedProductCubit>().getAllProducts();
        } else if (state is EnhancedProductFailure) {
          SnackBarService.showErrorMessage(state.message);
        }
      },
      builder: (context, state) {
        return CustomModelProgressHud(
          isLoding: state is EnhancedProductLoading,
          child: const EnhancedProductsBody(),
        );
      },
    );
  }
}
