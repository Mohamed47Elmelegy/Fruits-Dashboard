import 'package:flutter/material.dart';
import '../../../../core/widgets/section_container.dart';
import '../manager/order_cubit.dart';
import 'order_search_bar.dart';
import 'order_status_filter.dart';

class OrdersSearchFilterSection extends StatelessWidget {
  final String selectedStatus;
  final TextEditingController searchController;
  final Function(String) onStatusChanged;
  final Function(String?) onSearchChanged;
  final DateFilter selectedDateFilter;
  final Function(DateFilter) onDateFilterChanged;

  const OrdersSearchFilterSection({
    super.key,
    required this.selectedStatus,
    required this.searchController,
    required this.onStatusChanged,
    required this.onSearchChanged,
    required this.selectedDateFilter,
    required this.onDateFilterChanged,
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
          const SizedBox(height: 16),
          // Date Filter Chips
          _buildDateFilterChips(),
        ],
      ),
    );
  }

  Widget _buildDateFilterChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildChip('الكل', DateFilter.all),
        const SizedBox(width: 8),
        _buildChip('اليوم', DateFilter.today),
        const SizedBox(width: 8),
        _buildChip('هذا الأسبوع', DateFilter.thisWeek),
        const SizedBox(width: 8),
        _buildChip('هذا الشهر', DateFilter.thisMonth),
      ],
    );
  }

  Widget _buildChip(String label, DateFilter filter) {
    final isSelected = selectedDateFilter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onDateFilterChanged(filter),
      selectedColor: Colors.green,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.grey[200],
      side: BorderSide(
        color: isSelected ? Colors.green : Colors.grey[300]!,
      ),
    );
  }
}
