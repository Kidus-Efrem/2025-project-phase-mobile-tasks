import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';

  print('🔍 Testing API Connection...\n');

  try {
    // Test 1: Get all products
    print('📋 Test 1: Getting all products...');
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body:');
    print(response.body);
    print('\n' + '='*50 + '\n');

    // Test 2: Get a specific product (if we have an ID)
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] is List && (data['data'] as List).isNotEmpty) {
        final firstProduct = (data['data'] as List).first;
        final productId = firstProduct['id'];

        print('📦 Test 2: Getting product with ID: $productId...');
        final singleResponse = await http.get(
          Uri.parse('$baseUrl/$productId'),
          headers: {'Content-Type': 'application/json'},
        );

        print('Status Code: ${singleResponse.statusCode}');
        print('Response Body:');
        print(singleResponse.body);
        print('\n' + '='*50 + '\n');
      }
    }

  } catch (e) {
    print('❌ Error testing API: $e');
  }
}