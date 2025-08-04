/// Application constants to centralize hardcoded values
/// Improves maintainability and reduces code duplication
class AppConstants {
  // API Constants
  static const String baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';
  static const String dataKey = 'data';

  // HTTP Constants
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };
  static const int successStatusCode = 200;
  static const int createdStatusCode = 201;

  // Cache Constants
  static const String cachedProductListKey = 'CACHED_PRODUCT_LIST';

  // File Upload Constants
  static const String imageFieldName = 'image';
  static const String nameFieldName = 'name';
  static const String descriptionFieldName = 'description';
  static const String priceFieldName = 'price';

  // Error Messages
  static const String fileNotFoundMessage = 'File not found at path:';
  static const String serverErrorMessage = 'Server Error';
  static const String notFoundMessage = 'Not Found';

  // Test Constants
  static const String testProductId = '1';
  static const String testProductName = 'Test Product';
  static const String testProductImageUrl = 'test_image.jpg';
  static const double testProductPrice = 99.99;
  static const String testProductDescription = 'Test description';
}