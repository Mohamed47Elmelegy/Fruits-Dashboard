import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/order_management_service.dart';
import '../../domain/entity/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderManagementService _orderService;

  OrderRepositoryImpl(this._orderService);

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllOrders() async {
    try {
      final ordersData = await _orderService.getAllOrders();
      final orders =
          ordersData.map((data) => OrderModel.fromJson(data)).toList();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByStatus(
      String status) async {
    try {
      final ordersData = await _orderService.getOrdersByStatus(status);
      final orders =
          ordersData.map((data) => OrderModel.fromJson(data)).toList();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity?>> getOrderById(String orderId) async {
    try {
      final orderData = await _orderService.getOrderById(orderId);
      if (orderData == null) {
        return const Right(null);
      }
      final order = OrderModel.fromJson(orderData);
      return Right(order);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    String newStatus, {
    String? notes,
  }) async {
    try {
      await _orderService.updateOrderStatus(orderId, newStatus, notes: notes);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addOrderNotes(
      String orderId, String notes) async {
    try {
      await _orderService.addOrderNotes(orderId, notes);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> assignOrderToAdmin(
      String orderId, String adminId) async {
    try {
      await _orderService.assignOrderToAdmin(orderId, adminId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAssignedOrders() async {
    try {
      final ordersData = await _orderService.getAssignedOrders();
      final orders =
          ordersData.map((data) => OrderModel.fromJson(data)).toList();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrderStatistics() async {
    try {
      final statistics = await _orderService.getOrderStatistics();
      return Right(statistics);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getRecentOrders() async {
    try {
      final ordersData = await _orderService.getRecentOrders();
      final orders =
          ordersData.map((data) => OrderModel.fromJson(data)).toList();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> searchOrders(String query) async {
    try {
      final ordersData = await _orderService.searchOrders(query);
      final orders =
          ordersData.map((data) => OrderModel.fromJson(data)).toList();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
