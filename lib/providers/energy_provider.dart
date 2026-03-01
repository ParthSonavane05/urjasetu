import 'package:flutter/material.dart';
import '../models/energy_data.dart';
import '../services/mock_energy_service.dart';

class EnergyProvider extends ChangeNotifier {
  final MockEnergyService _service = MockEnergyService();

  EnergyData? _energyData;
  bool _isLoading = false;

  EnergyData? get energyData => _energyData;
  bool get isLoading => _isLoading;

  Future<void> loadEnergyData() async {
    _isLoading = true;
    notifyListeners();

    _energyData = await _service.getEnergyData();
    _isLoading = false;
    notifyListeners();
  }
}
