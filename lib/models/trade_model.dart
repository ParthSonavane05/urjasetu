enum TradeStatus { completed, pending, failed }

enum TradeType { sent, received }

class TradeModel {
  final String id;
  final String seller;
  final String buyer;
  final double units;
  final double pricePerUnit;
  final DateTime timestamp;
  final TradeStatus status;
  final TradeType type;

  const TradeModel({
    required this.id,
    required this.seller,
    required this.buyer,
    required this.units,
    required this.pricePerUnit,
    required this.timestamp,
    required this.status,
    required this.type,
  });

  double get totalPrice => units * pricePerUnit;

  String get statusText {
    switch (status) {
      case TradeStatus.completed:
        return 'Completed';
      case TradeStatus.pending:
        return 'Pending';
      case TradeStatus.failed:
        return 'Failed';
    }
  }

  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
