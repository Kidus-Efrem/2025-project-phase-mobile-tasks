import 'dart:convert';
import 'dart:io';

void main() async {
  const String baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3';
  
  print('🔍 Testing Chat Creation API Response Structure...\n');

  try {
    // First, let's get a list of users to get a valid user ID
    print('📋 Step 1: Getting users list...');
    
    final usersRequest = await HttpClient().getUrl(Uri.parse('$baseUrl/users'));
    usersRequest.headers.set('Content-Type', 'application/json');
    final usersResponse = await usersRequest.close();
    final usersBody = await usersResponse.transform(utf8.decoder).join();

    print('Users Status Code: ${usersResponse.statusCode}');
    print('Users Response Body:');
    print(usersBody);
    print('\n' + '='*50 + '\n');

    if (usersResponse.statusCode == 200) {
      final usersData = jsonDecode(usersBody);
      final users = usersData['data'] ?? [];
      
      if (users.isNotEmpty) {
        final firstUser = users[0];
        final userId = firstUser['id'] ?? firstUser['_id'];
        
        print('🔍 Found user: ${firstUser['name']} with ID: $userId');
        print('🔍 User object: $firstUser');
        
        // Test chat creation
        print('\n🔍 Testing chat creation with userId: $userId');
        
        final chatRequest = await HttpClient().postUrl(Uri.parse('$baseUrl/chats'));
        chatRequest.headers.set('Content-Type', 'application/json');
        chatRequest.write(jsonEncode({'userId': userId}));
        final chatResponse = await chatRequest.close();
        final chatBody = await chatResponse.transform(utf8.decoder).join();

        print('Chat Creation Status Code: ${chatResponse.statusCode}');
        print('Chat Creation Response Body:');
        print(chatBody);
        print('-' * 50);
        
        if (chatResponse.statusCode == 201 || chatResponse.statusCode == 200) {
          final chatData = jsonDecode(chatBody);
          print('\n🔍 Parsed Chat Response:');
          print('Raw JSON: $chatData');
          print('Keys in response: ${chatData.keys.toList()}');
          
          // Check for different possible ID fields
          final possibleIdFields = ['id', '_id', 'chatId', 'chat_id'];
          for (final field in possibleIdFields) {
            if (chatData.containsKey(field)) {
              print('✅ Found ID field "$field": ${chatData[field]}');
            }
          }
          
          // Check if there's a nested structure
          if (chatData.containsKey('data')) {
            print('✅ Found "data" field: ${chatData['data']}');
            final data = chatData['data'];
            if (data is Map) {
              print('✅ "data" is a Map with keys: ${data.keys.toList()}');
              for (final field in possibleIdFields) {
                if (data.containsKey(field)) {
                  print('✅ Found ID field "$field" in data: ${data[field]}');
                }
              }
            }
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
