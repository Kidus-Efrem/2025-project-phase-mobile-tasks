class AppConfig {
  // Set this to true to use mock API when real API is down
  static const bool useMockApi = false;

  // API Configuration
  static const String apiBaseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/users';
  static const String socketBaseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // App Configuration
  static const String appName = 'ECOM';
  static const String appVersion = '1.0.0';
}
