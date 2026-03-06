import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/mock_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final MockAuthService _authService = MockAuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  bool get isSetupComplete => _user?.isSetupComplete ?? false;
  String? get error => _error;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Login failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate signup delay
      await Future.delayed(const Duration(milliseconds: 800));
      _user = UserModel(name: name, email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Signup failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void setCity(String city) {
    if (_user != null) {
      _user = _user!.copyWith(city: city);
      notifyListeners();
    }
  }

  void setRole(UserRole role) {
    if (_user != null) {
      _user = _user!.copyWith(role: role);
      if (role == UserRole.solarOwner) {
        _user = _user!.copyWith(solarCapacity: 5.0);
      }
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
