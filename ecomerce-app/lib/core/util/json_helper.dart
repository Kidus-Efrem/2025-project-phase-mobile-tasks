import 'dart:convert';

/// Reusable JSON helper to eliminate code duplication
/// Provides common JSON encoding/decoding operations
class JsonHelper {
  /// Safely decode JSON string to Map
  static Map<String, dynamic>? safeDecode(String? jsonString) {
    if (jsonString == null) return null;

    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Safely decode JSON string to List
  static List<dynamic>? safeDecodeList(String? jsonString) {
    if (jsonString == null) return null;

    try {
      return json.decode(jsonString) as List<dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Encode object to JSON string
  static String encode(dynamic object) {
    return json.encode(object);
  }

  /// Encode list of objects to JSON string
  static String encodeList(List<dynamic> objects) {
    return json.encode(objects);
  }

  /// Extract data from JSON response
  static Map<String, dynamic> extractData(Map<String, dynamic> json, String key) {
    return json[key] as Map<String, dynamic>;
  }

  /// Extract list from JSON response
  static List<dynamic> extractList(Map<String, dynamic> json, String key) {
    return json[key] as List<dynamic>;
  }
}