import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com';

  print('🔍 Testing Product and Auth Endpoints...\n');

  // Test product endpoints
  final productEndpoints = [
    '/api/v2/products',
    '/api/v1/products',
    '/api/products',
    '/products',
  ];

  for (final endpoint in productEndpoints) {
    try {
      print('🔍 Testing GET: $endpoint');

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Status: ${response.statusCode}');
      print('Response: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');
      print('-' * 50);

    } catch (e) {
      print('Error: $e');
      print('-' * 50);
    }
  }

  // Test different auth endpoint patterns
  final authEndpoints = [
    '/api/v2/users/signup',
    '/api/v2/users/signin',
    '/api/v2/user/signup',
    '/api/v2/user/signin',
    '/api/v1/users/signup',
    '/api/v1/users/signin',
    '/api/v1/user/signup',
    '/api/v1/user/signin',
    '/api/users/signup',
    '/api/users/signin',
    '/api/user/signup',
    '/api/user/signin',
    '/users/signup',
    '/users/signin',
    '/user/signup',
    '/user/signin',
  ];

  print('\n🔍 Testing Auth Endpoints...\n');

  for (final endpoint in authEndpoints) {
    try {
      print('🔍 Testing POST: $endpoint');

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': 'test@example.com',
          'password': 'password123',
          'name': 'Test User',
        }),
      );

      print('Status: ${response.statusCode}');
      print('Response: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');
      print('-' * 50);

    } catch (e) {
      print('Error: $e');
      print('-' * 50);
    }
  }
}
