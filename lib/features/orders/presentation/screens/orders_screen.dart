import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../../shared/models/order_model.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  static const _filters = ['all', 'sale', 'done', 'cancel'];
  static const _filterLabels = ['All', 'Pending', 'Delivered', 'Cancelled'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(orderFilterProvider);
    final ordersAsync = ref.watch(ordersProvider(filter));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(icon: const Icon(Icons.search_outlined), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final selected = filter == _filters[i];
                return GestureDetector(
                  onTap: () => ref.read(orderFilterProvider.notifier).state = _filters[i],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      _filterLabels[i],
                      style: TextStyle(
                        fontSize: 12,
                        color: selected ? Colors.white : AppColors.textSecondary,
                        fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: ordersAsync.when(
        data: (orders) => orders.isEmpty
            ? const Center(child: Text('No orders yet', style: TextStyle(color: AppColors.textSecondary)))
            : ListView.separated(
                itemCount: orders.length,
                separatorBuilder: (_, __) => Divider(
                  height: 0,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.borderDark
                      : AppColors.border,
                ),
                itemBuilder: (_, i) => _OrderTile(order: orders[i]),
              ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Error loading orders', style: TextStyle(color: AppColors.danger)),
              const SizedBox(height: 8),
              TextButton(onPressed: () => ref.invalidate(ordersProvider), child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderModel order;
  const _OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 20),
      ),
      title: Text(order.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(order.partner, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text(order.date.substring(0, 10), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${order.amount.toStringAsFixed(3)} KD',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          StatusBadge(
            status: order.state,
            label: switch (order.state) {
              'sale' => 'Pending',
              'done' => 'Delivered',
              'cancel' => 'Cancelled',
              _ => order.state,
            },
          ),
        ],
      ),
      isThreeLine: true,
    );
  }
}
