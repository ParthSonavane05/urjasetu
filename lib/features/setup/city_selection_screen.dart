import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../providers/auth_provider.dart';

class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({super.key});

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String? _selectedCity;
  List<String> _filteredCities = AppStrings.indianCities;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppValues.animSlow,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCities = AppStrings.indianCities;
      } else {
        _filteredCities = AppStrings.indianCities
            .where((c) => c.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _onContinue() {
    if (_selectedCity == null) return;
    context.read<AuthProvider>().setCity(_selectedCity!);
    Navigator.of(context).pushReplacementNamed('/setup-role');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(AppValues.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppValues.paddingLg),

                // Step indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.paddingSm + 4,
                    vertical: AppValues.paddingXs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppValues.radiusRound),
                  ),
                  child: Text(
                    'Step 1 of 2',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),

                const SizedBox(height: AppValues.paddingLg),

                Text(
                  AppStrings.selectCity,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppValues.paddingSm),
                Text(
                  AppStrings.selectCitySubtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.textSecondary),
                ),

                const SizedBox(height: AppValues.paddingLg),

                // Search bar
                TextFormField(
                  controller: _searchController,
                  onChanged: _filterCities,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchCity,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _searchController.clear();
                              _filterCities('');
                            },
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: AppValues.paddingMd),

                // City list
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = _filteredCities[index];
                      final isSelected = _selectedCity == city;
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppValues.paddingSm),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCity = city),
                          child: AnimatedContainer(
                            duration: AppValues.animFast,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppValues.paddingMd,
                              vertical: AppValues.paddingMd,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(
                                  AppValues.radiusMd),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_city_rounded,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textMuted,
                                  size: 22,
                                ),
                                const SizedBox(width: AppValues.paddingSm + 4),
                                Expanded(
                                  child: Text(
                                    city,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? AppColors.primary
                                              : null,
                                        ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppValues.paddingMd),

                // Continue
                SizedBox(
                  width: double.infinity,
                  height: AppValues.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _selectedCity != null ? _onContinue : null,
                    child: const Text(AppStrings.continueText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
