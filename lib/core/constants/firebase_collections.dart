/// Shared Firebase collection names for both customer app and admin dashboard
class FirebaseCollections {
  // Product related collections
  static const String products = 'products';
  static const String productCategories = 'productCategories';
  static const String productImages = 'productImages';

  // Order related collections
  static const String orders = 'orders';
  static const String orderStatus = 'orderStatus';
  static const String orderTracking = 'orderTracking';

  // User related collections
  static const String users = 'users';
  static const String admins = 'admins';
  static const String userProfiles = 'userProfiles';

  // Address related collections
  static const String addresses = 'addresses';

  // Discount and promotion collections
  static const String discountCodes = 'discountCodes';
  static const String promotions = 'promotions';

  // Analytics and statistics
  static const String salesStats = 'salesStats';
  static const String productStats = 'productStats';
  static const String userStats = 'userStats';

  // System collections
  static const String appSettings = 'appSettings';
  static const String notifications = 'notifications';
  static const String systemLogs = 'systemLogs';
}

/// Shared Firebase storage paths
class FirebaseStoragePaths {
  static const String productImages = 'products/images';
  static const String userAvatars = 'users/avatars';
  static const String appAssets = 'app/assets';
  static const String tempUploads = 'temp/uploads';
}

/// Order status constants
class OrderStatus {
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String processing = 'processing';
  static const String shipped = 'shipped';
  static const String delivered = 'delivered';
  static const String cancelled = 'cancelled';
  static const String refunded = 'refunded';

  static List<String> getAllStatuses() {
    return [
      pending,
      confirmed,
      processing,
      shipped,
      delivered,
      cancelled,
      refunded
    ];
  }

  static String getDisplayName(String status) {
    switch (status) {
      case pending:
        return 'Pending';
      case confirmed:
        return 'Confirmed';
      case processing:
        return 'Processing';
      case shipped:
        return 'Shipped';
      case delivered:
        return 'Delivered';
      case cancelled:
        return 'Cancelled';
      case refunded:
        return 'Refunded';
      default:
        return 'Unknown';
    }
  }
}

/// User role constants
class UserRoles {
  static const String customer = 'customer';
  static const String admin = 'admin';
  static const String superAdmin = 'superAdmin';

  static List<String> getAllRoles() {
    return [customer, admin, superAdmin];
  }
}
