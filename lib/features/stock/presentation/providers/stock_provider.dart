import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/stock_model.dart';

final stockProvider = FutureProvider<List<StockModel>>((ref) async {
  final response = await ApiClient.instance.get('/api/vendor/stock');
  final list = response.data['products'] as List? ?? [];
  return list.map((p) => StockModel.fromJson(p as Map<String, dynamic>)).toList();
});
