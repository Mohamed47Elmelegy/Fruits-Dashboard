import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/factories/cubit_factory.dart';
import '../../../../Features/AddProudcuts/presentation/manager/enhanced_product_cubit.dart';
import '../../../../Features/Orders/presentation/manager/order_cubit.dart';
import '../widgets/dashbord_view_body.dart';

class DashbordView extends StatelessWidget {
  const DashbordView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // EnhancedProductCubit - لإدارة المنتجات
        BlocProvider<EnhancedProductCubit>(
          create: (context) {
            final cubit = CubitFactory.createEnhancedProductCubit();
            // تحميل المنتجات عند بدء التطبيق
            cubit.getAllProducts();
            return cubit;
          },
        ),
        // OrderCubit - لإدارة الطلبات
        BlocProvider<OrderCubit>(
          create: (context) {
            final cubit = CubitFactory.createOrderCubit();
            // تحميل الطلبات عند بدء التطبيق
            cubit.loadAllOrders();
            return cubit;
          },
        ),
      ],
      child: const DashbordViewBody(),
    );
  }
}
