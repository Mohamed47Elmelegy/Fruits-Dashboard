import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/snack_bar_service.dart';
import '../../../../core/widgets/model_progress_hud.dart';
import '../manager/cubit/add_product_cubit.dart';
import 'add_products_view_body.dart';

class AddProductsViewBodyBlocConsumer extends StatelessWidget {
  const AddProductsViewBodyBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state is AddProductSuccess) {
          SnackBarService.showSuccessMessage('تم اضافة المنتج بنجاح');
        }
        if (state is AddProductFailure) {
          SnackBarService.showErrorMessage(state.errMessage);
        }
      },
      builder: (context, state) {
        return CustomModelProgressHud(
          isLoding: state is AddProductLoding,
          child: const AddProductsViewBody(),
        );
      },
    );
  }
}
