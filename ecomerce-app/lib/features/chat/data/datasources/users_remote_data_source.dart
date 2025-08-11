import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_config.dart';
import '../models/user_model.dart';

abstract class UsersRemoteDataSource {
  Future<List<UserModel>> getUsers(String token);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final http.Client client;

  UsersRemoteDataSourceImpl({required this.client});

  @override
  Future<List<UserModel>> getUsers(String token) async {
    print('════════════════════════════════════════');
    print('👥 GET USERS REQUEST');
    print('════════════════════════════════════════');
    print('URL: ${AppConfig.apiBaseUrl}');
    print('Headers: {\'Content-Type\': \'application/json\', \'Authorization\': \'Bearer $token\'}');
    print('════════════════════════════════════════');

    try {
      final response = await client.get(
        Uri.parse('${AppConfig.apiBaseUrl}/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConfig.apiTimeout);

      print('════════════════════════════════════════');
      print('👥 GET USERS RESPONSE');
      print('════════════════════════════════════════');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('════════════════════════════════════════');

      if (response.statusCode == 200) {
        print('✅ SUCCESS: Users loaded successfully');
        final decoded = json.decode(response.body);
        print('🔍 Raw decoded response: $decoded');
        final List<dynamic> jsonList = decoded['data'] ?? [];
        print('🔍 Users list from data: $jsonList');
        final users = jsonList.map((json) => UserModel.fromJson(json)).toList();
        print('📊 Loaded ${users.length} users');
        // Debug: print each user's name
        for (int i = 0; i < users.length; i++) {
          print('🔍 User $i: "${users[i].name}" (${users[i].email})');
        }
        return users;
      } else if (response.statusCode == 401) {
        print('❌ ERROR: 401 - Unauthorized (Invalid or expired token)');
        throw Exception('Unauthorized: Invalid or expired token');
      } else if (response.statusCode == 403) {
        print('❌ ERROR: 403 - Forbidden (Access denied)');
        throw Exception('Forbidden: Access denied');
      } else if (response.statusCode == 404) {
        print('❌ ERROR: 404 - Not Found (Users endpoint not found)');
        throw Exception('Not Found: Users endpoint not found');
      } else if (response.statusCode == 500) {
        print('❌ ERROR: 500 - Internal Server Error');
        throw Exception('Internal Server Error: Server is experiencing issues');
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        print('❌ ERROR: ${response.statusCode} - Client Error');
        throw Exception('Client Error ${response.statusCode}: ${response.body}');
      } else if (response.statusCode >= 500) {
        print('❌ ERROR: ${response.statusCode} - Server Error');
        throw Exception('Server Error ${response.statusCode}: ${response.body}');
      } else {
        print('❌ ERROR: Unexpected status code ${response.statusCode}');
        throw Exception('Failed to load users: Unexpected status code ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        print('❌ ERROR: Request timeout after ${AppConfig.apiTimeout.inSeconds} seconds');
        throw Exception('Request timeout: Server is not responding');
      } else if (e.toString().contains('SocketException')) {
        print('❌ ERROR: Network connection failed');
        throw Exception('Network connection failed: Please check your internet connection');
      } else {
        print('❌ ERROR: Unexpected error: $e');
        throw Exception('Failed to load users: $e');
      }
    }
  }
}

