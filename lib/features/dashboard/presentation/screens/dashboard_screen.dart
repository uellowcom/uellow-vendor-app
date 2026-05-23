import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dashboardProvider);

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.refresh(dashboardProvider.future),
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              floating: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: async.when(
                data: (v) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_greeting(), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    Text(
                      v.storeNameAr.isNotEmpty ? v.storeNameAr : v.storeNameEn,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                loading: () => const LoadingShimmer(height: 36, width: 140),
                error: (_, __) => const Text('Uellow Vendor'),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary,
                    child: async.maybeWhen(
                      data: (v) => Text(
                        v.storeNameEn.isNotEmpty ? v.storeNameEn[0].toUpperCase() : 'V',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      orElse: () => const Text('V', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ),
                ),
              ],
            ),

            // Stats grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                delegate: SliverChildListDelegate(
                  async.when(
                    data: (v) => [
                      StatCard(
                        value: '${v.walletBalance.toStringAsFixed(3)} KD',
                        label: 'Wallet Balance',
                        icon: Icons.account_balance_wallet_outlined,
                        iconBgColor: AppColors.primaryLight,
                        onTap: () {},
                      ),
                      StatCard(
                        value: '${v.orderCount}',
                        label: 'Total Orders',
                        subtitle: 'All time',
                        subtitleColor: const Color(0xFF854F0B),
                        icon: Icons.shopping_bag_outlined,
                        iconBgColor: AppColors.warningBg,
                        onTap: () {},
                      ),
                      StatCard(
                        value: v.avgRating.toStringAsFixed(1),
                        label: 'Rating',
                        subtitle: '${v.tier} tier',
                        subtitleColor: AppColors.primary,
                        icon: Icons.star_outline,
                        iconBgColor: const Color(0xFFFBEAF0),
                        onTap: () {},
                      ),
                      StatCard(
                        value: '${v.followerCount}',
                        label: 'Followers',
                        icon: Icons.people_outline,
                        iconBgColor: AppColors.infoBg,
                        onTap: () {},
                      ),
                    ],
                    loading: () => List.generate(
                      4,
                      (_) => const LoadingShimmer(height: 100),
                    ),
                    error: (e, _) => [
                      Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.danger))),
                    ],
                  ),
                ),
              ),
            ),

            // Quick actions section
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    _QuickAction(icon: Icons.add_box_outlined, label: 'Add Product', color: AppColors.primaryLight, onTap: () {}),
                    const SizedBox(width: 10),
                    _QuickAction(icon: Icons.bolt_outlined, label: 'Flash Sale', color: const Color(0xFFFCEBEB), onTap: () {}),
                    const SizedBox(width: 10),
                    _QuickAction(icon: Icons.inventory_2_outlined, label: 'Restock', color: AppColors.infoBg, onTap: () {}),
                    const SizedBox(width: 10),
                    _QuickAction(icon: Icons.payment_outlined, label: 'Payout', color: AppColors.warningBg, onTap: () {}),
                  ],
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.borderDark
                  : AppColors.border,
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
