import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';

  print('🔍 Testing API Upload Functionality...\n');

  try {
    // Test 1: Get all products first
    print('📋 Test 1: Getting all products...');
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body:');
    print(response.body);
    print('\n' + '='*50 + '\n');

    // Test 2: Test multipart upload (without actual file)
    print('📤 Test 2: Testing multipart upload structure...');

    // Create a test file for upload simulation
    final testFile = File('test_upload.txt');
    await testFile.writeAsString('This is a test file for upload');

    final request = http.MultipartRequest('POST', Uri.parse(baseUrl));

    // Add form fields
    request.fields['name'] = 'Test Product Upload';
    request.fields['description'] = 'Test description for upload';
    request.fields['price'] = '99.99';

    // Add file
    request.files.add(
      await http.MultipartFile.fromPath('image', testFile.path),
    );

    print('Request fields: ${request.fields}');
    print('Request files: ${request.files.length}');

    final uploadResponse = await request.send();
    final responseBody = await uploadResponse.stream.bytesToString();

    print('Upload Status Code: ${uploadResponse.statusCode}');
    print('Upload Response Body:');
    print(responseBody);

    // Clean up test file
    await testFile.delete();

  } catch (e) {
    print('❌ Error testing API upload: $e');
  }
}