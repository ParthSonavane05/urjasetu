import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_values.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = _getColors();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingSm,
        vertical: AppValues.paddingXs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppValues.radiusRound),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  (Color, Color) _getColors() {
    switch (status.toLowerCase()) {
      case 'completed':
        return (AppColors.success, AppColors.success.withValues(alpha: 0.1));
      case 'pending':
        return (AppColors.warning, AppColors.warning.withValues(alpha: 0.1));
      case 'failed':
        return (AppColors.error, AppColors.error.withValues(alpha: 0.1));
      default:
        return (AppColors.info, AppColors.info.withValues(alpha: 0.1));
    }
  }
}
