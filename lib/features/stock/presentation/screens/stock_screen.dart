import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/stock_model.dart';
import '../providers/stock_provider.dart';

class StockScreen extends ConsumerWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockAsync = ref.watch(stockProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FBU Stock'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Restock', style: TextStyle(fontSize: 13)),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: stockAsync.when(
        data: (products) => products.isEmpty
            ? const Center(child: Text('No products in stock', style: TextStyle(color: AppColors.textSecondary)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (_, i) => _StockCard(product: products[i]),
              ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Error loading stock', style: TextStyle(color: AppColors.danger)),
              TextButton(onPressed: () => ref.invalidate(stockProvider), child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  final StockModel product;
  const _StockCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusBg, statusText, progressColor, progress) = switch (product.fbuState) {
      'on_hand' => ('On Hand', AppColors.successBg, AppColors.success, AppColors.primary, 0.7),
      'continue_selling' => ('Continue Selling', AppColors.warningBg, const Color(0xFF854F0B), AppColors.warning, 0.3),
      _ => ('Out of Stock', AppColors.dangerBg, AppColors.danger, AppColors.danger, 0.0),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.borderDark
              : AppColors.border,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(statusLabel, style: TextStyle(fontSize: 10, color: statusText, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _StockStat(label: 'In FBU', value: '${product.vendorQty.toInt()}', color: AppColors.primary),
                const SizedBox(width: 16),
                _StockStat(label: 'Vendor', value: '${product.vendorQty.toInt()}', color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation(progressColor),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StockStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
      children: [
        TextSpan(text: '$label: '),
        TextSpan(text: value, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      ],
    ),
  );
}
