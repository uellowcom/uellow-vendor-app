import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class ApiClient {
  static Dio? _dio;
  static const _storage = FlutterSecureStorage();

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: Duration(seconds: AppConstants.connectTimeout),
        receiveTimeout: Duration(seconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // مهم: السماح بإرسال cookies مع كل طلب (Odoo session)
        extra: {'withCredentials': true},
      ),
    );

    // Cookie manager للـ Odoo session
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // أضف session_id إذا موجود
          final uid = await _storage.read(key: AppConstants.tokenKey);
          if (uid != null) {
            options.headers['X-Vendor-UID'] = uid;
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _storage.delete(key: AppConstants.tokenKey);
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  // Reset client (after logout)
  static void reset() {
    _dio = null;
  }
}
