import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/wallet_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);

    return Scaffold(
      body: walletAsync.when(
        data: (wallet) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.primary,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  bottom: 40,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Available Balance', style: TextStyle(fontSize: 12, color: Colors.white70)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          wallet.balance.toStringAsFixed(3),
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(wallet.currency, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Pending: ${wallet.pending.toStringAsFixed(3)} ${wallet.currency}',
                        style: const TextStyle(fontSize: 11, color: Colors.white60)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white30),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {},
                            child: const Text('Request Payout', style: TextStyle(fontSize: 13)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white30),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {},
                            child: const Text('Statement', style: TextStyle(fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stats card
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _WalletStat(label: 'Total Earned', value: wallet.totalEarned.toStringAsFixed(0))),
                      Container(width: 0.5, height: 40, color: AppColors.border),
                      Expanded(child: _WalletStat(label: 'Paid Out', value: (wallet.totalEarned - wallet.balance).toStringAsFixed(0))),
                      Container(width: 0.5, height: 40, color: AppColors.border),
                      Expanded(child: _WalletStat(label: 'Available', value: wallet.balance.toStringAsFixed(0), isHighlight: true)),
                    ],
                  ),
                ),
              ),
            ),

            // Transactions
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Text('Recent Transactions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final txn = wallet.transactions[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: txn.isCredit ? AppColors.success : AppColors.danger,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(txn.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                              Text(txn.date.substring(0, 10), style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Text(
                          '${txn.isCredit ? '+' : '-'}${txn.amount.toStringAsFixed(3)} KD',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: txn.isCredit ? AppColors.success : AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: wallet.transactions.length,
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.danger))),
      ),
    );
  }
}

class _WalletStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;
  const _WalletStat({required this.label, required this.value, this.isHighlight = false});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: isHighlight ? AppColors.primary : null)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
    ],
  );
}
