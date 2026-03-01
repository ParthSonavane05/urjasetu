import '../models/energy_data.dart';

class MockEnergyService {
  Future<EnergyData> getEnergyData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return EnergyData.mock();
  }
}
