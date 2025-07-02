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
          color: ApplicationThemeManager.primaryColor.withValues(alpha: 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              const Text(
                'إحصائيات الطلبات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ApplicationThemeManager.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // Statistics Cards
              Row(
                children: [
                  Expanded(
                    child: StatCardWidget(
                      title: 'إجمالي الطلبات',
                      value: '${statistics['totalOrders'] ?? 0}',
                      icon: Icons.shopping_cart,
                      color: ApplicationThemeManager.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCardWidget(
                      title: 'في الانتظار',
                      value: '${statistics['pendingOrders'] ?? 0}',
                      icon: Icons.pending,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCardWidget(
                      title: 'تم التوصيل',
                      value: '${statistics['deliveredOrders'] ?? 0}',
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Second Row
              Row(
                children: [
                  Expanded(
                    child: StatCardWidget(
                      title: 'قيد المعالجة',
                      value: '${statistics['processingOrders'] ?? 0}',
                      icon: Icons.inventory_2,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCardWidget(
                      title: 'تم الشحن',
                      value: '${statistics['shippedOrders'] ?? 0}',
                      icon: Icons.local_shipping,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCardWidget(
                      title: 'الإيرادات',
                      value:
                          '${(statistics['totalRevenue'] ?? 0).toStringAsFixed(0)} ج.م',
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
