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
  final String? token;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.token,
  });

  AuthState copyWith({bool? isAuthenticated, bool? isLoading, String? error, String? token}) =>
      AuthState(
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        token: token ?? this.token,
      );
}

class AuthNotifier extends Notifier<AuthState> {
  static const _storage = FlutterSecureStorage();

  @override
  AuthState build() => const AuthState();

  Future<void> checkAuth() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    if (token != null) {
      state = state.copyWith(isAuthenticated: true, token: token);
    }
  }

  Future<ApiResult<void>> login(String login, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiClient.instance.post(
        AppConstants.loginEndpoint,
        data: {'login': login, 'password': password},
      );
      final token = response.data['token'] as String?;
      if (token == null) {
        state = state.copyWith(isLoading: false, error: 'invalid_credentials');
        return const ApiError('invalid_credentials');
      }
      await _storage.write(key: AppConstants.tokenKey, value: token);
      state = state.copyWith(isAuthenticated: true, isLoading: false, token: token);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      final msg = e.response?.statusCode == 401 ? 'invalid_credentials' : 'network_error';
      state = state.copyWith(isLoading: false, error: msg);
      return ApiError(msg, statusCode: e.response?.statusCode);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.tokenKey);
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
