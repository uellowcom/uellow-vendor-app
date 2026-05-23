import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/order_model.dart';

final orderFilterProvider = StateProvider<String>((ref) => 'all');

final ordersProvider = FutureProvider.family<List<OrderModel>, String>((ref, state) async {
  final params = state != 'all' ? {'state': state} : <String, dynamic>{};
  final response = await ApiClient.instance.get('/api/vendor/orders', queryParameters: params);
  final list = response.data['orders'] as List? ?? [];
  return list.map((o) => OrderModel.fromJson(o as Map<String, dynamic>)).toList();
});
