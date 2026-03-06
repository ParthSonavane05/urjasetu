import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import 'leaderboard_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final user = auth.user;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.paddingMd),
          child: Column(
            children: [
              const SizedBox(height: AppValues.paddingSm),

              // Profile header
              Container(
                padding: const EdgeInsets.all(AppValues.paddingLg),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppValues.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius:
                            BorderRadius.circular(AppValues.radiusLg),
                      ),
                      child: Center(
                        child: Text(
                          user?.name.isNotEmpty == true
                              ? user!.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppValues.paddingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'User',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color:
                                      Colors.white.withValues(alpha: 0.85),
                                ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                  AppValues.radiusRound),
                            ),
                            child: Text(
                              user?.roleDisplayName ?? 'User',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppValues.paddingMd),

              // User details card
              _InfoCard(
                children: [
                  _InfoRow(
                    icon: Icons.location_city_rounded,
                    label: 'City',
                    value: user?.city ?? 'Not set',
                  ),
                  if (user?.isSolarOwner == true) ...[
                    const Divider(height: 1),
                    _InfoRow(
                      icon: Icons.solar_power_rounded,
                      label: 'Solar Capacity',
                      value: '${user?.solarCapacity ?? 0} kW',
                    ),
                  ],
                  const Divider(height: 1),
                  _InfoRow(
                    icon: Icons.badge_rounded,
                    label: 'Role',
                    value: user?.roleDisplayName ?? 'Not set',
                  ),
                ],
              ),

              const SizedBox(height: AppValues.paddingMd),

              // Settings
              _InfoCard(
                children: [
                  // Dark Mode toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.paddingMd,
                      vertical: AppValues.paddingSm,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.solarYellow.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppValues.radiusSm),
                          ),
                          child: Icon(
                            theme.isDarkMode
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: AppColors.solarYellow,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppValues.paddingSm + 4),
                        Expanded(
                          child: Text(
                            AppStrings.darkMode,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Switch.adaptive(
                          value: theme.isDarkMode,
                          onChanged: (_) => theme.toggleTheme(),
                          activeTrackColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Notifications
                  _SettingsTile(
                    icon: Icons.notifications_rounded,
                    label: AppStrings.notifications,
                    color: AppColors.info,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  // Leaderboard
                  _SettingsTile(
                    icon: Icons.leaderboard_rounded,
                    label: AppStrings.leaderboard,
                    color: AppColors.solarYellow,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppValues.paddingMd),

              // Logout
              SizedBox(
                width: double.infinity,
                height: AppValues.buttonHeight,
                child: OutlinedButton.icon(
                  onPressed: () {
                    auth.logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                  label: Text(
                    AppStrings.logout,
                    style: TextStyle(color: AppColors.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppValues.radiusLg),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppValues.paddingXl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Info Card ──
class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppValues.radiusLg),
        border: Border.all(
          color: Theme.of(context).dividerTheme.color ?? AppColors.border,
          width: 0.5,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingMd,
        vertical: AppValues.paddingSm + 4,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppValues.radiusSm),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppValues.paddingSm + 4),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMd,
          vertical: AppValues.paddingSm + 4,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppValues.radiusSm),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppValues.paddingSm + 4),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
