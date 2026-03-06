import 'package:flutter/material.dart';

class AnalyticsProvider extends ChangeNotifier {
  // Monthly energy data (Jan-Dec)
  final List<double> monthlyProduction = [
    420, 480, 550, 620, 700, 750, 720, 680, 600, 520, 460, 400,
  ];

  final List<double> monthlyRevenue = [
    1890, 2160, 2475, 2790, 3150, 3375, 3240, 3060, 2700, 2340, 2070, 1800,
  ];

  final List<double> monthlyPurchases = [
    380, 420, 500, 560, 640, 680, 660, 620, 540, 480, 420, 360,
  ];

  final List<double> monthlySavings = [
    1520, 1680, 2000, 2240, 2560, 2720, 2640, 2480, 2160, 1920, 1680, 1440,
  ];

  // Carbon impact: 1 kWh = 0.82 kg CO₂
  static const double co2PerKwh = 0.82;

  double get totalEnergyProduced =>
      monthlyProduction.fold(0, (sum, e) => sum + e);

  double get totalRevenue => monthlyRevenue.fold(0, (sum, e) => sum + e);

  double get totalCO2Saved => totalEnergyProduced * co2PerKwh;

  double get treesEquivalent => totalCO2Saved / 25; // 1 tree ~ 25 kg CO₂/year

  double get carKmAvoided =>
      totalCO2Saved / 0.21; // avg car emits 0.21 kg CO₂/km

  double get todayEnergy => 850;
  double get todayRevenue => 5600;
  double get todayCarbonSaved => todayEnergy * co2PerKwh;
  int get activeBuyers => 6;

  // Buyer stats
  double get totalEnergyPurchased =>
      monthlyPurchases.fold(0, (sum, e) => sum + e);
  double get totalSavings => monthlySavings.fold(0, (sum, e) => sum + e);
  double get buyerCO2Reduction => totalEnergyPurchased * co2PerKwh;

  // Solar calculator
  Map<String, double> calculateSolarPotential({
    required double roofSizeSqFt,
    required String roofType,
    required String city,
  }) {
    // Factor based on city solar irradiance
    final cityFactor = _getCityFactor(city);
    // Factor based on roof type
    final roofFactor = _getRoofFactor(roofType);

    // ~1 kW per 100 sq ft
    final capacity = (roofSizeSqFt / 100) * roofFactor;
    // ~4 kWh per kW per day average in India * 30 days
    final monthlyGeneration = capacity * 4 * 30 * cityFactor;
    // ₹8 per unit average savings
    final monthlySavingsCalc = monthlyGeneration * 8;

    return {
      'capacity': double.parse(capacity.toStringAsFixed(1)),
      'monthlyGeneration': double.parse(monthlyGeneration.toStringAsFixed(0)),
      'monthlySavings': double.parse(monthlySavingsCalc.toStringAsFixed(0)),
    };
  }

  double _getCityFactor(String city) {
    switch (city.toLowerCase()) {
      case 'delhi':
      case 'jaipur':
        return 1.1;
      case 'mumbai':
      case 'chennai':
        return 0.95;
      case 'bengaluru':
        return 1.0;
      case 'ahmedabad':
      case 'vadodara':
      case 'surat':
        return 1.15;
      default:
        return 1.0;
    }
  }

  double _getRoofFactor(String roofType) {
    switch (roofType.toLowerCase()) {
      case 'flat':
        return 1.0;
      case 'sloped':
        return 0.85;
      case 'metal':
        return 0.9;
      default:
        return 1.0;
    }
  }

  // Leaderboard
  List<Map<String, dynamic>> getLeaderboard(String city) {
    return [
      {'name': 'Raj Patel', 'energy': 1200, 'city': city},
      {'name': 'Sunita Shah', 'energy': 980, 'city': city},
      {'name': 'Green Energy Society', 'energy': 860, 'city': city},
      {'name': 'Amit Verma', 'energy': 750, 'city': city},
      {'name': 'Solar Corp', 'energy': 680, 'city': city},
      {'name': 'Priya Mehta', 'energy': 520, 'city': city},
      {'name': 'Vikram Desai', 'energy': 480, 'city': city},
      {'name': 'Meena Iyer', 'energy': 430, 'city': city},
    ];
  }
}
