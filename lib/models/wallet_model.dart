enum TransactionType { credit, debit }

class Transaction {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime timestamp;

  const Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.timestamp,
  });

  String get formattedAmount {
    final prefix = type == TransactionType.credit ? '+' : '-';
    return '$prefix₹${amount.toStringAsFixed(2)}';
  }
}

class WalletModel {
  final double balance;
  final double totalEarnings;
  final List<Transaction> transactions;
  final List<double> monthlyEarnings;

  const WalletModel({
    required this.balance,
    required this.totalEarnings,
    required this.transactions,
    required this.monthlyEarnings,
  });
}
