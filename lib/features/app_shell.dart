import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_values.dart';
import '../providers/navigation_provider.dart';
import '../providers/theme_provider.dart';
import 'dashboard/dashboard_screen.dart';
import 'marketplace/marketplace_screen.dart';
import 'analytics/analytics_screen.dart';
import 'profile/profile_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const _screens = [
    DashboardScreen(),
    MarketplaceScreen(),
    AnalyticsScreen(),
    ProfileScreen(),
  ];

  static const _navItems = [
    _NavData(Icons.home_rounded, AppStrings.home),
    _NavData(Icons.store_rounded, AppStrings.marketplace),
    _NavData(Icons.insights_rounded, AppStrings.analytics),
    _NavData(Icons.person_rounded, AppStrings.profile),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: AppValues.animNormal,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _screens[navProvider.currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.border,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: AppValues.bottomNavHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                return _NavItem(
                  icon: _navItems[index].icon,
                  label: _navItems[index].label,
                  isActive: navProvider.currentIndex == index,
                  onTap: () => navProvider.setIndex(index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavData {
  final IconData icon;
  final String label;
  const _NavData(this.icon, this.label);
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppValues.animFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMd,
          vertical: AppValues.paddingSm,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppValues.radiusMd),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textMuted,
              size: isActive ? 26 : 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive ? AppColors.primary : AppColors.textMuted,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
