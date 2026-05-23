class AppConstants {
  AppConstants._();

  static const String appName = 'Uellow Vendor';
  static const String baseUrl = 'https://uellow.com';
  static const String apiBaseUrl = '$baseUrl/api/vendor';
  static const String tokenKey = 'vendor_auth_token';
  static const String langKey = 'app_language';
  static const String themeKey = 'app_theme';

  // API endpoints
  static const String loginEndpoint = '/api/vendor/login';
  static const String dashboardEndpoint = '/api/vendor/dashboard';
  static const String ordersEndpoint = '/api/vendor/orders';
  static const String stockEndpoint = '/api/vendor/stock';
  static const String walletEndpoint = '/api/vendor/wallet';

  // Pagination
  static const int pageSize = 20;

  // Timeouts
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
}
