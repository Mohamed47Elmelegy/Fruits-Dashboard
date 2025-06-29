# Orders Management Feature

This feature provides comprehensive order management capabilities for the admin dashboard, allowing administrators to view, filter, search, and update order statuses.

## Features

✅ **View All Orders** - Display all orders with pagination and sorting
✅ **Filter by Status** - Filter orders by status (pending, confirmed, processing, shipped, delivered, cancelled, refunded)
✅ **Search Orders** - Search by customer name or order ID
✅ **Update Order Status** - Change order status with optional admin notes
✅ **Order Statistics** - View order statistics and analytics
✅ **Order Details** - View detailed order information including items, customer info, and address

## Architecture

Following Clean Architecture principles with organized custom widgets:

### Domain Layer
- **Entities**: `OrderEntity`, `OrderStatusHistory`
- **Repository Interface**: `OrderRepository`
- **Use Cases**: 
  - `GetAllOrdersUseCase`
  - `GetOrdersByStatusUseCase`
  - `UpdateOrderStatusUseCase`
  - `GetOrderStatisticsUseCase`
  - `SearchOrdersUseCase`

### Data Layer
- **Models**: `OrderModel`, `OrderStatusHistoryModel`
- **Repository Implementation**: `OrderRepositoryImpl`
- **Data Source**: Uses existing `OrderManagementService`

### Presentation Layer
- **State Management**: `OrderCubit` with BLoC pattern
- **Views**: 
  - `OrdersView` - Main view with provider and dependency injection
  - `OrdersViewBody` - Body with consumer and state management
- **Custom Widgets**:
  - `OrdersStatisticsSection` - Statistics dashboard section
  - `OrdersSearchFilterSection` - Search and filter controls
  - `OrdersListSection` - Orders list with different states
  - `OrderListItem` - Individual order display
  - `OrderStatusFilter` - Status filter chips
  - `OrderSearchBar` - Search functionality
  - `OrderStatusUpdateDialog` - Status update dialog
  - `StatCardWidget` - Statistics card component

## File Structure

```
lib/Features/Orders/
├── domain/
│   ├── entity/
│   │   └── order_entity.dart
│   ├── repositories/
│   │   └── order_repository.dart
│   └── usecases/
│       ├── get_all_orders_usecase.dart
│       ├── get_orders_by_status_usecase.dart
│       ├── update_order_status_usecase.dart
│       ├── get_order_statistics_usecase.dart
│       └── search_orders_usecase.dart
├── data/
│   ├── models/
│   │   └── order_model.dart
│   └── repositories/
│       └── order_repository_impl.dart
└── presentation/
    ├── manager/
    │   ├── order_cubit.dart
    │   └── order_state.dart
    ├── view/
    │   └── orders_view.dart
    └── widgets/
        ├── orders_view_body.dart
        ├── orders_statistics_section.dart
        ├── orders_search_filter_section.dart
        ├── orders_list_section.dart
        ├── order_list_item.dart
        ├── order_status_filter.dart
        ├── order_search_bar.dart
        ├── order_status_update_dialog.dart
        └── stat_card_widget.dart
```

## Data Models

### OrderEntity
```dart
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
}
```

### Order Statuses
- `pending` - Order is pending review
- `confirmed` - Order has been confirmed
- `processing` - Order is being processed
- `shipped` - Order has been shipped
- `delivered` - Order has been delivered
- `cancelled` - Order has been cancelled
- `refunded` - Order has been refunded

## Usage

### Basic Usage
```dart
// Navigate to orders view
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const OrdersView()),
);
```

### Filtering Orders
```dart
// Filter by status
context.read<OrderCubit>().loadOrdersByStatus('pending');

// Search orders
context.read<OrderCubit>().searchOrders('customer name');
```

### Updating Order Status
```dart
// Update order status
context.read<OrderCubit>().updateOrderStatus(
  orderId,
  'shipped',
  notes: 'Order shipped via express delivery',
);
```

## Custom Widgets Organization

### Main View Structure
- `OrdersView` - Contains BlocProvider and dependency injection
- `OrdersViewBody` - Contains BlocConsumer and main layout

### Section Widgets
- `OrdersStatisticsSection` - Displays order statistics with BlocBuilder
- `OrdersSearchFilterSection` - Contains search and filter controls
- `OrdersListSection` - Handles different list states (loading, loaded, error, empty)

### Component Widgets
- `OrderListItem` - Individual order display with actions
- `OrderStatusFilter` - Horizontal filter chips
- `OrderSearchBar` - Search input field
- `OrderStatusUpdateDialog` - Modal for status updates
- `StatCardWidget` - Reusable statistics card

## Integration with Fruit App

This feature integrates seamlessly with the customer-facing Fruit App:

1. **Data Consistency**: Uses the same Firebase collections and data structure
2. **Real-time Updates**: Changes made in admin dashboard reflect in customer app
3. **Status Tracking**: Order status updates are tracked with history
4. **Customer Information**: Displays customer details from the order address

## Firebase Collections Used

- `orders` - Main orders collection
- `users` - User information
- `products` - Product details for order items

## Error Handling

- Network errors are handled gracefully with retry options
- Loading states are displayed during operations
- Error messages are shown via snackbars
- Empty states are displayed when no orders match criteria

## Future Enhancements

- [ ] Order details page with full order information
- [ ] Bulk order status updates
- [ ] Order export functionality
- [ ] Advanced filtering options
- [ ] Order analytics and reporting
- [ ] Email notifications for status changes 