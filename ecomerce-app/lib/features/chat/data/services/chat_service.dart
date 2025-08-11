import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../core/config/app_config.dart';
import '../models/message_model.dart';

class ChatService {
  static ChatService? _instance;
  IO.Socket? _socket;
  final StreamController<MessageModel> _messageController = StreamController<MessageModel>.broadcast();
  bool _isConnected = false;
  String? _currentToken;

  ChatService._();

  static ChatService get instance {
    _instance ??= ChatService._();
    return _instance!;
  }

  bool get isConnected => _isConnected;
  Stream<MessageModel> get messageStream => _messageController.stream;

  Future<void> connect(String token) async {
    print('🚀 ChatService - connect called');
    print('🚀 ChatService - Token: ${token.substring(0, 10)}...');
    print('🚀 ChatService - Socket base URL: ${AppConfig.socketBaseUrl}');
    
    if (_isConnected && _currentToken == token) {
      print('✅ ChatService - Already connected with same token');
      return; // Already connected with the same token
    }

    print('🔄 ChatService - Disconnecting previous connection...');
    await disconnect(); // Disconnect if already connected

    try {
      _currentToken = token;
      print('🚀 ChatService - Creating socket connection...');
      _socket = IO.io(
        AppConfig.socketBaseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token})
            .enableAutoConnect()
            .build(),
      );

      print('🚀 ChatService - Setting up socket listeners...');
      _setupSocketListeners();
      print('🚀 ChatService - Connecting socket...');
      _socket!.connect();
      print('✅ ChatService - Socket connection initiated');
    } catch (e) {
      print('❌ ChatService - Failed to connect to socket: $e');
      print('❌ ChatService - Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  void _setupSocketListeners() {
    print('🚀 ChatService - Setting up socket listeners...');
    
    _socket!.onConnect((_) {
      _isConnected = true;
      print('✅ ChatService - Socket connected successfully');
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      print('❌ ChatService - Socket disconnected');
    });

    _socket!.on('message:delivered', (data) {
      print('✅ ChatService - Message delivered: $data');
      // You can emit an event here to update the UI
    });

    _socket!.on('message:received', (data) {
      print('🚀 ChatService - Message received event triggered');
      print('🚀 ChatService - Raw data: $data');
      try {
        final message = MessageModel.fromJson(data);
        print('✅ ChatService - Message parsed successfully: ${message.content}');
        _messageController.add(message);
        print('✅ ChatService - Message added to stream');
      } catch (e) {
        print('❌ ChatService - Error parsing received message: $e');
        print('❌ ChatService - Error type: ${e.runtimeType}');
      }
    });

    _socket!.onError((error) {
      print('❌ ChatService - Socket error: $error');
      _isConnected = false;
    });

    _socket!.onConnectError((error) {
      print('❌ ChatService - Socket connection error: $error');
      _isConnected = false;
    });
    
    print('✅ ChatService - Socket listeners setup completed');
  }

  Future<void> sendMessage(String chatId, String content, String type) async {
    print('🚀 ChatService - sendMessage called');
    print('🚀 ChatService - Chat ID: "$chatId"');
    print('🚀 ChatService - Content: "$content"');
    print('🚀 ChatService - Type: "$type"');
    print('🚀 ChatService - Socket connected: $_isConnected');
    print('🚀 ChatService - Socket instance: ${_socket != null ? "Present" : "Null"}');
    
    if (!_isConnected || _socket == null) {
      print('❌ ChatService - Socket not connected!');
      print('❌ ChatService - _isConnected: $_isConnected');
      print('❌ ChatService - _socket: ${_socket != null ? "Present" : "Null"}');
      throw Exception('Socket not connected');
    }

    final payload = {
      'chatId': chatId,
      'content': content,
      'type': type,
    };

    print('🚀 ChatService - Emitting message:send with payload: $payload');
    _socket!.emit('message:send', payload);
    print('✅ ChatService - Message emitted successfully');
  }

  Future<void> disconnect() async {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    _currentToken = null;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
