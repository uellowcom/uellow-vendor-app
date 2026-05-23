class WalletModel {
  final double balance;
  final double pending;
  final double totalEarned;
  final String currency;
  final List<TransactionModel> transactions;

  const WalletModel({
    required this.balance,
    required this.pending,
    required this.totalEarned,
    required this.currency,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    balance: (json['balance'] ?? 0).toDouble(),
    pending: (json['pending'] ?? 0).toDouble(),
    totalEarned: (json['total_earned'] ?? 0).toDouble(),
    currency: json['currency'] ?? 'KD',
    transactions: (json['transactions'] as List? ?? [])
        .map((t) => TransactionModel.fromJson(t))
        .toList(),
  );
}

class TransactionModel {
  final String date;
  final String type;
  final double amount;
  final String description;

  const TransactionModel({
    required this.date,
    required this.type,
    required this.amount,
    required this.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    date: json['date'] ?? '',
    type: json['type'] ?? 'credit',
    amount: (json['amount'] ?? 0).toDouble(),
    description: json['description'] ?? '',
  );

  bool get isCredit => type == 'credit';
}
