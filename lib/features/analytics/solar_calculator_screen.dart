import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_values.dart';
import '../../providers/analytics_provider.dart';

class SolarCalculatorScreen extends StatefulWidget {
  const SolarCalculatorScreen({super.key});

  @override
  State<SolarCalculatorScreen> createState() => _SolarCalculatorScreenState();
}

class _SolarCalculatorScreenState extends State<SolarCalculatorScreen> {
  final _roofSizeController = TextEditingController();
  String _selectedCity = 'Vadodara';
  String _selectedRoofType = 'Flat';
  Map<String, double>? _result;

  final List<String> _roofTypes = ['Flat', 'Sloped', 'Metal'];

  void _calculate() {
    final roofSize = double.tryParse(_roofSizeController.text);
    if (roofSize == null || roofSize <= 0) return;

    final analytics = context.read<AnalyticsProvider>();
    setState(() {
      _result = analytics.calculateSolarPotential(
        roofSizeSqFt: roofSize,
        roofType: _selectedRoofType,
        city: _selectedCity,
      );
    });
  }

  @override
  void dispose() {
    _roofSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.solarCalculator),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estimate your solar potential',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.textSecondary),
            ),

            const SizedBox(height: AppValues.paddingLg),

            // City
            Text('City', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppValues.paddingSm),
            DropdownButtonFormField<String>(
              initialValue: _selectedCity,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_city_rounded),
              ),
              items: AppStrings.indianCities
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCity = v!),
            ),

            const SizedBox(height: AppValues.paddingMd),

            // Roof size
            Text('Roof Size (sq ft)',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppValues.paddingSm),
            TextFormField(
              controller: _roofSizeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 1000',
                prefixIcon: Icon(Icons.roofing_rounded),
              ),
            ),

            const SizedBox(height: AppValues.paddingMd),

            // Roof type
            Text('Roof Type',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppValues.paddingSm),
            Row(
              children: _roofTypes.map((type) {
                final isSelected = _selectedRoofType == type;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: type != _roofTypes.last ? AppValues.paddingSm : 0,
                    ),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedRoofType = type),
                      child: AnimatedContainer(
                        duration: AppValues.animFast,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppValues.paddingMd),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Theme.of(context).cardTheme.color,
                          borderRadius:
                              BorderRadius.circular(AppValues.radiusMd),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            type,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: isSelected
                                      ? AppColors.primary
                                      : null,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppValues.paddingXl),

            // Calculate button
            SizedBox(
              width: double.infinity,
              height: AppValues.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate_rounded),
                label: const Text('Calculate'),
              ),
            ),

            // Results
            if (_result != null) ...[
              const SizedBox(height: AppValues.paddingXl),
              Container(
                padding: const EdgeInsets.all(AppValues.paddingLg),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius:
                      BorderRadius.circular(AppValues.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Solar Potential',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: AppValues.paddingLg),
                    Row(
                      children: [
                        _ResultItem(
                          icon: Icons.solar_power_rounded,
                          value: '${_result!['capacity']}',
                          unit: 'kW',
                          label: 'Solar Capacity',
                        ),
                        _ResultItem(
                          icon: Icons.bolt_rounded,
                          value: '${_result!['monthlyGeneration']!.toInt()}',
                          unit: 'units/mo',
                          label: 'Generation',
                        ),
                        _ResultItem(
                          icon: Icons.savings_rounded,
                          value:
                              '₹${_result!['monthlySavings']!.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                          unit: '/month',
                          label: 'Savings',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppValues.paddingXl),
          ],
        ),
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final String label;

  const _ResultItem({
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
          ),
        ],
      ),
    );
  }
}
