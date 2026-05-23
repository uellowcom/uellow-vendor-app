class VendorModel {
  final int id;
  final String storeNameEn;
  final String storeNameAr;
  final String tier;
  final double walletBalance;
  final int orderCount;
  final double totalSales;
  final double avgRating;
  final double cancelRate;
  final int followerCount;
  final String state;
  final String currency;

  const VendorModel({
    required this.id,
    required this.storeNameEn,
    required this.storeNameAr,
    required this.tier,
    required this.walletBalance,
    required this.orderCount,
    required this.totalSales,
    required this.avgRating,
    required this.cancelRate,
    required this.followerCount,
    required this.state,
    this.currency = 'KD',
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
    id: json['id'] ?? 0,
    storeNameEn: json['store_name_en'] ?? '',
    storeNameAr: json['store_name_ar'] ?? '',
    tier: json['tier'] ?? 'bronze',
    walletBalance: (json['wallet_balance'] ?? 0).toDouble(),
    orderCount: json['order_count'] ?? 0,
    totalSales: (json['total_sales'] ?? 0).toDouble(),
    avgRating: (json['avg_rating'] ?? 0).toDouble(),
    cancelRate: (json['cancel_rate'] ?? 0).toDouble(),
    followerCount: json['follower_count'] ?? 0,
    state: json['state'] ?? 'active',
    currency: json['currency'] ?? 'KD',
  );

  String get storeName => storeNameAr.isNotEmpty ? storeNameAr : storeNameEn;
}
