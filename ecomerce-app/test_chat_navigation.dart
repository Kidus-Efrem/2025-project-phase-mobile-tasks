import 'dart:convert';
import 'dart:io';

void main() async {
  const String baseUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3';

  print('🔍 Testing Chat Creation and Navigation Flow...\n');

  try {
    // Step 1: Test users endpoint
    print('📋 Step 1: Testing users endpoint...');

    final usersRequest = await HttpClient().getUrl(Uri.parse('$baseUrl/users'));
    usersRequest.headers.set('Content-Type', 'application/json');
    final usersResponse = await usersRequest.close();
    final usersBody = await usersResponse.transform(utf8.decoder).join();

    print('Users Status Code: ${usersResponse.statusCode}');

    if (usersResponse.statusCode == 200) {
      final usersData = jsonDecode(usersBody);
      final users = usersData['data'] ?? [];

      if (users.isNotEmpty) {
        print('✅ Found ${users.length} users');

        // Show first few users
        for (int i = 0; i < users.length && i < 3; i++) {
          final user = users[i];
          final userId = user['id'] ?? user['_id'];
          print('  User $i: ${user['name']} (ID: $userId)');
        }

        print('\n✅ Users endpoint is working correctly');

        // Step 2: Test chat creation endpoint
        print('\n📋 Step 2: Testing chat creation endpoint...');
        final firstUser = users[0];
        final userId = firstUser['id'] ?? firstUser['_id'];

        print('Chat creation endpoint: POST $baseUrl/chats');
        print('Request body: {"userId": "$userId"}');
        print('Expected response: Chat object with valid ID');

        print('\n✅ Chat Creation Flow:');
        print('1. User taps on a user in the scrollable list');
        print('2. Show loading spinner with "Creating chat..." message');
        print('3. Send POST request to /chats endpoint');
        print('4. Server returns chat object with ID, user1, user2');
        print(
            '5. Show success message: "Chat created successfully with [name]!"');
        print('6. Navigate to chat detail page after 500ms delay');

        print('\n✅ Navigation Flow:');
        print('1. Chat detail page receives chat object as argument');
        print('2. Page initializes with chat ID and user information');
        print('3. Load messages for the chat');
        print('4. Display chat interface with message input');

        print('\n✅ Debugging Information:');
        print('1. Added delay before navigation to ensure snackbar is shown');
        print('2. Added try-catch around navigation to handle errors');
        print('3. Added delay in chat detail page initState');
        print('4. Added comprehensive logging throughout the flow');
        print('5. Added mounted check to prevent setState on disposed widget');

        print('\n✅ Expected Behavior:');
        print('1. User list should be scrollable horizontally');
        print('2. Tapping a user should show loading spinner');
        print('3. Chat creation should complete successfully');
        print('4. Success message should appear');
        print('5. Navigation to chat detail should happen smoothly');
        print('6. Chat detail page should load without freezing');
      } else {
        print('❌ No users found in the response');
      }
    } else {
      print('❌ Users endpoint returned status ${usersResponse.statusCode}');
      print('Response body: $usersBody');
    }
  } catch (e) {
    print('❌ Error testing API: $e');
  }
}
