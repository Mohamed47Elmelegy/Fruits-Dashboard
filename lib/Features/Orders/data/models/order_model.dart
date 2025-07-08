import 'package:furute_app_dashbord/Features/Orders/data/models/order_statues_history_model.dart';

import '../../domain/entity/order_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.uid,
    required super.products,
    required super.subtotal,
    required super.delivery,
    required super.total,
    required super.createdAt,
    required super.address,
    required super.status,
    super.trackingNumber,
    super.orderId,
    super.adminNotes,
    super.assignedAdminId,
    super.lastUpdated,
    super.statusHistory,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Use orderId as id if id is not present
    final orderId = json['orderId'] ?? '';
    final id = json['id'] ?? orderId;

    // Handle createdAt field - prioritize createdAtTimestamp, then handle createdAt
    String createdAtString;
    if (json['createdAtTimestamp'] != null) {
      // Use createdAtTimestamp if available (number) - this is the most reliable
      final timestamp = json['createdAtTimestamp'];
      if (timestamp is int) {
        createdAtString =
            DateTime.fromMillisecondsSinceEpoch(timestamp).toIso8601String();
      } else if (timestamp is Timestamp) {
        createdAtString = timestamp.toDate().toIso8601String();
      } else {
        createdAtString = DateTime.now().toIso8601String();
      }
    } else if (json['createdAt'] != null) {
      // Handle createdAt field - check if it's Timestamp or String
      final createdAt = json['createdAt'];
      if (createdAt is Timestamp) {
        // If it's a Firestore Timestamp, convert to string
        createdAtString = createdAt.toDate().toIso8601String();
      } else if (createdAt is String) {
        // If it's already a string, use it directly
        createdAtString = createdAt;
      } else {
        // Fallback to current time if createdAt is neither Timestamp nor String
        createdAtString = DateTime.now().toIso8601String();
      }
    } else {
      // Fallback to current time if no createdAt field exists
      createdAtString = DateTime.now().toIso8601String();
    }

    // Handle lastUpdated field - prioritize lastUpdated, then updatedAt
    DateTime? lastUpdatedDateTime;
    if (json['lastUpdated'] != null) {
      final lastUpdated = json['lastUpdated'];
      if (lastUpdated is Timestamp) {
        lastUpdatedDateTime = lastUpdated.toDate();
      } else if (lastUpdated is String) {
        try {
          lastUpdatedDateTime = DateTime.parse(lastUpdated);
        } catch (e) {
          // If parsing fails, set to null
          lastUpdatedDateTime = null;
        }
      }
    } else if (json['updatedAt'] != null) {
      // Fallback to updatedAt if lastUpdated is not available
      final updatedAt = json['updatedAt'];
      if (updatedAt is String) {
        try {
          lastUpdatedDateTime = DateTime.parse(updatedAt);
        } catch (e) {
          // If parsing fails, set to null
          lastUpdatedDateTime = null;
        }
      }
    }

    return OrderModel(
      id: id,
      uid: json['uid'] ?? '',
      products: List<Map<String, dynamic>>.from(json['products'] ?? []),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      delivery: (json['delivery'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      createdAt: createdAtString,
      address: json['address'],
      status: json['status'] ?? 'pending',
      trackingNumber: json['trackingNumber'],
      orderId: orderId,
      adminNotes: json['adminNotes'],
      assignedAdminId: json['assignedAdminId'],
      lastUpdated: lastUpdatedDateTime,
      statusHistory: json['statusHistory'] != null
          ? List<OrderStatusHistory>.from(json['statusHistory']
              .map((x) => OrderStatusHistoryModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'products': products,
      'subtotal': subtotal,
      'delivery': delivery,
      'total': total,
      'createdAt': createdAt,
      'address': address,
      'status': status,
      'trackingNumber': trackingNumber,
      'orderId': orderId,
      'adminNotes': adminNotes,
      'assignedAdminId': assignedAdminId,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'statusHistory': statusHistory.map((x) => x.toJson()).toList(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? uid,
    List<Map<String, dynamic>>? products,
    double? subtotal,
    double? delivery,
    double? total,
    String? createdAt,
    Map<String, dynamic>? address,
    String? status,
    String? trackingNumber,
    String? orderId,
    String? adminNotes,
    String? assignedAdminId,
    DateTime? lastUpdated,
    List<OrderStatusHistory>? statusHistory,
  }) {
    return OrderModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      products: products ?? this.products,
      subtotal: subtotal ?? this.subtotal,
      delivery: delivery ?? this.delivery,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      address: address ?? this.address,
      status: status ?? this.status,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      orderId: orderId ?? this.orderId,
      adminNotes: adminNotes ?? this.adminNotes,
      assignedAdminId: assignedAdminId ?? this.assignedAdminId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      statusHistory: statusHistory ?? this.statusHistory,
    );
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, statusHistory: $statusHistory)';
  }
}
