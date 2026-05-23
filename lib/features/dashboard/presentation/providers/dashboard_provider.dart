import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/vendor_model.dart';

final dashboardProvider = FutureProvider<VendorModel>((ref) async {
  final response = await ApiClient.instance.get('/api/vendor/dashboard');
  return VendorModel.fromJson(response.data as Map<String, dynamic>);
});
