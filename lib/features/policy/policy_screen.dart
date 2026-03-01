import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../core/widgets/section_header.dart';
import '../../providers/policy_provider.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

              // Header
              Text(
                AppStrings.tradingPolicy,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppValues.paddingXs),
              Text(
                AppStrings.policySubtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),

              const SizedBox(height: AppValues.paddingXl),

              // Auto Trading Toggle
              _PolicyCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppValues.paddingSm),
                          decoration: BoxDecoration(
                            color: policy.policy.autoTrading
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.textMuted.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppValues.radiusMd),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: policy.policy.autoTrading
                                ? AppColors.primary
                                : AppColors.textMuted,
                            size: AppValues.iconMd,
                          ),
                        ),
                        const SizedBox(width: AppValues.paddingMd),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.autoTrading,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              policy.policy.autoTrading
                                  ? 'Currently active'
                                  : 'Currently inactive',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: policy.policy.autoTrading,
                      onChanged: (v) =>
                          context.read<PolicyProvider>().toggleAutoTrading(v),
                      activeTrackColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppValues.paddingLg),

              // Sell Threshold
              const SectionHeader(title: AppStrings.sellThreshold),
              _PolicyCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.all(AppValues.paddingSm),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(AppValues.radiusMd),
                              ),
                              child: const Icon(
                                Icons.trending_up_rounded,
                                color: AppColors.success,
                                size: AppValues.iconMd,
                              ),
                            ),
                            const SizedBox(width: AppValues.paddingMd),
                            Text(
                              'Sell when surplus exceeds',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppValues.paddingSm,
                            vertical: AppValues.paddingXs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppValues.radiusSm),
                          ),
                          child: Text(
                            '${policy.policy.sellThreshold.toStringAsFixed(0)} kWh',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppValues.paddingSm),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor:
                            AppColors.primary.withValues(alpha: 0.15),
                        thumbColor: AppColors.primary,
                        overlayColor: AppColors.primary.withValues(alpha: 0.1),
                        trackHeight: 6,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 10),
                      ),
                      child: Slider(
                        value: policy.policy.sellThreshold,
                        min: 0,
                        max: 50,
                        divisions: 50,
                        onChanged: (v) =>
                            context.read<PolicyProvider>().setSellThreshold(v),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0 kWh',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColors.textMuted)),
                        Text('50 kWh',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppValues.paddingLg),

              // Buy Threshold
              const SectionHeader(title: AppStrings.buyThreshold),
              _PolicyCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.all(AppValues.paddingSm),
                              decoration: BoxDecoration(
                                color: AppColors.info.withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(AppValues.radiusMd),
                              ),
                              child: const Icon(
                                Icons.trending_down_rounded,
                                color: AppColors.info,
                                size: AppValues.iconMd,
                              ),
                            ),
                            const SizedBox(width: AppValues.paddingMd),
                            Text(
                              'Buy when deficit exceeds',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppValues.paddingSm,
                            vertical: AppValues.paddingXs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppValues.radiusSm),
                          ),
                          child: Text(
                            '${policy.policy.buyThreshold.toStringAsFixed(0)} kWh',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppValues.paddingSm),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: AppColors.info,
                        inactiveTrackColor:
                            AppColors.info.withValues(alpha: 0.15),
                        thumbColor: AppColors.info,
                        overlayColor: AppColors.info.withValues(alpha: 0.1),
                        trackHeight: 6,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 10),
                      ),
                      child: Slider(
                        value: policy.policy.buyThreshold,
                        min: 0,
                        max: 30,
                        divisions: 30,
                        onChanged: (v) =>
                            context.read<PolicyProvider>().setBuyThreshold(v),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0 kWh',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColors.textMuted)),
                        Text('30 kWh',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                  ],
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

class _PolicyCard extends StatelessWidget {
  final Widget child;

  const _PolicyCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppValues.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppValues.radiusXl),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
