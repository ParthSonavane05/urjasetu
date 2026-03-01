import 'package:flutter/material.dart';
import '../models/wallet_model.dart';
import '../services/mock_wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  final MockWalletService _service = MockWalletService();

  WalletModel? _wallet;
  bool _isLoading = false;

  WalletModel? get wallet => _wallet;
  bool get isLoading => _isLoading;

  Future<void> loadWalletData() async {
    _isLoading = true;
    notifyListeners();

    _wallet = await _service.getWalletData();
    _isLoading = false;
    notifyListeners();
  }
}
