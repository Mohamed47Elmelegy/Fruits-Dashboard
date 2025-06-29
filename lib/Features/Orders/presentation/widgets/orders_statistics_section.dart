import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/application_theme_manager.dart';
import '../manager/order_cubit.dart';
import 'stat_card_widget.dart';

class OrdersStatisticsSection extends StatefulWidget {
  const OrdersStatisticsSection({super.key});

  @override
  State<OrdersStatisticsSection> createState() =>
      _OrdersStatisticsSectionState();
}

class _OrdersStatisticsSectionState extends State<OrdersStatisticsSection> {
  @override
  void initState() {
    super.initState();
    // Load statistics when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderCubit>().loadOrderStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        Map<String, dynamic> statistics = {};

        if (state is OrderStatisticsLoaded) {
          statistics = state.statistics;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          color: ApplicationThemeManager.primaryColor.withOpacity(0.1),
          child: Row(
            children: [
              Expanded(
                child: StatCardWidget(
                  title: 'Total Orders',
                  value: '${statistics['totalOrders'] ?? 0}',
                  icon: Icons.shopping_cart,
                  color: ApplicationThemeManager.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCardWidget(
                  title: 'Pending',
                  value: '${statistics['pendingOrders'] ?? 0}',
                  icon: Icons.pending,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCardWidget(
                  title: 'Delivered',
                  value: '${statistics['deliveredOrders'] ?? 0}',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
