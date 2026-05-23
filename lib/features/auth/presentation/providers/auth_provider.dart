import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_result.dart';
import '../../../../core/constants/app_constants.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final int? uid;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.uid,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    int? uid,
  }) => AuthState(
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    isLoading: isLoading ?? this.isLoading,
    error: error,
    uid: uid ?? this.uid,
  );
}

class AuthNotifier extends Notifier<AuthState> {
  static const _storage = FlutterSecureStorage();

  @override
  AuthState build() => const AuthState();

  Future<void> checkAuth() async {
    final uid = await _storage.read(key: AppConstants.tokenKey);
    if (uid != null) {
      state = state.copyWith(isAuthenticated: true, uid: int.tryParse(uid));
    }
  }

  Future<ApiResult<void>> login(String login, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // استخدام Odoo JSON-RPC endpoint الرسمي
      final response = await ApiClient.instance.post(
        AppConstants.loginEndpoint,
        data: {
          'jsonrpc': '2.0',
          'method': 'call',
          'params': {
            'db': 'odoo',
            'login': login,
            'password': password,
          },
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      final result = response.data['result'];
      if (result == null || result['uid'] == null) {
        final error = response.data['error'];
        state = state.copyWith(isLoading: false, error: 'invalid_credentials');
        return const ApiError('invalid_credentials');
      }

      final uid = result['uid'] as int;
      // حفظ الـ session عبر cookies (Dio يحفظها تلقائياً)
      await _storage.write(key: AppConstants.tokenKey, value: uid.toString());

      state = state.copyWith(isAuthenticated: true, isLoading: false, uid: uid);
      return const ApiSuccess(null);

    } on DioException catch (e) {
      final msg = e.response?.statusCode == 401
          ? 'invalid_credentials'
          : 'network_error';
      state = state.copyWith(isLoading: false, error: msg);
      return ApiError(msg, statusCode: e.response?.statusCode);
    }
  }

  Future<void> logout() async {
    // Odoo logout
    try {
      await ApiClient.instance.post(
        '/web/session/destroy',
        data: {'jsonrpc': '2.0', 'method': 'call', 'params': {}},
      );
    } catch (_) {}
    await _storage.delete(key: AppConstants.tokenKey);
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
