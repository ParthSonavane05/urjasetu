import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../core/widgets/energy_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/trade_tile.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../../providers/auth_provider.dart';
import '../../providers/energy_provider.dart';
import '../../providers/trade_provider.dart';
import '../../providers/policy_provider.dart';

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

    // 5 staggered items: greeting, card1, card2, card3, recent trades
    for (int i = 0; i < 5; i++) {
      final start = i * 0.15;
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

    // Load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EnergyProvider>().loadEnergyData();
      context.read<TradeProvider>().loadTrades();
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
    final trades = context.watch<TradeProvider>();
    final policy = context.watch<PolicyProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppValues.paddingSm),

              // Greeting + Live Indicator
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _LiveIndicator(),
                        const SizedBox(height: 6),
                        if (policy.policy.autoTrading) _AutoTradeBadge(),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppValues.paddingLg),

              // Energy Cards
              if (energy.isLoading) ...[
                const ShimmerLoading(height: 140),
                const SizedBox(height: AppValues.paddingSm),
                const ShimmerLoading(height: 140),
                const SizedBox(height: AppValues.paddingSm),
                const ShimmerLoading(height: 140),
              ] else if (energy.energyData != null) ...[
                _buildAnimatedItem(
                  1,
                  SizedBox(
                    height: 150,
                    child: EnergyCard(
                      title: AppStrings.energyProduced,
                      value: energy.energyData!.produced.toStringAsFixed(1),
                      unit: AppStrings.kwh,
                      icon: Icons.solar_power_rounded,
                      gradientColors: const [
                        Color(0xFF0FA958),
                        Color(0xFF14B8A6),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppValues.paddingSm),
                _buildAnimatedItem(
                  2,
                  SizedBox(
                    height: 150,
                    child: EnergyCard(
                      title: AppStrings.energyConsumed,
                      value: energy.energyData!.consumed.toStringAsFixed(1),
                      unit: AppStrings.kwh,
                      icon: Icons.electric_bolt_rounded,
                      gradientColors: const [
                        Color(0xFF3B82F6),
                        Color(0xFF6366F1),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppValues.paddingSm),
                _buildAnimatedItem(
                  3,
                  SizedBox(
                    height: 150,
                    child: EnergyCard(
                      title: AppStrings.surplusDeficit,
                      value: energy.energyData!.surplus.toStringAsFixed(1),
                      unit: AppStrings.kwh,
                      icon: energy.energyData!.isDeficit
                          ? Icons.trending_down_rounded
                          : Icons.trending_up_rounded,
                      gradientColors: energy.energyData!.isDeficit
                          ? const [Color(0xFFEF4444), Color(0xFFF97316)]
                          : const [Color(0xFF22C55E), Color(0xFF10B981)],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppValues.paddingLg),

              // Recent Trades
              _buildAnimatedItem(
                4,
                Column(
                  children: [
                    SectionHeader(
                      title: AppStrings.recentTrades,
                      actionText: 'See All',
                      onAction: () {
                        // Navigate to trades tab - handled by parent
                      },
                    ),
                    const SizedBox(height: AppValues.paddingSm),
                    if (trades.isLoading)
                      const ShimmerCardList(count: 3, cardHeight: 80)
                    else if (trades.recentTrades.isEmpty)
                      _EmptyState(
                        icon: Icons.swap_horiz_rounded,
                        title: AppStrings.noTradesFound,
                        subtitle: AppStrings.noTradesSubtitle,
                      )
                    else
                      ...trades.recentTrades.map(
                        (trade) => TradeTile(
                          seller: trade.seller,
                          buyer: trade.buyer,
                          units: trade.units.toStringAsFixed(1),
                          timestamp: trade.formattedTime,
                          status: trade.statusText,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppValues.paddingLg),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Live Indicator with pulsing dot ──
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
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(
                        alpha: _pulseController.value * 0.5,
                      ),
                      blurRadius: 4 + _pulseController.value * 4,
                      spreadRadius: _pulseController.value * 2,
                    ),
                  ],
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

// ── Auto Trade Badge ──
class _AutoTradeBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingSm,
        vertical: AppValues.paddingXs,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppValues.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            AppStrings.autoTradingActive,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ──
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.paddingXl),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.textMuted),
          const SizedBox(height: AppValues.paddingMd),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppValues.paddingXs),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}
