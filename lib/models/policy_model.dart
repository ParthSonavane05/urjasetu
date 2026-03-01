class PolicyModel {
  final double sellThreshold;
  final double buyThreshold;
  final bool autoTrading;

  const PolicyModel({
    this.sellThreshold = 10.0,
    this.buyThreshold = 5.0,
    this.autoTrading = true,
  });

  PolicyModel copyWith({
    double? sellThreshold,
    double? buyThreshold,
    bool? autoTrading,
  }) {
    return PolicyModel(
      sellThreshold: sellThreshold ?? this.sellThreshold,
      buyThreshold: buyThreshold ?? this.buyThreshold,
      autoTrading: autoTrading ?? this.autoTrading,
    );
  }
}
