import 'package:flutter/material.dart';
import '../models/policy_model.dart';

class PolicyProvider extends ChangeNotifier {
  PolicyModel _policy = const PolicyModel();

  PolicyModel get policy => _policy;

  void setSellThreshold(double value) {
    _policy = _policy.copyWith(sellThreshold: value);
    notifyListeners();
  }

  void setBuyThreshold(double value) {
    _policy = _policy.copyWith(buyThreshold: value);
    notifyListeners();
  }

  void toggleAutoTrading(bool value) {
    _policy = _policy.copyWith(autoTrading: value);
    notifyListeners();
  }
}
