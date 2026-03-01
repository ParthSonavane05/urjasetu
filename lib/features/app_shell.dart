import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_values.dart';
import '../providers/navigation_provider.dart';
import 'dashboard/dashboard_screen.dart';
import 'trades/trades_screen.dart';
import 'policy/policy_screen.dart';
import 'wallet/wallet_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const _screens = [
    DashboardScreen(),
    TradesScreen(),
    PolicyScreen(),
    WalletScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();

    return Scaffold(
      body: AnimatedSwitcher(
        duration: AppValues.animNormal,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _screens[navProvider.currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: AppValues.bottomNavHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  index: 0,
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isActive: navProvider.currentIndex == 0,
                  onTap: () => navProvider.setIndex(0),
                ),
                _NavItem(
                  index: 1,
                  icon: Icons.swap_horiz_rounded,
                  label: 'Trades',
                  isActive: navProvider.currentIndex == 1,
                  onTap: () => navProvider.setIndex(1),
                ),
                _NavItem(
                  index: 2,
                  icon: Icons.tune_rounded,
                  label: 'Policy',
                  isActive: navProvider.currentIndex == 2,
                  onTap: () => navProvider.setIndex(2),
                ),
                _NavItem(
                  index: 3,
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Wallet',
                  isActive: navProvider.currentIndex == 3,
                  onTap: () => navProvider.setIndex(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
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
                    color:
                        isActive ? AppColors.primary : AppColors.textMuted,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
