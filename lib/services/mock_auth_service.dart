import '../models/user_model.dart';

class MockAuthService {
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return UserModel.mock();
  }
}
