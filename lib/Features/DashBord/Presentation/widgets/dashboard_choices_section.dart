import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../../../../Features/AddProudcuts/presentation/manager/enhanced_product_cubit.dart';
import '../../../../Features/Orders/presentation/manager/order_cubit.dart';
import 'dashboard_choice_card.dart';

class DashboardChoicesSection extends StatelessWidget {
  const DashboardChoicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final padding = isSmallScreen ? 12.0 : 24.0;
        final cardSpacing = isSmallScreen ? 12.0 : 20.0;

        return Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Text(
                'إدارة النظام',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isSmallScreen ? 4 : 8),
              Text(
                'اختر القسم الذي تريد إدارته',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 16,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),

              // Choice Cards
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Products Management Card
                  BlocBuilder<EnhancedProductCubit, EnhancedProductState>(
                    builder: (context, productState) {
                      String productBadgeText = 'جديد';
                      if (productState is EnhancedProductsLoaded) {
                        productBadgeText =
                            '${productState.products.length} منتج';
                      }

                      return DashboardChoiceCard(
                        title: 'إدارة المنتجات',
                        subtitle: 'إضافة وتعديل وحذف المنتجات في المتجر',
                        icon: Icons.inventory_2,
                        color: const Color(0xFF4CAF50),
                        backgroundColor: const Color(0xFF4CAF50),
                        badgeText: productBadgeText,
                        onTap: () {
                          NavigationHelper.goToEnhancedProducts();
                        },
                      );
                    },
                  ),

                  SizedBox(height: cardSpacing),

                  // Orders Management Card
                  BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, orderState) {
                      String orderBadgeText = 'جديد';
                      if (orderState is OrderLoaded) {
                        // حساب الطلبات الجديدة (pending)
                        final newOrders = orderState.orders
                            .where((order) =>
                                order.status.toLowerCase() == 'pending')
                            .length;
                        orderBadgeText = newOrders > 0
                            ? '$newOrders طلب جديد'
                            : 'لا توجد طلبات جديدة';
                      }

                      return DashboardChoiceCard(
                        title: 'إدارة الطلبات',
                        subtitle: 'متابعة وتحديث حالة الطلبات',
                        icon: Icons.shopping_cart,
                        color: const Color(0xFF2196F3),
                        backgroundColor: const Color(0xFF2196F3),
                        badgeText: orderBadgeText,
                        onTap: () {
                          NavigationHelper.goToOrders();
                        },
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: isSmallScreen ? 20 : 32),

              // Quick Actions
              _buildQuickActions(context, isSmallScreen),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isSmallScreen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إجراءات سريعة',
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.analytics,
                title: 'التقارير',
                subtitle: 'عرض الإحصائيات',
                color: const Color(0xFF9C27B0),
                isSmallScreen: isSmallScreen,
                onTap: () {
                  // TODO: Navigate to reports
                },
              ),
            ),
            SizedBox(width: isSmallScreen ? 6 : 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.settings,
                title: 'الإعدادات',
                subtitle: 'تكوين النظام',
                color: const Color(0xFFFF9800),
                isSmallScreen: isSmallScreen,
                onTap: () {
                  // TODO: Navigate to settings
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isSmallScreen,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minHeight: isSmallScreen ? 80 : 100,
          maxHeight: isSmallScreen ? 120 : 140,
        ),
        padding: EdgeInsets.all(isSmallScreen ? 10 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: isSmallScreen ? 18 : 24,
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 12),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isSmallScreen ? 2 : 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isSmallScreen ? 9 : 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
