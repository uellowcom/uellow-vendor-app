import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String? subtitle;
  final Color? subtitleColor;
  final IconData icon;
  final Color iconBgColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.subtitle,
    this.subtitleColor,
    required this.icon,
    required this.iconBgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 16, color: iconBgColor.withOpacity(3)),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor ?? AppColors.primary,
                ),
              ),
            ],
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
