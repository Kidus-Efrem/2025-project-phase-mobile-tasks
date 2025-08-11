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
    if (_isConnected && _currentToken == token) {
      return; // Already connected with the same token
    }

    await disconnect(); // Disconnect if already connected

    try {
      _currentToken = token;
      _socket = IO.io(
        AppConfig.socketBaseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token})
            .enableAutoConnect()
            .build(),
      );

      _setupSocketListeners();
      _socket!.connect();
    } catch (e) {
      print('Failed to connect to socket: $e');
      rethrow;
    }
  }

  void _setupSocketListeners() {
    _socket!.onConnect((_) {
      _isConnected = true;
      print('Socket connected successfully');
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      print('Socket disconnected');
    });

    _socket!.on('message:delivered', (data) {
      print('Message delivered: $data');
      // You can emit an event here to update the UI
    });

    _socket!.on('message:received', (data) {
      try {
        final message = MessageModel.fromJson(data);
        _messageController.add(message);
        print('Message received: ${message.content}');
      } catch (e) {
        print('Error parsing received message: $e');
      }
    });

    _socket!.onError((error) {
      print('Socket error: $error');
      _isConnected = false;
    });

    _socket!.onConnectError((error) {
      print('Socket connection error: $error');
      _isConnected = false;
    });
  }

  Future<void> sendMessage(String chatId, String content, String type) async {
    if (!_isConnected || _socket == null) {
      throw Exception('Socket not connected');
    }

    final payload = {
      'chatId': chatId,
      'content': content,
      'type': type,
    };

    _socket!.emit('message:send', payload);
    print('Message sent: $payload');
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
