import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/application_theme_manager.dart';
import '../manager/order_cubit.dart';
import 'orders_statistics_section.dart';
import 'orders_search_filter_section.dart';
import 'orders_list_section.dart';

class OrdersViewBody extends StatefulWidget {
  const OrdersViewBody({super.key});

  @override
  State<OrdersViewBody> createState() => _OrdersViewBodyState();
}

class _OrdersViewBodyState extends State<OrdersViewBody> {
  String _selectedStatus = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onStatusFilterChanged(String status) {
    setState(() {
      _selectedStatus = status;
    });

    if (status == 'all') {
      context.read<OrderCubit>().loadAllOrders();
    } else {
      context.read<OrderCubit>().loadOrdersByStatus(status);
    }
  }

  void _onSearchChanged(String? query) {
    if (query != null && query.isNotEmpty) {
      context.read<OrderCubit>().searchOrders(query);
    } else {
      if (_selectedStatus == 'all') {
        context.read<OrderCubit>().loadAllOrders();
      } else {
        context.read<OrderCubit>().loadOrdersByStatus(_selectedStatus);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationThemeManager.backgroundColor,
      appBar: AppBar(
        title: const Text('Order Management'),
        backgroundColor: ApplicationThemeManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Statistics Section
              const OrdersStatisticsSection(),

              // Search and Filter Section
              OrdersSearchFilterSection(
                selectedStatus: _selectedStatus,
                searchController: _searchController,
                onStatusChanged: _onStatusFilterChanged,
                onSearchChanged: _onSearchChanged,
              ),

              // Orders List Section
              Expanded(
                child: OrdersListSection(
                  state: state,
                  selectedStatus: _selectedStatus,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
