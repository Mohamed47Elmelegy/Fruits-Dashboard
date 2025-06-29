import 'package:flutter/material.dart';
import '../../../../core/widgets/section_container.dart';
import 'order_search_bar.dart';
import 'order_status_filter.dart';

class OrdersSearchFilterSection extends StatelessWidget {
  final String selectedStatus;
  final TextEditingController searchController;
  final Function(String) onStatusChanged;
  final Function(String?) onSearchChanged;

  const OrdersSearchFilterSection({
    super.key,
    required this.selectedStatus,
    required this.searchController,
    required this.onStatusChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        children: [
          // Search Bar
          OrderSearchBar(
            controller: searchController,
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 16),
          // Status Filter
          OrderStatusFilter(
            selectedStatus: selectedStatus,
            onStatusChanged: onStatusChanged,
          ),
        ],
      ),
    );
  }
}
