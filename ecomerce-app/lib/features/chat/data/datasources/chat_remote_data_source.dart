import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_config.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats(String token);
  Future<List<MessageModel>> getMessages(String chatId, String token);
  Future<MessageModel> sendMessage(
      String chatId, String content, String type, String token);
  Future<ChatModel> createChat(String userId, String token);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;

  ChatRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ChatModel>> getChats(String token) async {
    print('════════════════════════════════════════');
    print('📱 GET CHATS REQUEST');
    print('════════════════════════════════════════');
    print('URL: ${AppConfig.apiBaseUrl}/chats');
    print(
        'Headers: {\'Content-Type\': \'application/json\', \'Authorization\': \'Bearer $token\'}');
    print('════════════════════════════════════════');

    try {
      final response = await client.get(
        Uri.parse('${AppConfig.apiBaseUrl}/chats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConfig.apiTimeout);

      print('════════════════════════════════════════');
      print('📱 GET CHATS RESPONSE');
      print('════════════════════════════════════════');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('════════════════════════════════════════');

      if (response.statusCode == 200) {
        print('✅ SUCCESS: Chats loaded successfully');
        final decoded = json.decode(response.body);
        print('🔍 Raw decoded response: $decoded');
        final List<dynamic> jsonList = decoded['data'] ?? [];
        print('🔍 Chat list from data: $jsonList');
        final chats = jsonList.map((json) => ChatModel.fromJson(json)).toList();
        print('📊 Loaded ${chats.length} chats');
        // Debug: print each chat's ID
        for (int i = 0; i < chats.length; i++) {
          print('🔍 Chat $i ID: "${chats[i].id}"');
        }
        return chats;
      } else if (response.statusCode == 401) {
        print('❌ ERROR: 401 - Unauthorized (Invalid or expired token)');
        throw Exception('Unauthorized: Invalid or expired token');
      } else if (response.statusCode == 403) {
        print('❌ ERROR: 403 - Forbidden (Access denied)');
        throw Exception('Forbidden: Access denied');
      } else if (response.statusCode == 404) {
        print('❌ ERROR: 404 - Not Found (Chats endpoint not found)');
        throw Exception('Not Found: Chats endpoint not found');
      } else if (response.statusCode == 500) {
        print('❌ ERROR: 500 - Internal Server Error');
        throw Exception('Internal Server Error: Server is experiencing issues');
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        print('❌ ERROR: ${response.statusCode} - Client Error');
        throw Exception(
            'Client Error ${response.statusCode}: ${response.body}');
      } else if (response.statusCode >= 500) {
        print('❌ ERROR: ${response.statusCode} - Server Error');
        throw Exception(
            'Server Error ${response.statusCode}: ${response.body}');
      } else {
        print('❌ ERROR: Unexpected status code ${response.statusCode}');
        throw Exception(
            'Failed to load chats: Unexpected status code ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        print(
            '❌ ERROR: Request timeout after ${AppConfig.apiTimeout.inSeconds} seconds');
        throw Exception('Request timeout: Server is not responding');
      } else if (e.toString().contains('SocketException')) {
        print('❌ ERROR: Network connection failed');
        throw Exception(
            'Network connection failed: Please check your internet connection');
      } else {
        print('❌ ERROR: Unexpected error: $e');
        throw Exception('Failed to load chats: $e');
      }
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId, String token) async {
    // token =
    print('════════════════════════════════════════');
    print('💬 GET MESSAGES REQUEST');
    print('════════════════════════════════════════');
    print('URL: ${AppConfig.apiBaseUrl}/chats/$chatId/messages');
    print('Chat ID: $chatId');
    print(
        'Headers: {\'Content-Type\': \'application/json\', \'Authorization\': \'Bearer $token\'}');
    print('════════════════════════════════════════');

    try {
      final response = await client.get(
        Uri.parse('${AppConfig.apiBaseUrl}/chats/$chatId/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(AppConfig.apiTimeout);

      print('════════════════════════════════════════');
      print('💬 GET MESSAGES RESPONSE');
      print('════════════════════════════════════════');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('════════════════════════════════════════');

      if (response.statusCode == 200) {
        print('✅ SUCCESS: Messages loaded successfully for chat $chatId');

        final decoded = json.decode(response.body);
        final List<dynamic> jsonList = decoded['data'] ?? [];
        // final chats = jsonList.map((json) => ChatModel.fromJson(json)).toList();

        // final List<dynamic> jsonList = json.decode(response.body);
        final messages =
            jsonList.map((json) => MessageModel.fromJson(json)).toList();
        print('📊 Loaded ${messages.length} messages');
        return messages;
      } else if (response.statusCode == 401) {
        print('❌ ERROR: 401 - Unauthorized (Invalid or expired token)');
        throw Exception('Unauthorized: Invalid or expired token');
      } else if (response.statusCode == 403) {
        print('❌ ERROR: 403 - Forbidden (Access denied to this chat)');
        throw Exception('Forbidden: Access denied to this chat');
      } else if (response.statusCode == 404) {
        print('❌ ERROR: 404 - Chat not found');
        throw Exception('Chat not found: The specified chat does not exist');
      } else if (response.statusCode == 500) {
        print('❌ ERROR: 500 - Internal Server Error');
        throw Exception('Internal Server Error: Server is experiencing issues');
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        print('❌ ERROR: ${response.statusCode} - Client Error');
        throw Exception(
            'Client Error ${response.statusCode}: ${response.body}');
      } else if (response.statusCode >= 500) {
        print('❌ ERROR: ${response.statusCode} - Server Error');
        throw Exception(
            'Server Error ${response.statusCode}: ${response.body}');
      } else {
        print('❌ ERROR: Unexpected status code ${response.statusCode}');
        throw Exception(
            'Failed to load messages: Unexpected status code ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        print(
            '❌ ERROR: Request timeout after ${AppConfig.apiTimeout.inSeconds} seconds');
        throw Exception('Request timeout: Server is not responding');
      } else if (e.toString().contains('SocketException')) {
        print('❌ ERROR: Network connection failed');
        throw Exception(
            'Network connection failed: Please check your internet connection');
      } else {
        print('❌ ERROR: Unexpected error: $e');
        throw Exception('Failed to load messages: $e');
      }
    }
  }

  @override
  Future<ChatModel> createChat(String userId, String token) async {
    print('════════════════════════════════════════');
    print('📱 CREATE CHAT REQUEST');
    print('════════════════════════════════════════');
    print('URL: ${AppConfig.apiBaseUrl}/chats');
    print('User ID: $userId');
    print(
        'Headers: {\'Content-Type\': \'application/json\', \'Authorization\': \'Bearer $token\'}');
    print('════════════════════════════════════════');

    try {
      final response = await client
          .post(
            Uri.parse('${AppConfig.apiBaseUrl}/chats'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              'userId': userId,
            }),
          )
          .timeout(AppConfig.apiTimeout);

      print('════════════════════════════════════════');
      print('📱 CREATE CHAT RESPONSE');
      print('════════════════════════════════════════');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('════════════════════════════════════════');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ SUCCESS: Chat created successfully');
        final jsonData = json.decode(response.body);
        final chat = ChatModel.fromJson(jsonData);
        print('📊 Created chat ID: ${chat.id}');
        return chat;
      } else if (response.statusCode == 400) {
        print('❌ ERROR: 400 - Bad Request (Invalid user ID)');
        throw Exception('Bad Request: Invalid user ID - ${response.body}');
      } else if (response.statusCode == 401) {
        print('❌ ERROR: 401 - Unauthorized (Invalid or expired token)');
        throw Exception('Unauthorized: Invalid or expired token');
      } else if (response.statusCode == 403) {
        print('❌ ERROR: 403 - Forbidden (Cannot create chat with this user)');
        throw Exception('Forbidden: Cannot create chat with this user');
      } else if (response.statusCode == 404) {
        print('❌ ERROR: 404 - User not found');
        throw Exception('User not found: The specified user does not exist');
      } else if (response.statusCode == 409) {
        print('❌ ERROR: 409 - Chat already exists');
        throw Exception(
            'Chat already exists: A chat with this user already exists');
      } else if (response.statusCode == 500) {
        print('❌ ERROR: 500 - Internal Server Error');
        throw Exception('Internal Server Error: Server is experiencing issues');
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        print('❌ ERROR: ${response.statusCode} - Client Error');
        throw Exception(
            'Client Error ${response.statusCode}: ${response.body}');
      } else if (response.statusCode >= 500) {
        print('❌ ERROR: ${response.statusCode} - Server Error');
        throw Exception(
            'Server Error ${response.statusCode}: ${response.body}');
      } else {
        print('❌ ERROR: Unexpected status code ${response.statusCode}');
        throw Exception(
            'Failed to create chat: Unexpected status code ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        print(
            '❌ ERROR: Request timeout after ${AppConfig.apiTimeout.inSeconds} seconds');
        throw Exception('Request timeout: Server is not responding');
      } else if (e.toString().contains('SocketException')) {
        print('❌ ERROR: Network connection failed');
        throw Exception(
            'Network connection failed: Please check your internet connection');
      } else {
        print('❌ ERROR: Unexpected error: $e');
        throw Exception('Failed to create chat: $e');
      }
    }
  }

  @override
  Future<MessageModel> sendMessage(
      String chatId, String content, String type, String token) async {
    print('════════════════════════════════════════');
    print('📤 SEND MESSAGE REQUEST');
    print('════════════════════════════════════════');
    print('URL: ${AppConfig.apiBaseUrl}/chats/$chatId/messages');
    print('Chat ID: $chatId');
    print('Content: $content');
    print('Type: $type');
    print(
        'Headers: {\'Content-Type\': \'application/json\', \'Authorization\': \'Bearer $token\'}');
    print('════════════════════════════════════════');

    try {
      final response = await client
          .post(
            Uri.parse('${AppConfig.apiBaseUrl}/chats/$chatId/messages'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              'content': content,
              'type': type,
            }),
          )
          .timeout(AppConfig.apiTimeout);

      print('════════════════════════════════════════');
      print('📤 SEND MESSAGE RESPONSE');
      print('════════════════════════════════════════');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('════════════════════════════════════════');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ SUCCESS: Message sent successfully');
        final jsonData = json.decode(response.body);
        final message = MessageModel.fromJson(jsonData);
        print('📊 Message ID: ${message.id}');
        return message;
      } else if (response.statusCode == 400) {
        print('❌ ERROR: 400 - Bad Request (Invalid message data)');
        throw Exception('Bad Request: Invalid message data - ${response.body}');
      } else if (response.statusCode == 401) {
        print('❌ ERROR: 401 - Unauthorized (Invalid or expired token)');
        throw Exception('Unauthorized: Invalid or expired token');
      } else if (response.statusCode == 403) {
        print('❌ ERROR: 403 - Forbidden (Cannot send message to this chat)');
        throw Exception('Forbidden: Cannot send message to this chat');
      } else if (response.statusCode == 404) {
        print('❌ ERROR: 404 - Chat not found');
        throw Exception('Chat not found: The specified chat does not exist');
      } else if (response.statusCode == 500) {
        print('❌ ERROR: 500 - Internal Server Error');
        throw Exception('Internal Server Error: Server is experiencing issues');
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        print('❌ ERROR: ${response.statusCode} - Client Error');
        throw Exception(
            'Client Error ${response.statusCode}: ${response.body}');
      } else if (response.statusCode >= 500) {
        print('❌ ERROR: ${response.statusCode} - Server Error');
        throw Exception(
            'Server Error ${response.statusCode}: ${response.body}');
      } else {
        print('❌ ERROR: Unexpected status code ${response.statusCode}');
        throw Exception(
            'Failed to send message: Unexpected status code ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        print(
            '❌ ERROR: Request timeout after ${AppConfig.apiTimeout.inSeconds} seconds');
        throw Exception('Request timeout: Server is not responding');
      } else if (e.toString().contains('SocketException')) {
        print('❌ ERROR: Network connection failed');
        throw Exception(
            'Network connection failed: Please check your internet connection');
      } else {
        print('❌ ERROR: Unexpected error: $e');
        throw Exception('Failed to send message: $e');
      }
    }
  }
}
