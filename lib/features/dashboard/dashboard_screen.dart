import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../../providers/auth_provider.dart';
import '../../providers/energy_provider.dart';
import '../../providers/analytics_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  final List<Animation<double>> _fadeAnimations = [];
  final List<Animation<Offset>> _slideAnimations = [];

  @override
  void initState() {
    super.initState();

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    for (int i = 0; i < 6; i++) {
      final start = i * 0.12;
      final end = (start + 0.4).clamp(0.0, 1.0);

      _fadeAnimations.add(
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );

      _slideAnimations.add(
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        ),
      );
    }

    _staggerController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EnergyProvider>().loadEnergyData();
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedItem(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final energy = context.watch<EnergyProvider>();
    final analytics = context.watch<AnalyticsProvider>();
    final isOwner = auth.user?.isSolarOwner ?? true;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppValues.paddingSm),

              // Greeting
              _buildAnimatedItem(
                0,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${auth.greeting} 👋',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          auth.user?.name ?? 'User',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    _LiveIndicator(),
                  ],
                ),
              ),

              // Role badge
              if (auth.user?.role != null) ...[
                const SizedBox(height: AppValues.paddingSm),
                _buildAnimatedItem(
                  0,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.paddingSm + 4,
                      vertical: AppValues.paddingXs + 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: isOwner
                          ? AppColors.solarGradient
                          : AppColors.onboardingGradient3,
                      borderRadius:
                          BorderRadius.circular(AppValues.radiusRound),
                    ),
                    child: Text(
                      isOwner ? '☀️ Solar Owner' : '⚡ Energy Buyer',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppValues.paddingLg),

              // Stat Cards
              if (energy.isLoading)
                const _ShimmerCards()
              else ...[
                // Row 1
                _buildAnimatedItem(
                  1,
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: isOwner
                              ? AppStrings.energyGenerated
                              : AppStrings.energyPurchased,
                          value: '${analytics.todayEnergy.toInt()}',
                          unit: AppStrings.kwh,
                          icon: isOwner
                              ? Icons.solar_power_rounded
                              : Icons.shopping_bag_rounded,
                          gradientColors: const [
                            Color(0xFF0FA958),
                            Color(0xFF14B8A6),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppValues.paddingSm),
                      Expanded(
                        child: _StatCard(
                          title: isOwner
                              ? AppStrings.revenueEarned
                              : AppStrings.moneySaved,
                          value:
                              '₹${analytics.todayRevenue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                          unit: 'Today',
                          icon: isOwner
                              ? Icons.account_balance_wallet_rounded
                              : Icons.savings_rounded,
                          gradientColors: const [
                            Color(0xFFF59E0B),
                            Color(0xFFF97316),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppValues.paddingSm),
                // Row 2
                _buildAnimatedItem(
                  2,
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: AppStrings.carbonSaved,
                          value: '${analytics.todayCarbonSaved.toInt()}',
                          unit: 'kg CO₂',
                          icon: Icons.eco_rounded,
                          gradientColors: const [
                            Color(0xFF22C55E),
                            Color(0xFF10B981),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppValues.paddingSm),
                      Expanded(
                        child: _StatCard(
                          title: isOwner
                              ? AppStrings.activeBuyers
                              : 'Sellers Nearby',
                          value: '${analytics.activeBuyers}',
                          unit: isOwner ? 'Active' : 'Available',
                          icon: isOwner
                              ? Icons.people_rounded
                              : Icons.location_on_rounded,
                          gradientColors: const [
                            Color(0xFF3B82F6),
                            Color(0xFF6366F1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppValues.paddingLg),

              // Energy Overview Card
              _buildAnimatedItem(
                3,
                _EnergyOverviewCard(isOwner: isOwner, energy: energy),
              ),

              const SizedBox(height: AppValues.paddingLg),

              // Carbon Impact Preview
              _buildAnimatedItem(
                4,
                _CarbonImpactPreview(analytics: analytics),
              ),

              const SizedBox(height: AppValues.paddingLg),

              // Quick Actions
              _buildAnimatedItem(
                5,
                _QuickActions(isOwner: isOwner),
              ),

              const SizedBox(height: AppValues.paddingXl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat Card ──
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final List<Color> gradientColors;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.paddingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppValues.radiusLg),
        border: Border.all(
          color: Theme.of(context).dividerTheme.color ?? AppColors.border,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(AppValues.radiusSm + 2),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: AppValues.paddingSm + 4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Live Indicator ──
class _LiveIndicator extends StatefulWidget {
  @override
  State<_LiveIndicator> createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<_LiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingSm,
        vertical: AppValues.paddingXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppValues.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withValues(
                    alpha: 0.5 + _pulseController.value * 0.5,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          Text(
            AppStrings.live,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer Cards ──
class _ShimmerCards extends StatelessWidget {
  const _ShimmerCards();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: ShimmerLoading(height: 130)),
            SizedBox(width: AppValues.paddingSm),
            Expanded(child: ShimmerLoading(height: 130)),
          ],
        ),
        SizedBox(height: AppValues.paddingSm),
        Row(
          children: [
            Expanded(child: ShimmerLoading(height: 130)),
            SizedBox(width: AppValues.paddingSm),
            Expanded(child: ShimmerLoading(height: 130)),
          ],
        ),
      ],
    );
  }
}

// ── Energy Overview Card ──
class _EnergyOverviewCard extends StatelessWidget {
  final bool isOwner;
  final dynamic energy;

  const _EnergyOverviewCard({required this.isOwner, required this.energy});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                isOwner ? 'Energy Production Today' : 'Energy Status',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.paddingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _OverviewStat(
                label: 'Produced',
                value: energy.energyData != null
                    ? '${energy.energyData!.produced.toStringAsFixed(1)}'
                    : '0',
                unit: 'kWh',
              ),
              _OverviewStat(
                label: 'Consumed',
                value: energy.energyData != null
                    ? '${energy.energyData!.consumed.toStringAsFixed(1)}'
                    : '0',
                unit: 'kWh',
              ),
              _OverviewStat(
                label: 'Surplus',
                value: energy.energyData != null
                    ? '${energy.energyData!.surplus.toStringAsFixed(1)}'
                    : '0',
                unit: 'kWh',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _OverviewStat({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(
          unit,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
        ),
      ],
    );
  }
}

// ── Carbon Impact Preview ──
class _CarbonImpactPreview extends StatelessWidget {
  final AnalyticsProvider analytics;

  const _CarbonImpactPreview({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.paddingLg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppValues.radiusLg),
        border: Border.all(
          color: Theme.of(context).dividerTheme.color ?? AppColors.border,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppValues.radiusSm),
                ),
                child: const Icon(Icons.eco_rounded,
                    color: AppColors.success, size: 20),
              ),
              const SizedBox(width: AppValues.paddingSm + 4),
              Text(
                AppStrings.carbonImpact,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppValues.paddingMd),
          Row(
            children: [
              Expanded(
                child: _ImpactItem(
                  icon: Icons.cloud_off_rounded,
                  value: '${analytics.totalCO2Saved.toInt()}',
                  label: 'kg CO₂ Saved',
                ),
              ),
              Expanded(
                child: _ImpactItem(
                  icon: Icons.park_rounded,
                  value: '${analytics.treesEquivalent.toInt()}',
                  label: 'Trees Planted',
                ),
              ),
              Expanded(
                child: _ImpactItem(
                  icon: Icons.directions_car_rounded,
                  value: '${(analytics.carKmAvoided / 1000).toStringAsFixed(1)}k',
                  label: 'km Avoided',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImpactItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ImpactItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.success, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

// ── Quick Actions ──
class _QuickActions extends StatelessWidget {
  final bool isOwner;

  const _QuickActions({required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppValues.paddingSm + 4),
        Row(
          children: [
            if (isOwner) ...[
              _ActionChip(
                icon: Icons.add_circle_rounded,
                label: 'Add Energy',
                color: AppColors.primary,
              ),
              const SizedBox(width: AppValues.paddingSm),
              _ActionChip(
                icon: Icons.history_rounded,
                label: 'History',
                color: AppColors.info,
              ),
            ] else ...[
              _ActionChip(
                icon: Icons.store_rounded,
                label: 'Browse Sellers',
                color: AppColors.primary,
              ),
              const SizedBox(width: AppValues.paddingSm),
              _ActionChip(
                icon: Icons.receipt_long_rounded,
                label: 'Purchases',
                color: AppColors.info,
              ),
            ],
            const SizedBox(width: AppValues.paddingSm),
            _ActionChip(
              icon: Icons.calculate_rounded,
              label: 'Calculator',
              color: AppColors.solarYellow,
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppValues.paddingSm + 4,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppValues.radiusMd),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
