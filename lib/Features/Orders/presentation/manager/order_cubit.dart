import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entity/order_entity.dart';
import '../../domain/usecases/get_all_orders_usecase.dart';
import '../../domain/usecases/get_orders_by_status_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import '../../domain/usecases/get_order_statistics_usecase.dart';
import '../../domain/usecases/search_orders_usecase.dart';

part 'order_state.dart';

enum DateFilter {
  all,
  today,
  thisWeek,
  thisMonth,
}

class OrderCubit extends Cubit<OrderState> {
  final GetAllOrdersUseCase _getAllOrdersUseCase;
  final GetOrdersByStatusUseCase _getOrdersByStatusUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final GetOrderStatisticsUseCase _getOrderStatisticsUseCase;
  final SearchOrdersUseCase _searchOrdersUseCase;
  DateFilter _currentDateFilter = DateFilter.all;

  OrderCubit({
    required GetAllOrdersUseCase getAllOrdersUseCase,
    required GetOrdersByStatusUseCase getOrdersByStatusUseCase,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
    required GetOrderStatisticsUseCase getOrderStatisticsUseCase,
    required SearchOrdersUseCase searchOrdersUseCase,
  })  : _getAllOrdersUseCase = getAllOrdersUseCase,
        _getOrdersByStatusUseCase = getOrdersByStatusUseCase,
        _updateOrderStatusUseCase = updateOrderStatusUseCase,
        _getOrderStatisticsUseCase = getOrderStatisticsUseCase,
        _searchOrdersUseCase = searchOrdersUseCase,
        super(OrderInitial());

  /// Load all orders
  Future<void> loadAllOrders() async {
    emit(OrderLoading());
    final result = await _getAllOrdersUseCase();
    result.fold(
      (failure) => emit(OrderFailure(failure.message)),
      (orders) {
        final sorted = _sortOrdersByDate(orders);
        final filtered = _filterOrdersByDate(sorted, _currentDateFilter);
        emit(OrderLoaded(filtered));
      },
    );
  }

  /// Load orders by status
  Future<void> loadOrdersByStatus(String status) async {
    emit(OrderLoading());

    final result = await _getOrdersByStatusUseCase(status);

    result.fold(
      (failure) => emit(OrderFailure(failure.message)),
      (orders) => emit(OrderLoaded(orders)),
    );
  }

  /// Update order status
  Future<void> updateOrderStatus(
    String orderId,
    String newStatus, {
    String? notes,
  }) async {
    emit(OrderUpdating());

    final result =
        await _updateOrderStatusUseCase(orderId, newStatus, notes: notes);

    result.fold(
      (failure) => emit(OrderFailure(failure.message)),
      (_) {
        // Reload orders and statistics after successful update
        loadAllOrders();
        loadOrderStatistics();
      },
    );
  }

  /// Load order statistics
  Future<void> loadOrderStatistics() async {
    emit(OrderStatisticsLoading());

    final result = await _getOrderStatisticsUseCase();

    result.fold(
      (failure) => emit(OrderStatisticsFailure(failure.message)),
      (statistics) => emit(OrderStatisticsLoaded(statistics)),
    );
  }

  /// Search orders
  Future<void> searchOrders(String query) async {
    if (query.isEmpty) {
      loadAllOrders();
      return;
    }

    emit(OrderLoading());

    final result = await _searchOrdersUseCase(query);

    result.fold(
      (failure) => emit(OrderFailure(failure.message)),
      (orders) => emit(OrderLoaded(orders)),
    );
  }

  /// Filter orders by status
  void filterOrdersByStatus(String status) {
    if (state is OrderLoaded) {
      final currentState = state as OrderLoaded;
      final filteredOrders = currentState.orders
          .where((order) => order.status.toLowerCase() == status.toLowerCase())
          .toList();
      emit(OrderLoaded(filteredOrders));
    }
  }

  /// Clear search and reload all orders
  void clearSearch() {
    loadAllOrders();
  }

  /// Refresh all data (orders and statistics)
  Future<void> refreshAllData() async {
    await Future.wait([
      loadAllOrders(),
      loadOrderStatistics(),
    ]);
  }

  void setDateFilter(DateFilter filter) {
    _currentDateFilter = filter;
    if (state is OrderLoaded) {
      final orders = (state as OrderLoaded).orders;
      final filtered = _filterOrdersByDate(_sortOrdersByDate(orders), filter);
      emit(OrderLoaded(filtered));
    } else {
      loadAllOrders();
    }
  }

  List<OrderEntity> _sortOrdersByDate(List<OrderEntity> orders) {
    return List<OrderEntity>.from(orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<OrderEntity> _filterOrdersByDate(
      List<OrderEntity> orders, DateFilter filter) {
    final now = DateTime.now();
    switch (filter) {
      case DateFilter.today:
        return orders.where((order) {
          final date = DateTime.parse(order.createdAt);
          return date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        }).toList();
      case DateFilter.thisWeek:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return orders.where((order) {
          final date = DateTime.parse(order.createdAt);
          return date.isAfter(weekStart.subtract(const Duration(days: 1)));
        }).toList();
      case DateFilter.thisMonth:
        return orders.where((order) {
          final date = DateTime.parse(order.createdAt);
          return date.year == now.year && date.month == now.month;
        }).toList();
      case DateFilter.all:
      default:
        return orders;
    }
  }
}
