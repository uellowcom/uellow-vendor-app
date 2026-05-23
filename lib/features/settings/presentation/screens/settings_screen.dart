import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance section
          _SectionHeader(title: isArabic ? 'المظهر' : 'Appearance'),
          _SettingCard(
            children: [
              // Dark mode toggle
              _SettingRow(
                icon: Icons.dark_mode_outlined,
                title: isArabic ? 'الوضع الداكن' : 'Dark Mode',
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  activeColor: AppColors.primary,
                  onChanged: (val) => ref.read(themeProvider.notifier).setTheme(
                    val ? ThemeMode.dark : ThemeMode.light,
                  ),
                ),
              ),
              const Divider(height: 0, thickness: 0.5),
              // System theme
              _SettingRow(
                icon: Icons.brightness_auto_outlined,
                title: isArabic ? 'تلقائي (نظام)' : 'Follow System',
                trailing: Switch(
                  value: themeMode == ThemeMode.system,
                  activeColor: AppColors.primary,
                  onChanged: (val) => ref.read(themeProvider.notifier).setTheme(
                    val ? ThemeMode.system : ThemeMode.light,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Language section
          _SectionHeader(title: isArabic ? 'اللغة' : 'Language'),
          _SettingCard(
            children: [
              _SettingRow(
                icon: Icons.language_outlined,
                title: 'English',
                trailing: Radio<Locale>(
                  value: const Locale('en'),
                  groupValue: locale,
                  activeColor: AppColors.primary,
                  onChanged: (v) => ref.read(localeProvider.notifier).setLocale(const Locale('en')),
                ),
              ),
              const Divider(height: 0, thickness: 0.5),
              _SettingRow(
                icon: Icons.translate_outlined,
                title: 'العربية',
                trailing: Radio<Locale>(
                  value: const Locale('ar'),
                  groupValue: locale,
                  activeColor: AppColors.primary,
                  onChanged: (v) => ref.read(localeProvider.notifier).setLocale(const Locale('ar')),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Account section
          _SectionHeader(title: isArabic ? 'الحساب' : 'Account'),
          _SettingCard(
            children: [
              _SettingRow(
                icon: Icons.person_outline,
                title: isArabic ? 'الملف الشخصي' : 'Profile',
                trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                onTap: () {},
              ),
              const Divider(height: 0, thickness: 0.5),
              _SettingRow(
                icon: Icons.notifications_outlined,
                title: isArabic ? 'الإشعارات' : 'Notifications',
                trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                onTap: () {},
              ),
              const Divider(height: 0, thickness: 0.5),
              _SettingRow(
                icon: Icons.logout,
                title: isArabic ? 'تسجيل الخروج' : 'Sign Out',
                iconColor: AppColors.danger,
                titleColor: AppColors.danger,
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(isArabic ? 'تسجيل الخروج' : 'Sign Out'),
                    content: Text(isArabic ? 'هل أنت متأكد؟' : 'Are you sure you want to sign out?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await ref.read(authProvider.notifier).logout();
                          if (context.mounted) context.go('/login');
                        },
                        child: const Text('Sign Out', style: TextStyle(color: AppColors.danger)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              'Uellow Vendor v1.0.0',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
  );
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border, width: 0.5),
    ),
    child: Column(children: children),
  );
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _SettingRow({required this.icon, required this.title, this.trailing, this.onTap, this.iconColor, this.titleColor});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor ?? AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: TextStyle(fontSize: 14, color: titleColor))),
          if (trailing != null) trailing!,
        ],
      ),
    ),
  );
}
