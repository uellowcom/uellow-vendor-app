import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: UellowVendorApp()));
}

class UellowVendorApp extends ConsumerStatefulWidget {
  const UellowVendorApp({super.key});

  @override
  ConsumerState<UellowVendorApp> createState() => _UellowVendorAppState();
}

class _UellowVendorAppState extends ConsumerState<UellowVendorApp> {
  @override
  void initState() {
    super.initState();
    // Initialize stored settings
    Future.microtask(() async {
      await ref.read(themeProvider.notifier).init();
      await ref.read(localeProvider.notifier).init();
      await ref.read(authProvider.notifier).checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Uellow Vendor',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
