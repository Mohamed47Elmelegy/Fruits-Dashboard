import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/ansicolor.dart';
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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Load products when the page starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isInitialized) {
        _isInitialized = true;
        final cubit = context.read<EnhancedProductCubit>();
        cubit.getAllProducts();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we need to refresh products (e.g., when returning from add product page)
    final cubit = context.read<EnhancedProductCubit>();
    if (mounted && _isInitialized && cubit.state is EnhancedProductInitial) {
      // Only reload if we're in initial state (meaning we just returned from another page)
      // Add a small delay to avoid immediate reload
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          log(DebugConsoleMessages.info(
              '🔄 Consumer: Reloading products after returning to page'));
          cubit.getAllProducts();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EnhancedProductCubit, EnhancedProductState>(
      listener: (context, state) {
        if (state is EnhancedProductAdded) {
          SnackBarService.showSuccessMessage('تم إضافة المنتج بنجاح');
          // Reload products after adding to show the new product
          if (mounted) {
            log(DebugConsoleMessages.info(
                '🔄 Consumer: Reloading products after adding new product'));
            context.read<EnhancedProductCubit>().getAllProducts();
          }
        } else if (state is EnhancedProductUpdated) {
          SnackBarService.showSuccessMessage('تم تحديث المنتج بنجاح');
          // Reload products after updating to show the updated product
          if (mounted) {
            log(DebugConsoleMessages.info(
                '🔄 Consumer: Reloading products after updating product'));
            context.read<EnhancedProductCubit>().getAllProducts();
          }
        } else if (state is EnhancedProductDeleted) {
          SnackBarService.showSuccessMessage('تم حذف المنتج بنجاح');
          // Reload products after deleting to refresh the UI
          log(DebugConsoleMessages.info(
              '🔄 Consumer: Reloading products after deletion'));
          if (mounted) {
            context.read<EnhancedProductCubit>().getAllProducts();
          }
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
