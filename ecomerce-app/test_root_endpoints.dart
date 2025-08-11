import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com';

  print('🔍 Testing Root Endpoints...\n');

  final rootEndpoints = [
    '/',
    '/api',
    '/api/v1',
    '/api/v2',
    '/health',
    '/status',
    '/docs',
    '/swagger',
  ];

  for (final endpoint in rootEndpoints) {
    try {
      print('🔍 Testing: $endpoint');

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
      print('-' * 50);

    } catch (e) {
      print('Error: $e');
      print('-' * 50);
    }
  }
}
