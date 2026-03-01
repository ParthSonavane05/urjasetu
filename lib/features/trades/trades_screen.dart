import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../core/widgets/trade_tile.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../../providers/trade_provider.dart';

class TradesScreen extends StatefulWidget {
  const TradesScreen({super.key});

  @override
  State<TradesScreen> createState() => _TradesScreenState();
}

class _TradesScreenState extends State<TradesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TradeProvider>();
      if (provider.allTrades.isEmpty) {
        provider.loadTrades();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tradeProvider = context.watch<TradeProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppValues.paddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppValues.paddingSm),
                  Text(
                    AppStrings.tradeHistory,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: AppValues.paddingMd),

                  // Filter Tabs
                  _FilterTabs(
                    currentFilter: tradeProvider.filter,
                    onFilterChanged: (f) => tradeProvider.setFilter(f),
                  ),
                ],
              ),
            ),

            // Trade List
            Expanded(
              child: tradeProvider.isLoading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppValues.paddingMd),
                      child: ShimmerCardList(count: 5, cardHeight: 80),
                    )
                  : tradeProvider.trades.isEmpty
                      ? _EmptyTrades()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppValues.paddingMd),
                          itemCount: tradeProvider.trades.length,
                          itemBuilder: (context, index) {
                            final trade = tradeProvider.trades[index];
                            return TradeTile(
                              seller: trade.seller,
                              buyer: trade.buyer,
                              units: trade.units.toStringAsFixed(1),
                              timestamp: trade.formattedTime,
                              status: trade.statusText,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final TradeFilter currentFilter;
  final ValueChanged<TradeFilter> onFilterChanged;

  const _FilterTabs({
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppValues.radiusMd),
      ),
      child: Row(
        children: TradeFilter.values.map((filter) {
          final isActive = currentFilter == filter;
          final label = switch (filter) {
            TradeFilter.all => AppStrings.all,
            TradeFilter.sent => AppStrings.sent,
            TradeFilter.received => AppStrings.received,
          };

          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: AnimatedContainer(
                duration: AppValues.animFast,
                padding:
                    const EdgeInsets.symmetric(vertical: AppValues.paddingSm),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.surfaceLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppValues.radiusSm),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isActive
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyTrades extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppValues.paddingLg),
            decoration: BoxDecoration(
              color: AppColors.textMuted.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.swap_horiz_rounded,
              size: 48,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppValues.paddingMd),
          Text(
            AppStrings.noTradesFound,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppValues.paddingXs),
          Text(
            AppStrings.noTradesSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}
