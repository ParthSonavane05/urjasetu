class SellerModel {
  final String id;
  final String name;
  final String city;
  final double solarCapacity; // kW
  final double pricePerKwh; // ₹
  final double availableEnergy; // kWh
  final double rating;
  final double distance; // km
  final String description;

  const SellerModel({
    required this.id,
    required this.name,
    required this.city,
    required this.solarCapacity,
    required this.pricePerKwh,
    required this.availableEnergy,
    required this.rating,
    required this.distance,
    this.description = '',
  });

  String get capacityDisplay => '${solarCapacity.toStringAsFixed(1)} kW';
  String get priceDisplay => '₹${pricePerKwh.toStringAsFixed(1)}';
  String get energyDisplay => '${availableEnergy.toStringAsFixed(0)} kWh';
  String get distanceDisplay => '${distance.toStringAsFixed(1)} km';
  String get ratingDisplay => rating.toStringAsFixed(1);
}
