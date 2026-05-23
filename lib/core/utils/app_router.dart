import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/main_shell.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/stock/presentation/screens/stock_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: authState.isAuthenticated ? '/dashboard' : '/login',
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final isLoginRoute = state.uri.toString() == '/login';
      if (!isAuthenticated && !isLoginRoute) return '/login';
      if (isAuthenticated && isLoginRoute) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/orders', builder: (_, __) => const OrdersScreen()),
          GoRoute(path: '/stock', builder: (_, __) => const StockScreen()),
          GoRoute(path: '/wallet', builder: (_, __) => const WalletScreen()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),
    ],
  );
});
