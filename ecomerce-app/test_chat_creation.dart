import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3';
  
  print('🔍 Testing Chat Creation API...\n');

  // First, let's get a list of users to get a valid user ID
  print('📋 Step 1: Getting users list...');
  
  try {
    final usersResponse = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
    );

    print('Users Status Code: ${usersResponse.statusCode}');
    print('Users Response Body:');
    print(usersResponse.body);
    print('\n' + '='*50 + '\n');

    if (usersResponse.statusCode == 200) {
      final usersData = jsonDecode(usersResponse.body);
      final users = usersData['data'] ?? [];
      
      if (users.isNotEmpty) {
        final firstUser = users[0];
        final userId = firstUser['id'] ?? firstUser['_id'];
        
        print('🔍 Found user: ${firstUser['name']} with ID: $userId');
        print('🔍 User object: $firstUser');
        
        // Test different field names for creating a chat
        final testCases = [
          {'userId': userId},
          {'_id': userId},
          {'user_id': userId},
          {'id': userId},
        ];
        
        for (final testCase in testCases) {
          print('\n🔍 Testing chat creation with: $testCase');
          
          try {
            final chatResponse = await http.post(
              Uri.parse('$baseUrl/chats'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(testCase),
            );

            print('Chat Creation Status Code: ${chatResponse.statusCode}');
            print('Chat Creation Response Body:');
            print(chatResponse.body);
            print('-' * 50);
            
          } catch (e) {
            print('Error: $e');
            print('-' * 50);
          }
        }
      } else {
        print('❌ No users found in the response');
      }
    }
    
  } catch (e) {
    print('❌ Error testing API: $e');
  }
}
