import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com';

  print('🔍 Fetching API Documentation...\n');

  try {
    // Get the docs page
    final docsResponse = await http.get(
      Uri.parse('$baseUrl/docs'),
      headers: {'Content-Type': 'text/html'},
    );

    print('Docs Status: ${docsResponse.statusCode}');
    print('Docs Content Length: ${docsResponse.body.length}');

    // Look for API spec file
    final specResponse = await http.get(
      Uri.parse('$baseUrl/docs/swagger-ui-init.js'),
      headers: {'Content-Type': 'application/javascript'},
    );

    print('Spec Status: ${specResponse.statusCode}');
    print('Spec Content: ${specResponse.body.substring(0, specResponse.body.length > 500 ? 500 : specResponse.body.length)}...');

    // Try to get the OpenAPI spec
    final openApiResponse = await http.get(
      Uri.parse('$baseUrl/docs/swagger.json'),
      headers: {'Content-Type': 'application/json'},
    );

    print('OpenAPI Status: ${openApiResponse.statusCode}');
    if (openApiResponse.statusCode == 200) {
      print('OpenAPI Content: ${openApiResponse.body}');
    }

  } catch (e) {
    print('Error: $e');
  }
}
