import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/enhanced_product_cubit.dart';
import 'enhanced_add_product_body.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class EnhancedAddProductConsumer extends StatefulWidget {
  final Map<String, dynamic>? productToEdit;

  const EnhancedAddProductConsumer({Key? key, this.productToEdit})
      : super(key: key);

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
        if (state is EnhancedProductAdded) {
          CustomSnackBar.showSuccess(context, 'Product added successfully!');
          Navigator.pop(context);
        } else if (state is EnhancedProductUpdated) {
          CustomSnackBar.showSuccess(context, 'Product updated successfully!');
          Navigator.pop(context);
        } else if (state is EnhancedProductFailure) {
          CustomSnackBar.showError(context, 'Error: ${state.message}');
        }
      },
      builder: (context, state) {
        return EnhancedAddProductBody(
          productToEdit: widget.productToEdit,
          isLoading: state is EnhancedProductLoading,
        );
      },
    );
  }
}
