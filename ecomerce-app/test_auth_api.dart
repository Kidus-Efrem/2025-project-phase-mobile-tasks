import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v2';

  print('🔍 Testing Authentication API Endpoints...\n');

  try {
    // Test GET /users/me (should be protected; expect 401 without token)
    print('👤 Test: GET /users/me (no token)');
    final meResponse = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {'Content-Type': 'application/json'},
    );
    print('Status: ${meResponse.statusCode}');
    print('Body: ${meResponse.body}\n');

    // Test signup endpoint
    print('📝 Test: POST /auth/register');
    final signupResponse = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': 'test_${DateTime.now().millisecondsSinceEpoch}@example.com',
        'password': 'password123',
        'name': 'Test User',
      }),
    );
    print('Status: ${signupResponse.statusCode}');
    print('Body: ${signupResponse.body}\n');

    // Test login endpoint
    print('🔑 Test: POST /auth/login');
    final signinResponse = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': 'test@example.com',
        'password': 'password123',
      }),
    );
    print('Status: ${signinResponse.statusCode}');
    print('Body: ${signinResponse.body}\n');

  } catch (e) {
    print('❌ Error testing API: $e');
  }
}
