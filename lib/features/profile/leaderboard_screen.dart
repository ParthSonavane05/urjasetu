import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/auth_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final analytics = context.watch<AnalyticsProvider>();
    final city = auth.user?.city ?? 'Vadodara';
    final entries = analytics.getLeaderboard(city);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.leaderboard),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Solar Producers in $city',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Encouraging competition for cleaner energy',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppValues.paddingLg),

            // Top 3 podium
            if (entries.length >= 3) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: _PodiumCard(entry: entries[1], rank: 2)),
                  const SizedBox(width: AppValues.paddingSm),
                  Expanded(child: _PodiumCard(entry: entries[0], rank: 1)),
                  const SizedBox(width: AppValues.paddingSm),
                  Expanded(child: _PodiumCard(entry: entries[2], rank: 3)),
                ],
              ),
              const SizedBox(height: AppValues.paddingLg),
            ],

            // Full list
            ...entries.asMap().entries.map((e) {
              final index = e.key;
              final entry = e.value;
              return _LeaderboardTile(
                rank: index + 1,
                name: entry['name'] as String,
                energy: entry['energy'] as int,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final int rank;

  const _PodiumCard({required this.entry, required this.rank});

  @override
  Widget build(BuildContext context) {
    final isFirst = rank == 1;
    final colors = rank == 1
        ? [const Color(0xFFF59E0B), const Color(0xFFF97316)]
        : rank == 2
            ? [const Color(0xFF94A3B8), const Color(0xFF64748B)]
            : [const Color(0xFFCD7F32), const Color(0xFFB87333)];

    return Container(
      height: isFirst ? 180 : 150,
      padding: const EdgeInsets.all(AppValues.paddingSm + 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(AppValues.radiusLg),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '#$rank',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            entry['name'] as String,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${entry['energy']} kWh',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  final int rank;
  final String name;
  final int energy;

  const _LeaderboardTile({
    required this.rank,
    required this.name,
    required this.energy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppValues.paddingSm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingMd,
        vertical: AppValues.paddingSm + 4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppValues.radiusMd),
        border: Border.all(
          color: Theme.of(context).dividerTheme.color ?? AppColors.border,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? AppColors.solarYellow.withValues(alpha: 0.15)
                  : AppColors.textMuted.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppValues.radiusSm),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: rank <= 3
                          ? AppColors.solarYellow
                          : AppColors.textSecondary,
                    ),
              ),
            ),
          ),
          const SizedBox(width: AppValues.paddingSm + 4),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '$energy kWh',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
