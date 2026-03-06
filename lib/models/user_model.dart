enum UserRole { solarOwner, energyBuyer }

class UserModel {
  final String name;
  final String email;
  final String avatarUrl;
  final String? city;
  final UserRole? role;
  final double? solarCapacity; // in kW, for solar owners

  const UserModel({
    required this.name,
    required this.email,
    this.avatarUrl = '',
    this.city,
    this.role,
    this.solarCapacity,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? city,
    UserRole? role,
    double? solarCapacity,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      role: role ?? this.role,
      solarCapacity: solarCapacity ?? this.solarCapacity,
    );
  }

  bool get isSolarOwner => role == UserRole.solarOwner;
  bool get isEnergyBuyer => role == UserRole.energyBuyer;
  bool get isSetupComplete => city != null && role != null;

  String get roleDisplayName {
    switch (role) {
      case UserRole.solarOwner:
        return 'Solar Energy Owner';
      case UserRole.energyBuyer:
        return 'Energy Buyer';
      default:
        return 'User';
    }
  }

  factory UserModel.mock() {
    return const UserModel(
      name: 'Parth Sonavane',
      email: 'parth@urjasetu.com',
      avatarUrl: '',
      city: 'Vadodara',
      role: UserRole.solarOwner,
      solarCapacity: 5.0,
    );
  }
}
