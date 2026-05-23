import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final String label;

  const StatusBadge({super.key, required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor) = switch (status) {
      'sale' || 'done' || 'delivered' || 'on_hand' =>
        (AppColors.successBg, AppColors.success),
      'draft' || 'pending' || 'continue_selling' =>
        (AppColors.warningBg, const Color(0xFF854F0B)),
      'cancel' || 'out_of_stock' =>
        (AppColors.dangerBg, AppColors.danger),
      _ => (AppColors.infoBg, AppColors.info),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
