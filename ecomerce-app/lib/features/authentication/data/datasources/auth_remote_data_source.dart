import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
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

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  // Updated base URL per provided endpoints
  static const String baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3';
  static const Duration timeout = Duration(seconds: 30);

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
              'name': name,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'] ?? jsonResponse; // fallback if no wrapper
        final user = UserModel.fromJson(Map<String, dynamic>.from(data));
        // Ensure token fallback: some APIs place token at top-level
        final token = (jsonResponse['access_token'] ?? jsonResponse['accessToken'] ?? jsonResponse['token'])?.toString();
        if (user.token == null && token != null) {
          return UserModel(
            id: user.id,
            email: user.email,
            name: user.name,
            token: token,
          );
        }
        return user;
      } else {
        throw Exception('Failed to sign up: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network and try again.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } on FormatException {
      throw Exception('Invalid response from server. Please try again.');
    }
  }

   @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Print request details before sending
      print("════════════ SIGNIN REQUEST ════════════");
      print("URL: $baseUrl/auth/login");
      print("Headers: {'Content-Type': 'application/json'}");
      print("Body: ${jsonEncode({'email': email, 'password': password})}");
      print("════════════════════════════════════════");

      final response = await client
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(timeout);

      // 2. Print raw response details
      print("════════════ SIGNIN RESPONSE ═══════════");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("════════════════════════════════════════");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // 3. Print parsed JSON before conversion
        print("Parsed JSON: $jsonResponse");

        final data = jsonResponse['data'] ?? jsonResponse;
        final user = UserModel.fromJson(Map<String, dynamic>.from(data));
        // Ensure token fallback if present at top-level or data level
        final token = (jsonResponse['access_token'] ?? jsonResponse['accessToken'] ?? jsonResponse['token'] ?? data['access_token'] ?? data['accessToken'] ?? data['token'])?.toString();
        if (user.token == null && token != null) {
          return UserModel(id: user.id, email: user.email, name: user.name, token: token);
        }
        return user;
      } else {
        // 4. Explicit error logging
        print("❗ SIGNIN ERROR: ${response.statusCode} - ${response.body}");
        throw Exception('Failed to sign in: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      print("❗ NETWORK ERROR: No internet connection");
      throw Exception('No internet connection. Please check your network and try again.');
    } on TimeoutException {
      print("❗ TIMEOUT ERROR: Request timed out");
      throw Exception('Request timed out. Please try again.');
    } on FormatException catch (e) {
      print("❗ FORMAT ERROR: $e");
      throw Exception('Invalid response from server. Please try again.');
    } catch (e) {
      // 5. Catch-all for unexpected errors
      print("❗ UNEXPECTED ERROR: $e");
      rethrow;
    }
  }}
