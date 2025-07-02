import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../manager/enhanced_product_cubit.dart';
import 'enhanced_add_product_body.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class EnhancedAddProductConsumer extends StatefulWidget {
  final Map<String, dynamic>? productToEdit;

  const EnhancedAddProductConsumer({super.key, this.productToEdit});

  @override
  State<EnhancedAddProductConsumer> createState() =>
      _EnhancedAddProductConsumerState();
}

class _EnhancedAddProductConsumerState
    extends State<EnhancedAddProductConsumer> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EnhancedProductCubit, EnhancedProductState>(
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
      builder: (context, state) {
        return EnhancedAddProductBody(
          productToEdit: widget.productToEdit,
          isLoading: state is EnhancedProductLoading,
        );
      },
    );
  }

  /// Handle state changes and show appropriate messages
  void _handleStateChanges(BuildContext context, EnhancedProductState state) {
    if (state is EnhancedProductAdded) {
      CustomSnackBar.showSuccess(context, 'تم إضافة المنتج بنجاح!');
      // Reload products after addition
      final cubit = context.tryRead<EnhancedProductCubit>();
      if (cubit != null) {
        cubit.getAllProducts();
      }
      NavigationHelper.pop();
    } else if (state is EnhancedProductUpdated) {
      CustomSnackBar.showSuccess(context, 'تم تحديث المنتج بنجاح!');
      // Reload products after update
      final cubit = context.tryRead<EnhancedProductCubit>();
      if (cubit != null) {
        cubit.getAllProducts();
      }
      NavigationHelper.pop();
    } else if (state is EnhancedProductFailure) {
      CustomSnackBar.showError(context, 'خطأ: ${state.message}');
    }
  }
}
