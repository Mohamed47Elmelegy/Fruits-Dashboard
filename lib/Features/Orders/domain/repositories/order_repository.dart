import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entity/order_entity.dart';

abstract class OrderRepository {
  /// Get all orders
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();

  /// Get orders by status
  Future<Either<Failure, List<OrderEntity>>> getOrdersByStatus(String status);

  /// Get order by ID
  Future<Either<Failure, OrderEntity?>> getOrderById(String orderId);

  /// Update order status
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    String newStatus, {
    String? notes,
  });

  /// Add admin notes to order
  Future<Either<Failure, void>> addOrderNotes(String orderId, String notes);

  /// Assign order to admin
  Future<Either<Failure, void>> assignOrderToAdmin(
      String orderId, String adminId);

  /// Get orders assigned to current admin
  Future<Either<Failure, List<OrderEntity>>> getAssignedOrders();

  /// Get order statistics
  Future<Either<Failure, Map<String, dynamic>>> getOrderStatistics();

  /// Get recent orders (last 7 days)
  Future<Either<Failure, List<OrderEntity>>> getRecentOrders();

  /// Search orders by customer name or order ID
  Future<Either<Failure, List<OrderEntity>>> searchOrders(String query);
}
