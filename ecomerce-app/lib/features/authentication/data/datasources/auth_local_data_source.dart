import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();
  Future<bool> hasCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await sharedPreferences.setString(cachedUserKey, userJson);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = sharedPreferences.getString(cachedUserKey);
    if (userJson != null) {
      try {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      } catch (e) {
        // If JSON parsing fails, clear the cached data
        await clearCachedUser();
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearCachedUser() async {
    print('🚀 AuthLocalDataSource - clearCachedUser called');
    print('🚀 AuthLocalDataSource - Removing key: $cachedUserKey');
    
    final hadCachedUser = await hasCachedUser();
    print('🚀 AuthLocalDataSource - Had cached user before clearing: $hadCachedUser');
    
    await sharedPreferences.remove(cachedUserKey);
    
    final hasCachedUserAfter = await hasCachedUser();
    print('🚀 AuthLocalDataSource - Has cached user after clearing: $hasCachedUserAfter');
    print('✅ AuthLocalDataSource - Cache cleared successfully');
  }

  @override
  Future<bool> hasCachedUser() async {
    return sharedPreferences.containsKey(cachedUserKey);
  }
}
