import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/order_entity.dart';

class OrderStatusHistoryModel extends OrderStatusHistory {
  OrderStatusHistoryModel({
    required super.status,
    required super.updatedBy,
    required super.updatedAt,
    super.notes,
  });

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    final updatedAt = json['updatedAt'];
    DateTime updatedAtDateTime;
    if (updatedAt is Timestamp) {
      // If it's a Firestore Timestamp, convert to DateTime
      updatedAtDateTime = updatedAt.toDate();
    } else if (updatedAt is String) {
      try {
        // If it's a string, try to parse it
        updatedAtDateTime = DateTime.parse(updatedAt);
      } catch (e) {
        // If parsing fails, use current time
        updatedAtDateTime = DateTime.now();
      }
    } else {
      // Fallback to current time if updatedAt is neither Timestamp nor String
      updatedAtDateTime = DateTime.now();
    }
    return OrderStatusHistoryModel(
      status: json['status'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      updatedAt: updatedAtDateTime,
      notes: json['notes'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
    };
  }
}
