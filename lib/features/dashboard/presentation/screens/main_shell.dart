import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = ['/dashboard', '/orders', '/stock', '/wallet', '/settings'];

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    final i = _tabs.indexWhere((t) => loc.startsWith(t));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: idx,
          onTap: (i) => context.go(_tabs[i]),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), activeIcon: Icon(Icons.list_alt), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Stock'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'More'),
          ],
        ),
      ),
    );
  }
}
