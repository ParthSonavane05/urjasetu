class UserModel {
  final String name;
  final String email;
  final String avatarUrl;

  const UserModel({
    required this.name,
    required this.email,
    this.avatarUrl = '',
  });

  factory UserModel.mock() {
    return const UserModel(
      name: 'Parth Sonavane',
      email: 'parth@urjasetu.com',
      avatarUrl: '',
    );
  }
}
