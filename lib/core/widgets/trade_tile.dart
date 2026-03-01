import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_values.dart';
import 'status_badge.dart';

class TradeTile extends StatelessWidget {
  final String seller;
  final String buyer;
  final String units;
  final String timestamp;
  final String status;

  const TradeTile({
    super.key,
    required this.seller,
    required this.buyer,
    required this.units,
    required this.timestamp,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppValues.paddingSm),
      padding: const EdgeInsets.all(AppValues.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppValues.radiusLg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppValues.paddingSm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppValues.radiusMd),
                ),
                child: const Icon(
                  Icons.swap_horiz_rounded,
                  color: AppColors.primary,
                  size: AppValues.iconMd,
                ),
              ),
              const SizedBox(width: AppValues.paddingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.titleSmall,
                        children: [
                          TextSpan(text: seller),
                          TextSpan(
                            text: '  →  ',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(text: buyer),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timestamp,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$units kWh',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  StatusBadge(status: status),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
