import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../error/exception.dart';

/// Reusable HTTP client helper to eliminate code duplication
/// Provides common HTTP methods with proper error handling
class HttpClientHelper {
  final http.Client client;

  HttpClientHelper({required this.client});

  /// Common headers used across all requests
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };

  /// Unified GET request handler
  Future<http.Response> get(Uri url) async {
    final response = await client.get(url, headers: _defaultHeaders);
    _validateResponse(response, [200]);
    return response;
  }

  /// Unified PUT request handler
  Future<http.Response> put(Uri url, Map<String, dynamic> body) async {
    final response = await client.put(
      url,
      headers: _defaultHeaders,
      body: json.encode(body),
    );
    _validateResponse(response, [200]);
    return response;
  }

  /// Unified DELETE request handler
  Future<http.Response> delete(Uri url) async {
    final response = await client.delete(url, headers: _defaultHeaders);
    _validateResponse(response, [200]);
    return response;
  }

  /// Multipart POST request handler for file uploads
  Future<http.Response> postMultipart(
    Uri url,
    Map<String, String> fields,
    String filePath,
    String fileFieldName,
  ) async {
    final request = http.MultipartRequest('POST', url);

    // Add form fields
    request.fields.addAll(fields);

    // Add file
    final imageFile = File(filePath);
    if (!await imageFile.exists()) {
      throw Exception('File not found at path: $filePath');
    }

    request.files.add(
      await http.MultipartFile.fromPath(fileFieldName, imageFile.path),
    );

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    _validateResponse(response, [201]);
    return response;
  }

  /// Validates HTTP response and throws appropriate exceptions
  void _validateResponse(
    http.Response response,
    List<int> expectedStatusCodes,
  ) {
    if (!expectedStatusCodes.contains(response.statusCode)) {
      throw ServerException();
    }
  }

  /// Helper method to parse JSON response
  static Map<String, dynamic> parseJsonResponse(http.Response response) {
    return json.decode(response.body) as Map<String, dynamic>;
  }

  /// Helper method to parse JSON list from response
  static List<dynamic> parseJsonListFromResponse(
    http.Response response,
    String dataKey,
  ) {
    final Map<String, dynamic> decoded = parseJsonResponse(response);
    return decoded[dataKey] as List<dynamic>;
  }
}
