import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2';

  print('🔍 Testing New Authentication API Endpoints...\n');

  try {
    // Test 1: Check if the API is accessible
    print('📋 Test 1: Checking API accessibility...');
    final healthResponse = await http.get(
      Uri.parse('$baseUrl/auth'),
      headers: {'Content-Type': 'application/json'},
    );

    print('Health Check Status Code: ${healthResponse.statusCode}');
    print('Health Check Response Body:');
    print(healthResponse.body);
    print('\n' + '='*50 + '\n');

    // Test 2: Test signup endpoint
    print('📝 Test 2: Testing signup endpoint...');
    final signupResponse = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': 'test@example.com',
        'password': 'password123',
        'name': 'Test User',
      }),
    );

    print('Signup Status Code: ${signupResponse.statusCode}');
    print('Signup Response Body:');
    print(signupResponse.body);
    print('\n' + '='*50 + '\n');

    // Test 3: Test signin endpoint
    print('🔑 Test 3: Testing signin endpoint...');
    final signinResponse = await http.post(
      Uri.parse('$baseUrl/auth/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': 'test@example.com',
        'password': 'password123',
      }),
    );

    print('Signin Status Code: ${signinResponse.statusCode}');
    print('Signin Response Body:');
    print(signinResponse.body);

  } catch (e) {
    print('❌ Error testing API: $e');
  }
}
