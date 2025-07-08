import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/order_cubit.dart';
import '../widgets/orders_view_body.dart';
import '../../../../core/services/get_it_services.dart';
import '../../domain/usecases/get_all_orders_usecase.dart';
import '../../domain/usecases/get_orders_by_status_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import '../../domain/usecases/get_order_statistics_usecase.dart';
import '../../domain/usecases/search_orders_usecase.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit(
        getAllOrdersUseCase: getIt<GetAllOrdersUseCase>(),
        getOrdersByStatusUseCase: getIt<GetOrdersByStatusUseCase>(),
        updateOrderStatusUseCase: getIt<UpdateOrderStatusUseCase>(),
        searchOrdersUseCase: getIt<SearchOrdersUseCase>(),
      )..loadAllOrders(),
      child: const OrdersViewBody(),
    );
  }
}
