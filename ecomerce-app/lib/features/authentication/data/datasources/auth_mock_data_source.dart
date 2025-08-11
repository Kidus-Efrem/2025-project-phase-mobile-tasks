import 'dart:async';
import '../models/user_model.dart';

abstract class AuthMockDataSource {
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel> signIn({
    required String email,
    required String password,
  });
}

class AuthMockDataSourceImpl implements AuthMockDataSource {
  // Simulate network delay
  static const Duration _delay = Duration(seconds: 2);

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future.delayed(_delay);

    // Simulate successful signup
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_delay);

    // Simulate successful signin
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: 'Mock User',
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
