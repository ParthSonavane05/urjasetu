import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppValues.paddingMd),
        children: const [
          _NotificationTile(
            icon: Icons.flash_on_rounded,
            color: AppColors.primary,
            title: 'New Solar Energy Available',
            subtitle: 'Green Energy Society listed 860 kWh in Vadodara',
            time: '2 min ago',
            isUnread: true,
          ),
          _NotificationTile(
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
            title: 'Energy Purchase Confirmed',
            subtitle: 'You purchased 50 kWh from Raj Patel for ₹225',
            time: '1 hour ago',
            isUnread: true,
          ),
          _NotificationTile(
            icon: Icons.sell_rounded,
            color: AppColors.solarYellow,
            title: 'Energy Sale Confirmed',
            subtitle: 'Amit Verma purchased 30 kWh from you',
            time: '3 hours ago',
            isUnread: false,
          ),
          _NotificationTile(
            icon: Icons.trending_up_rounded,
            color: AppColors.info,
            title: 'Monthly Report Ready',
            subtitle: 'Your January energy report is ready to view',
            time: '1 day ago',
            isUnread: false,
          ),
          _NotificationTile(
            icon: Icons.eco_rounded,
            color: AppColors.success,
            title: 'Carbon Milestone Reached',
            subtitle: 'You have saved 1000 kg CO₂ — equivalent to 40 trees!',
            time: '2 days ago',
            isUnread: false,
          ),
          _NotificationTile(
            icon: Icons.star_rounded,
            color: AppColors.solarYellow,
            title: 'New Seller Rating',
            subtitle: 'You received a 5-star rating from a buyer',
            time: '3 days ago',
            isUnread: false,
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;

  const _NotificationTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppValues.paddingSm),
      padding: const EdgeInsets.all(AppValues.paddingMd),
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.primary.withValues(alpha: 0.04)
            : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppValues.radiusMd),
        border: Border.all(
          color: isUnread
              ? AppColors.primary.withValues(alpha: 0.2)
              : Theme.of(context).dividerTheme.color ?? AppColors.border,
          width: isUnread ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppValues.radiusSm + 2),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppValues.paddingSm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight:
                                  isUnread ? FontWeight.w700 : FontWeight.w600,
                            ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
