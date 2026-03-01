import 'package:flutter/material.dart';
import '../models/trade_model.dart';
import '../services/mock_trade_service.dart';

enum TradeFilter { all, sent, received }

class TradeProvider extends ChangeNotifier {
  final MockTradeService _service = MockTradeService();

  List<TradeModel> _trades = [];
  bool _isLoading = false;
  TradeFilter _filter = TradeFilter.all;

  List<TradeModel> get trades => _filteredTrades;
  List<TradeModel> get allTrades => _trades;
  bool get isLoading => _isLoading;
  TradeFilter get filter => _filter;

  List<TradeModel> get _filteredTrades {
    switch (_filter) {
      case TradeFilter.all:
        return _trades;
      case TradeFilter.sent:
        return _trades.where((t) => t.type == TradeType.sent).toList();
      case TradeFilter.received:
        return _trades.where((t) => t.type == TradeType.received).toList();
    }
  }

  List<TradeModel> get recentTrades => _trades.take(3).toList();

  void setFilter(TradeFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> loadTrades() async {
    _isLoading = true;
    notifyListeners();

    _trades = await _service.getTrades();
    _isLoading = false;
    notifyListeners();
  }
}
