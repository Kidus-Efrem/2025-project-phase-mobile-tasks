import 'dart:async';
import 'lib/features/authentication/data/datasources/auth_mock_data_source.dart';

void main() async {
  print('🧪 Testing Mock Authentication...\n');

  final mockDataSource = AuthMockDataSourceImpl();

  try {
    // Test signup
    print('📝 Testing mock signup...');
    final signupResult = await mockDataSource.signUp(
      email: 'test@example.com',
      password: 'password123',
      name: 'Test User',
    );
    print('✅ Signup successful:');
    print('  ID: ${signupResult.id}');
    print('  Email: ${signupResult.email}');
    print('  Name: ${signupResult.name}');
    print('  Token: ${signupResult.token}');
    print('');

    // Test signin
    print('🔑 Testing mock signin...');
    final signinResult = await mockDataSource.signIn(
      email: 'test@example.com',
      password: 'password123',
    );
    print('✅ Signin successful:');
    print('  ID: ${signinResult.id}');
    print('  Email: ${signinResult.email}');
    print('  Name: ${signinResult.name}');
    print('  Token: ${signinResult.token}');

  } catch (e) {
    print('❌ Error: $e');
  }
}
