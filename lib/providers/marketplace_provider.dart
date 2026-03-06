import 'package:flutter/material.dart';
import '../models/seller_model.dart';
import '../services/mock_marketplace_service.dart';

class MarketplaceProvider extends ChangeNotifier {
  final MockMarketplaceService _service = MockMarketplaceService();

  List<SellerModel> _allSellers = [];
  List<SellerModel> _filteredSellers = [];
  bool _isLoading = false;

  String? _filterCity;
  double? _maxPrice;
  double? _minRating;

  List<SellerModel> get sellers => _filteredSellers;
  bool get isLoading => _isLoading;
  String? get filterCity => _filterCity;

  List<SellerModel> get recommendedSellers {
    final sorted = List<SellerModel>.from(_filteredSellers);
    sorted.sort((a, b) {
      final scoreA = a.rating * 10 - a.distance + (a.availableEnergy / 100);
      final scoreB = b.rating * 10 - b.distance + (b.availableEnergy / 100);
      return scoreB.compareTo(scoreA);
    });
    return sorted.take(4).toList();
  }

  List<String> get availableCities {
    return _allSellers.map((s) => s.city).toSet().toList()..sort();
  }

  Future<void> loadSellers() async {
    _isLoading = true;
    notifyListeners();

    _allSellers = await _service.getSellers();
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  void setFilterCity(String? city) {
    _filterCity = city;
    _applyFilters();
    notifyListeners();
  }

  void setMaxPrice(double? price) {
    _maxPrice = price;
    _applyFilters();
    notifyListeners();
  }

  void setMinRating(double? rating) {
    _minRating = rating;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _filterCity = null;
    _maxPrice = null;
    _minRating = null;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredSellers = _allSellers.where((seller) {
      if (_filterCity != null && seller.city != _filterCity) return false;
      if (_maxPrice != null && seller.pricePerKwh > _maxPrice!) return false;
      if (_minRating != null && seller.rating < _minRating!) return false;
      return true;
    }).toList();
  }
}
