import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_values.dart';

class EnergyCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final List<Color>? gradientColors;

  const EnergyCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? [AppColors.primary, AppColors.secondary];

    return Container(
      padding: const EdgeInsets.all(AppValues.paddingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppValues.radiusXl),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Container(
                padding: const EdgeInsets.all(AppValues.paddingSm),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppValues.radiusMd),
                ),
                child: Icon(icon, color: Colors.white, size: AppValues.iconMd),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
