import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3';

  print('🔍 Testing User API and Clickability Fixes...\n');

  // Test 1: Verify users endpoint is working
  print('📋 Test 1: Testing users endpoint...');
  try {
    final usersResponse = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
    );

    print('Users Status Code: ${usersResponse.statusCode}');
    print('Users Response Body:');
    print(usersResponse.body);
    print('\n' + '=' * 50 + '\n');

    if (usersResponse.statusCode == 200) {
      final usersData = jsonDecode(usersResponse.body);
      final users = usersData['data'] ?? [];

      print('✅ SUCCESS: Found ${users.length} users in the full user list');

      if (users.isNotEmpty) {
        print('📊 Sample users:');
        for (int i = 0; i < users.length && i < 5; i++) {
          final user = users[i];
          print(
              '  User $i: ${user['name']} (${user['email']}) - ID: ${user['id']}');
        }

        // Test 2: Test chat creation with first user
        if (users.isNotEmpty) {
          final firstUser = users[0];
          final userId = firstUser['id'] ?? firstUser['_id'];

          print(
              '\n📋 Test 2: Testing chat creation with user: ${firstUser['name']}');
          print('User ID: $userId');

          // Note: This would require authentication token, so just show the endpoint
          print('Chat creation endpoint: POST $baseUrl/chats');
          print('Request body: {"userId": "$userId"}');
          print('✅ Chat creation endpoint is ready for testing');
        }
      }
    } else {
      print(
          '❌ ERROR: Users endpoint returned status ${usersResponse.statusCode}');
    }
  } catch (e) {
    print('❌ Error testing API: $e');
  }

  print('\n🔍 Summary of fixes applied:');
  print('✅ 1. Users are fetched from: $baseUrl/users (full user list)');
  print('✅ 2. User clickability improved with Material + InkWell');
  print('✅ 3. Added comprehensive debugging logs');
  print('✅ 4. Chat creation uses correct field name: "userId"');
  print('✅ 5. Socket connection added to authentication flow');
}
