import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entity/order_entity.dart';
import '../../domain/usecases/get_all_orders_usecase.dart';
import '../../domain/usecases/get_orders_by_status_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import '../../domain/usecases/search_orders_usecase.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final GetAllOrdersUseCase _getAllOrdersUseCase;
  final GetOrdersByStatusUseCase _getOrdersByStatusUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final SearchOrdersUseCase _searchOrdersUseCase;

  OrderCubit({
    required GetAllOrdersUseCase getAllOrdersUseCase,
    required GetOrdersByStatusUseCase getOrdersByStatusUseCase,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
    required SearchOrdersUseCase searchOrdersUseCase,
  })  : _getAllOrdersUseCase = getAllOrdersUseCase,
        _getOrdersByStatusUseCase = getOrdersByStatusUseCase,
        _updateOrderStatusUseCase = updateOrderStatusUseCase,
        _searchOrdersUseCase = searchOrdersUseCase,
        super(OrderInitial());

  /// Load all orders
  Future<void> loadAllOrders() async {
    emit(OrderLoading());
    final result = await _getAllOrdersUseCase();

    result.fold(
      (failure) {
        log('🍕failure: $failure');
        emit(OrderFailure(failure.message));
      },
      (orders) {
        emit(OrderLoaded(orders));
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
      },
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
    ]);
  }
}
