import '../models/trade_model.dart';

class MockTradeService {
  Future<List<TradeModel>> getTrades() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    return [
      TradeModel(
        id: '1',
        seller: 'You',
        buyer: 'Amit K.',
        units: 5.2,
        pricePerUnit: 4.50,
        timestamp: now.subtract(const Duration(minutes: 12)),
        status: TradeStatus.completed,
        type: TradeType.sent,
      ),
      TradeModel(
        id: '2',
        seller: 'Neha S.',
        buyer: 'You',
        units: 3.8,
        pricePerUnit: 4.20,
        timestamp: now.subtract(const Duration(hours: 2)),
        status: TradeStatus.completed,
        type: TradeType.received,
      ),
      TradeModel(
        id: '3',
        seller: 'You',
        buyer: 'Raj P.',
        units: 8.0,
        pricePerUnit: 4.80,
        timestamp: now.subtract(const Duration(hours: 5)),
        status: TradeStatus.pending,
        type: TradeType.sent,
      ),
      TradeModel(
        id: '4',
        seller: 'Priya M.',
        buyer: 'You',
        units: 2.5,
        pricePerUnit: 4.00,
        timestamp: now.subtract(const Duration(days: 1)),
        status: TradeStatus.completed,
        type: TradeType.received,
      ),
      TradeModel(
        id: '5',
        seller: 'You',
        buyer: 'Vikram T.',
        units: 6.3,
        pricePerUnit: 4.60,
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        status: TradeStatus.failed,
        type: TradeType.sent,
      ),
      TradeModel(
        id: '6',
        seller: 'Anita R.',
        buyer: 'You',
        units: 4.1,
        pricePerUnit: 4.30,
        timestamp: now.subtract(const Duration(days: 2)),
        status: TradeStatus.completed,
        type: TradeType.received,
      ),
      TradeModel(
        id: '7',
        seller: 'You',
        buyer: 'Deepak L.',
        units: 7.5,
        pricePerUnit: 4.70,
        timestamp: now.subtract(const Duration(days: 3)),
        status: TradeStatus.completed,
        type: TradeType.sent,
      ),
    ];
  }
}
