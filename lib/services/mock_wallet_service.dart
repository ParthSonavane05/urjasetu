import '../models/wallet_model.dart';

class MockWalletService {
  Future<WalletModel> getWalletData() async {
    await Future.delayed(const Duration(milliseconds: 700));
    final now = DateTime.now();
    return WalletModel(
      balance: 2847.50,
      totalEarnings: 12340.00,
      monthlyEarnings: [
        1200, 1450, 980, 1680, 2100, 1890,
        2340, 1760, 2050, 2400, 2680, 2847,
      ],
      transactions: [
        Transaction(
          id: 't1',
          description: 'Sold 5.2 kWh to Amit K.',
          amount: 23.40,
          type: TransactionType.credit,
          timestamp: now.subtract(const Duration(minutes: 12)),
        ),
        Transaction(
          id: 't2',
          description: 'Bought 3.8 kWh from Neha S.',
          amount: 15.96,
          type: TransactionType.debit,
          timestamp: now.subtract(const Duration(hours: 2)),
        ),
        Transaction(
          id: 't3',
          description: 'Sold 8.0 kWh to Raj P.',
          amount: 38.40,
          type: TransactionType.credit,
          timestamp: now.subtract(const Duration(hours: 5)),
        ),
        Transaction(
          id: 't4',
          description: 'Bought 2.5 kWh from Priya M.',
          amount: 10.00,
          type: TransactionType.debit,
          timestamp: now.subtract(const Duration(days: 1)),
        ),
        Transaction(
          id: 't5',
          description: 'Sold 6.3 kWh to Vikram T.',
          amount: 28.98,
          type: TransactionType.credit,
          timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        ),
        Transaction(
          id: 't6',
          description: 'Platform reward bonus',
          amount: 50.00,
          type: TransactionType.credit,
          timestamp: now.subtract(const Duration(days: 2)),
        ),
      ],
    );
  }
}
