class StockModel {
  final int id;
  final String name;
  final String fbuState;
  final double vendorQty;

  const StockModel({
    required this.id,
    required this.name,
    required this.fbuState,
    required this.vendorQty,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    fbuState: json['fbu_state'] ?? 'out_of_stock',
    vendorQty: (json['vendor_qty'] ?? 0).toDouble(),
  );

  bool get isOnHand => fbuState == 'on_hand';
  bool get isContinueSelling => fbuState == 'continue_selling';
  bool get isOutOfStock => fbuState == 'out_of_stock';
}
