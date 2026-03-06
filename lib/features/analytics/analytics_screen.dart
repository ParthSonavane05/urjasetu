import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/auth_provider.dart';
import 'solar_calculator_screen.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AnalyticsProvider>();
    final auth = context.watch<AuthProvider>();
    final isOwner = auth.user?.isSolarOwner ?? true;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppValues.paddingSm),
              Text(
                AppStrings.energyAnalytics,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your energy performance',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),

              const SizedBox(height: AppValues.paddingLg),

              // Energy Chart
              _ChartCard(
                title: isOwner
                    ? AppStrings.monthlyProduction
                    : 'Monthly Purchases',
                data:
                    isOwner ? analytics.monthlyProduction : analytics.monthlyPurchases,
                color: AppColors.primary,
                gradientColor: AppColors.primary.withValues(alpha: 0.15),
              ),

              const SizedBox(height: AppValues.paddingMd),

              // Revenue Chart
              _ChartCard(
                title: isOwner
                    ? AppStrings.revenueGraph
                    : 'Monthly Savings',
                data:
                    isOwner ? analytics.monthlyRevenue : analytics.monthlySavings,
                color: AppColors.solarYellow,
                gradientColor: AppColors.solarYellow.withValues(alpha: 0.15),
                prefix: '₹',
              ),

              const SizedBox(height: AppValues.paddingLg),

              // Carbon Impact
              _CarbonImpactSection(analytics: analytics),

              const SizedBox(height: AppValues.paddingMd),

              // Solar Calculator CTA
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SolarCalculatorScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(AppValues.paddingLg),
                  decoration: BoxDecoration(
                    gradient: AppColors.solarGradient,
                    borderRadius:
                        BorderRadius.circular(AppValues.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.solarYellow.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius:
                              BorderRadius.circular(AppValues.radiusMd),
                        ),
                        child: const Icon(Icons.calculate_rounded,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: AppValues.paddingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.solarCalculator,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Estimate your solar potential',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color:
                                        Colors.white.withValues(alpha: 0.85),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white),
                    ],
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

// ── Chart Card ──
class _ChartCard extends StatelessWidget {
  final String title;
  final List<double> data;
  final Color color;
  final Color gradientColor;
  final String prefix;

  const _ChartCard({
    required this.title,
    required this.data,
    required this.color,
    required this.gradientColor,
    this.prefix = '',
  });

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

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
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppValues.paddingMd),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getInterval(),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.textMuted.withValues(alpha: 0.15),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < months.length) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              months[index],
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: gradientColor,
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          '$prefix${spot.y.toInt()}',
                          TextStyle(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getInterval() {
    final max = data.reduce((a, b) => a > b ? a : b);
    return (max / 4).roundToDouble();
  }
}

// ── Carbon Impact Section ──
class _CarbonImpactSection extends StatelessWidget {
  final AnalyticsProvider analytics;

  const _CarbonImpactSection({required this.analytics});

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
                  borderRadius:
                      BorderRadius.circular(AppValues.radiusSm),
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
          const SizedBox(height: AppValues.paddingLg),

          // Big CO₂ number
          Center(
            child: Column(
              children: [
                Text(
                  '${analytics.totalCO2Saved.toInt()}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.success,
                        fontSize: 48,
                      ),
                ),
                Text(
                  'kg CO₂ Saved',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppValues.paddingLg),
          const Divider(),
          const SizedBox(height: AppValues.paddingMd),

          // Equivalents
          Row(
            children: [
              Expanded(
                child: _EquivalentCard(
                  icon: Icons.park_rounded,
                  value: '${analytics.treesEquivalent.toInt()}',
                  label: 'trees planted',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppValues.paddingSm),
              Expanded(
                child: _EquivalentCard(
                  icon: Icons.directions_car_rounded,
                  value: '${(analytics.carKmAvoided).toInt()}',
                  label: 'km car emissions',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EquivalentCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _EquivalentCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.paddingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppValues.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
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
      ),
    );
  }
}
