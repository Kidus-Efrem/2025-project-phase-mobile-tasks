import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com';

  print('🔍 Testing Different API Endpoint Variations...\n');

  final endpoints = [
    '/api/v2/auth',
    '/api/v2/auth/signup',
    '/api/v2/auth/signin',
    '/api/v1/auth',
    '/api/v1/auth/signup',
    '/api/v1/auth/signin',
    '/auth',
    '/auth/signup',
    '/auth/signin',
    '/api/auth',
    '/api/auth/signup',
    '/api/auth/signin',
  ];

  for (final endpoint in endpoints) {
    try {
      print('🔍 Testing: $endpoint');

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Status: ${response.statusCode}');
      print('Response: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');
      print('-' * 50);

    } catch (e) {
      print('Error: $e');
      print('-' * 50);
    }
  }

  // Test POST requests for auth endpoints
  print('\n🔍 Testing POST requests for auth endpoints...\n');

  final postEndpoints = [
    '/api/v2/auth/signup',
    '/api/v2/auth/signin',
    '/api/v1/auth/signup',
    '/api/v1/auth/signin',
    '/auth/signup',
    '/auth/signin',
    '/api/auth/signup',
    '/api/auth/signin',
  ];

  for (final endpoint in postEndpoints) {
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
      print('Response: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');
      print('-' * 50);

    } catch (e) {
      print('Error: $e');
      print('-' * 50);
    }
  }
}
