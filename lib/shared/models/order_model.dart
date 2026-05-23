class OrderModel {
  final int id;
  final String name;
  final String date;
  final double amount;
  final String state;
  final String partner;

  const OrderModel({
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
    required this.state,
    required this.partner,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    date: json['date'] ?? '',
    amount: (json['amount'] ?? 0).toDouble(),
    state: json['state'] ?? '',
    partner: json['partner'] ?? '',
  );

  bool get isPending => state == 'draft' || state == 'sale';
  bool get isDelivered => state == 'done';
  bool get isCancelled => state == 'cancel';
}
