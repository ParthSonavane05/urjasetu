class EnergyData {
  final double produced;
  final double consumed;
  final double surplus;

  const EnergyData({
    required this.produced,
    required this.consumed,
    required this.surplus,
  });

  factory EnergyData.mock() {
    return const EnergyData(
      produced: 48.5,
      consumed: 32.1,
      surplus: 16.4,
    );
  }

  bool get isDeficit => surplus < 0;
}
