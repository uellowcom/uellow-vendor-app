import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/wallet_model.dart';

final walletProvider = FutureProvider<WalletModel>((ref) async {
  final response = await ApiClient.instance.get('/api/vendor/wallet');
  return WalletModel.fromJson(response.data as Map<String, dynamic>);
});
