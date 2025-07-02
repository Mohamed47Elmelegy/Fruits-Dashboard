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
  DateFilter _selectedDateFilter = DateFilter.all;

  @override
  void initState() {
    super.initState();
    // تأكد من تحميل الطلبات عند فتح الصفحة لأول مرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderCubit>().loadAllOrders();
    });
  }

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

  void _onDateFilterChanged(DateFilter filter) {
    setState(() {
      _selectedDateFilter = filter;
    });
    context.read<OrderCubit>().setDateFilter(filter);
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
        title: const Text('إدارة الطلبات'),
        backgroundColor: ApplicationThemeManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<OrderCubit>().refreshAllData();
            },
            tooltip: 'تحديث البيانات',
          ),
        ],
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'إعادة المحاولة',
                  textColor: Colors.white,
                  onPressed: () {
                    if (_selectedStatus == 'all') {
                      context.read<OrderCubit>().loadAllOrders();
                    } else {
                      context
                          .read<OrderCubit>()
                          .loadOrdersByStatus(_selectedStatus);
                    }
                  },
                ),
              ),
            );
          } else if (state is OrderUpdating) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('جاري تحديث حالة الطلب...'),
                backgroundColor: Colors.blue,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              if (_selectedStatus == 'all') {
                await context.read<OrderCubit>().loadAllOrders();
              } else {
                await context
                    .read<OrderCubit>()
                    .loadOrdersByStatus(_selectedStatus);
              }
            },
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: OrdersStatisticsSection()),
                SliverToBoxAdapter(
                  child: OrdersSearchFilterSection(
                    selectedStatus: _selectedStatus,
                    searchController: _searchController,
                    onStatusChanged: _onStatusFilterChanged,
                    onSearchChanged: _onSearchChanged,
                    selectedDateFilter: _selectedDateFilter,
                    onDateFilterChanged: _onDateFilterChanged,
                  ),
                ),
                if (state is OrderLoaded)
                  OrdersListSection.sliver(
                      orders: state.orders, selectedStatus: _selectedStatus)
                else if (state is OrderFailure)
                  SliverToBoxAdapter(
                    child: Center(
                        child: Text(state.message,
                            style: const TextStyle(color: Colors.red))),
                  )
                else
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                            color: ApplicationThemeManager.primaryColor),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
