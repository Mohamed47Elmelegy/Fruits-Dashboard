import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/ansicolor.dart';
import '../constants/firebase_collections.dart';

class OrderManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get all orders for admin dashboard
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.orders)
          .orderBy('createdAtTimestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      log(DebugConsoleMessages.error('Error getting all orders: $e'));
      rethrow;
    }
  }

  /// Get orders by status
  Future<List<Map<String, dynamic>>> getOrdersByStatus(String status) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.orders)
          .where('status', isEqualTo: status)
          .orderBy('createdAtTimestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      log(DebugConsoleMessages.error('Error getting orders by status: $e'));
      rethrow;
    }
  }

  /// Get order by ID
  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.orders)
          .doc(orderId)
          .get();

      if (doc.exists) {
        return {
          'id': doc.id,
          ...doc.data()!,
        };
      }
      return null;
    } catch (e) {
      log(DebugConsoleMessages.error('Error getting order by ID: $e'));
      rethrow;
    }
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String newStatus,
      {String? notes}) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      final order = await getOrderById(orderId);
      if (order == null) throw Exception('Order not found');

      // Create status history entry
      final statusHistory = order['statusHistory'] ?? [];
      statusHistory.add({
        'status': newStatus,
        'updatedBy': currentUser.uid,
        'updatedAt': DateTime.now().toIso8601String(),
        'notes': notes,
      });

      // Update order
      await _firestore
          .collection(FirebaseCollections.orders)
          .doc(orderId)
          .update({
        'status': newStatus,
        'lastUpdated': FieldValue.serverTimestamp(),
        'statusHistory': statusHistory,
        'assignedAdminId': currentUser.uid,
      });
    } catch (e) {
      log(DebugConsoleMessages.error('Error updating order status: $e'));
      rethrow;
    }
  }

  /// Add admin notes to order
  Future<void> addOrderNotes(String orderId, String notes) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      await _firestore
          .collection(FirebaseCollections.orders)
          .doc(orderId)
          .update({
        'adminNotes': notes,
        'lastUpdated': FieldValue.serverTimestamp(),
        'assignedAdminId': currentUser.uid,
      });
    } catch (e) {
      log(DebugConsoleMessages.error('Error adding order notes: $e'));
      rethrow;
    }
  }

  /// Assign order to admin
  Future<void> assignOrderToAdmin(String orderId, String adminId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.orders)
          .doc(orderId)
          .update({
        'assignedAdminId': adminId,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log(DebugConsoleMessages.error('Error assigning order to admin: $e'));
      rethrow;
    }
  }

  /// Get orders assigned to current admin
  Future<List<Map<String, dynamic>>> getAssignedOrders() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection(FirebaseCollections.orders)
          .where('assignedAdminId', isEqualTo: currentUser.uid)
          .orderBy('createdAtTimestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      log(DebugConsoleMessages.error('Error getting assigned orders: $e'));
      rethrow;
    }
  }

  /// Get order statistics
  Future<Map<String, dynamic>> getOrderStatistics() async {
    try {
      final allOrders = await getAllOrders();

      final totalOrders = allOrders.length;
      final pendingOrders = allOrders
          .where((order) => order['status'] == OrderStatus.pending)
          .length;
      final confirmedOrders = allOrders
          .where((order) => order['status'] == OrderStatus.confirmed)
          .length;
      final processingOrders = allOrders
          .where((order) => order['status'] == OrderStatus.processing)
          .length;
      final shippedOrders = allOrders
          .where((order) => order['status'] == OrderStatus.shipped)
          .length;
      final deliveredOrders = allOrders
          .where((order) => order['status'] == OrderStatus.delivered)
          .length;
      final cancelledOrders = allOrders
          .where((order) => order['status'] == OrderStatus.cancelled)
          .length;

      // Calculate total revenue
      final totalRevenue = allOrders
          .where((order) => order['status'] == OrderStatus.delivered)
          .fold<double>(0, (acc, order) => acc + (order['total'] ?? 0));

      return {
        'totalOrders': totalOrders,
        'pendingOrders': pendingOrders,
        'confirmedOrders': confirmedOrders,
        'processingOrders': processingOrders,
        'shippedOrders': shippedOrders,
        'deliveredOrders': deliveredOrders,
        'cancelledOrders': cancelledOrders,
        'totalRevenue': totalRevenue,
      };
    } catch (e) {
      log(DebugConsoleMessages.error('Error getting order statistics: $e'));
      rethrow;
    }
  }

  /// Get recent orders (last 7 days)
  Future<List<Map<String, dynamic>>> getRecentOrders() async {
    try {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

      final querySnapshot = await _firestore
          .collection(FirebaseCollections.orders)
          .where('createdAtTimestamp',
              isGreaterThan: sevenDaysAgo.millisecondsSinceEpoch)
          .orderBy('createdAtTimestamp', descending: true)
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      log(DebugConsoleMessages.error('Error getting recent orders: $e'));
      rethrow;
    }
  }

  /// Search orders by customer name or order ID
  Future<List<Map<String, dynamic>>> searchOrders(String query) async {
    try {
      final allOrders = await getAllOrders();

      return allOrders.where((order) {
        final customerName =
            order['address']?['fullName']?.toString().toLowerCase() ?? '';
        final orderId = order['orderId']?.toString().toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();

        return customerName.contains(searchQuery) ||
            orderId.contains(searchQuery);
      }).toList();
    } catch (e) {
      log(DebugConsoleMessages.error('Error searching orders: $e'));
      rethrow;
    }
  }

  /// Cancel order and remove tracking number
  Future<void> cancelOrder(String orderId, {String? notes}) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      final order = await getOrderById(orderId);
      if (order == null) throw Exception('Order not found');

      // Create status history entry
      final statusHistory = order['statusHistory'] ?? [];
      statusHistory.add({
        'status': OrderStatus.cancelled,
        'updatedBy': currentUser.uid,
        'updatedAt': DateTime.now().toIso8601String(),
        'notes': notes ?? 'Order cancelled by admin',
      });

      // Update order - remove tracking number when cancelled
      await _firestore
          .collection(FirebaseCollections.orders)
          .doc(orderId)
          .update({
        'status': OrderStatus.cancelled,
        'trackingNumber': null, // Remove tracking number
        'lastUpdated': FieldValue.serverTimestamp(),
        'statusHistory': statusHistory,
        'assignedAdminId': currentUser.uid,
        'cancelledAt': FieldValue.serverTimestamp(),
        'cancelledBy': currentUser.uid,
      });
    } catch (e) {
      log(DebugConsoleMessages.error('Error cancelling order: $e'));
      rethrow;
    }
  }
}
