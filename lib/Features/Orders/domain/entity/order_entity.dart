class OrderEntity {
  final String id;
  final String uid;
  final List<Map<String, dynamic>> products;
  final double subtotal;
  final double delivery;
  final double total;
  final String createdAt;
  final Map<String, dynamic>? address;
  final String status;
  final String? trackingNumber;
  final String? orderId;
  final String? adminNotes;
  final String? assignedAdminId;
  final DateTime? lastUpdated;
  final List<OrderStatusHistory> statusHistory;

  OrderEntity({
    required this.id,
    required this.uid,
    required this.products,
    required this.subtotal,
    required this.delivery,
    required this.total,
    required this.createdAt,
    required this.address,
    required this.status,
    this.trackingNumber,
    this.orderId,
    this.adminNotes,
    this.assignedAdminId,
    this.lastUpdated,
    this.statusHistory = const [],
  });

  /// Get formatted order ID for display
  String get displayOrderId => orderId ?? id;

  /// Get formatted date for display
  String get displayDate => _formatDate(createdAt);

  /// Get customer name from address
  String get customerName => address?['fullName'] ?? 'Unknown Customer';

  /// Get customer email from address
  String get customerEmail => address?['email'] ?? '';

  /// Get delivery address
  String get deliveryAddress => address?['address'] ?? '';

  /// Get city
  String get city => address?['city'] ?? '';

  /// Get address details
  String get addressDetails => address?['details'] ?? '';

  /// Check if order is pending
  bool get isPending => status == 'pending';

  /// Check if order is confirmed
  bool get isConfirmed => status == 'confirmed';

  /// Check if order is processing
  bool get isProcessing => status == 'processing';

  /// Check if order is shipped
  bool get isShipped => status == 'shipped';

  /// Check if order is delivered
  bool get isDelivered => status == 'delivered';

  /// Check if order is cancelled
  bool get isCancelled => status == 'cancelled';

  /// Check if order is refunded
  bool get isRefunded => status == 'refunded';

  /// Get status display name
  String get statusDisplayName => _getStatusDisplayName(status);

  /// Get status color
  int get statusColor => _getStatusColor(status);

  /// Get status icon
  String get statusIcon => _getStatusIcon(status);

  /// احسب مجموع الطلبات
  static int totalOrders(List<OrderEntity> orders) => orders.length;

  /// احسب الإيرادات الكلية (تستثني الملغاة والمسترجعة)
  static double totalRevenue(List<OrderEntity> orders) => orders
      .where((order) => !order.isCancelled && !order.isRefunded)
      .fold(0, (sum, order) => sum + order.total);

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      case 'refunded':
        return 'Refunded';
      default:
        return 'Unknown';
    }
  }

  int _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 0xFFFF9800; // Orange
      case 'confirmed':
        return 0xFF2196F3; // Blue
      case 'processing':
        return 0xFF9C27B0; // Purple
      case 'shipped':
        return 0xFF4CAF50; // Green
      case 'delivered':
        return 0xFF4CAF50; // Green
      case 'cancelled':
        return 0xFFF44336; // Red
      case 'refunded':
        return 0xFF607D8B; // Blue Grey
      default:
        return 0xFF9E9E9E; // Grey
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'assets/images/vuesax/outline/timer.svg';
      case 'confirmed':
        return 'assets/images/vuesax/outline/tick_circle.svg';
      case 'processing':
        return 'assets/images/vuesax/outline/box.svg';
      case 'shipped':
        return 'assets/images/vuesax/outline/truck.svg';
      case 'delivered':
        return 'assets/images/vuesax/outline/tick_square.svg';
      case 'cancelled':
        return 'assets/images/vuesax/outline/close_circle.svg';
      case 'refunded':
        return 'assets/images/vuesax/outline/money_refund.svg';
      default:
        return 'assets/images/vuesax/outline/help.svg';
    }
  }
}

class OrderStatusHistory {
  final String status;
  final String updatedBy;
  final DateTime updatedAt;
  final String? notes;

  OrderStatusHistory({
    required this.status,
    required this.updatedBy,
    required this.updatedAt,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
    };
  }
}
