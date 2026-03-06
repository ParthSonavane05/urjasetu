import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../../providers/marketplace_provider.dart';
import '../../models/seller_model.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceProvider>().loadSellers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final marketplace = context.watch<MarketplaceProvider>();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverPadding(
              padding: const EdgeInsets.all(AppValues.paddingMd),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppValues.paddingSm),
                    Text(
                      AppStrings.marketplace,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find solar energy sellers near you',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            // Filters
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.paddingMd),
              sliver: SliverToBoxAdapter(
                child: _FilterBar(marketplace: marketplace),
              ),
            ),

            // Recommended Section
            if (marketplace.recommendedSellers.isNotEmpty &&
                marketplace.filterCity == null)
              SliverPadding(
                padding: const EdgeInsets.all(AppValues.paddingMd),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppValues.paddingSm),
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome,
                              color: AppColors.solarYellow, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            AppStrings.recommendedForYou,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            if (marketplace.recommendedSellers.isNotEmpty &&
                marketplace.filterCity == null)
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.paddingMd),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: marketplace.recommendedSellers.length,
                      separatorBuilder: (context2, index2) =>
                          const SizedBox(width: AppValues.paddingSm),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 280,
                          child: _RecommendedCard(
                            seller: marketplace.recommendedSellers[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

            // All Sellers
            SliverPadding(
              padding: const EdgeInsets.all(AppValues.paddingMd),
              sliver: SliverToBoxAdapter(
                child: Text(
                  AppStrings.allSellers,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),

            // Seller List
            if (marketplace.isLoading)
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppValues.paddingMd),
                sliver: SliverToBoxAdapter(
                  child: ShimmerCardList(count: 4, cardHeight: 130),
                ),
              )
            else if (marketplace.sellers.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(AppValues.paddingXl),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 48, color: AppColors.textMuted),
                        const SizedBox(height: AppValues.paddingMd),
                        Text(
                          'No sellers found',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try adjusting your filters',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.paddingMd),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppValues.paddingSm),
                        child:
                            _SellerCard(seller: marketplace.sellers[index]),
                      );
                    },
                    childCount: marketplace.sellers.length,
                  ),
                ),
              ),

            const SliverPadding(
                padding: EdgeInsets.only(bottom: AppValues.paddingXl)),
          ],
        ),
      ),
    );
  }
}

// ── Filter Bar ──
class _FilterBar extends StatelessWidget {
  final MarketplaceProvider marketplace;

  const _FilterBar({required this.marketplace});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // City filter
          _FilterChip(
            label: marketplace.filterCity ?? AppStrings.filterByCity,
            isActive: marketplace.filterCity != null,
            onTap: () => _showCityFilter(context),
          ),
          const SizedBox(width: AppValues.paddingSm),
          _FilterChip(
            label: AppStrings.filterByRating,
            isActive: false,
            onTap: () {},
          ),
          const SizedBox(width: AppValues.paddingSm),
          _FilterChip(
            label: AppStrings.filterByPrice,
            isActive: false,
            onTap: () {},
          ),
          if (marketplace.filterCity != null) ...[
            const SizedBox(width: AppValues.paddingSm),
            GestureDetector(
              onTap: () => marketplace.clearFilters(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.paddingSm + 4,
                  vertical: AppValues.paddingSm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(AppValues.radiusRound),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close_rounded, size: 14, color: AppColors.error),
                    SizedBox(width: 4),
                    Text('Clear',
                        style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCityFilter(BuildContext context) {
    final cities = marketplace.availableCities;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppValues.radiusLg)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppValues.paddingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select City',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppValues.paddingMd),
              Wrap(
                spacing: AppValues.paddingSm,
                runSpacing: AppValues.paddingSm,
                children: cities.map((city) {
                  return GestureDetector(
                    onTap: () {
                      marketplace.setFilterCity(city);
                      Navigator.pop(context);
                    },
                    child: Chip(
                      label: Text(city),
                      backgroundColor: marketplace.filterCity == city
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppValues.paddingMd),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingSm + 4,
          vertical: AppValues.paddingSm,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppValues.radiusRound),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isActive ? AppColors.primary : null,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isActive ? AppColors.primary : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Recommended Card ──
class _RecommendedCard extends StatelessWidget {
  final SellerModel seller;

  const _RecommendedCard({required this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.paddingMd),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppValues.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppValues.radiusSm),
                ),
                child: Center(
                  child: Text(
                    seller.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppValues.paddingSm + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seller.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${seller.city} • ${seller.distanceDisplay}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppValues.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      seller.ratingDisplay,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.paddingSm),
          Text(
            seller.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppValues.paddingSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${seller.priceDisplay}/kWh',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(
                '${seller.energyDisplay} available',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Seller Card ──
class _SellerCard extends StatelessWidget {
  final SellerModel seller;

  const _SellerCard({required this.seller});

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
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppValues.radiusMd),
                ),
                child: Center(
                  child: Text(
                    seller.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppValues.paddingSm + 4),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seller.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 2),
                        Text(
                          '${seller.city} • ${seller.distanceDisplay}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Rating
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.solarYellow.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(AppValues.radiusRound),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.solarYellow, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      seller.ratingDisplay,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.solarYellow,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.paddingMd),
          // Details row
          Row(
            children: [
              _DetailChip(
                icon: Icons.solar_power_rounded,
                label: seller.capacityDisplay,
              ),
              const SizedBox(width: AppValues.paddingSm),
              _DetailChip(
                icon: Icons.bolt_rounded,
                label: '${seller.energyDisplay} avail',
              ),
              const Spacer(),
              Text(
                '${seller.priceDisplay}/kWh',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.paddingMd),
          // Buy button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Energy purchase from ${seller.name} initiated!'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppValues.radiusSm)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
              ),
              child: const Text(AppStrings.buyEnergy),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.textMuted.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppValues.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
