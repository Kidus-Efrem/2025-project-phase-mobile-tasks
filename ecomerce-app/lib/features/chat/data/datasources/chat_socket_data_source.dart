import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../core/config/app_config.dart';
import '../models/message_model.dart';

abstract class ChatSocketDataSource {
  Future<void> connect(String token);
  Future<void> disconnect();
  Future<void> sendMessage(String chatId, String content, String type);
  Stream<MessageModel> get messageStream;
  bool get isConnected;
}

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  IO.Socket? _socket;
  final StreamController<MessageModel> _messageController = StreamController<MessageModel>.broadcast();
  bool _isConnected = false;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect(String token) async {
    try {
      _socket = IO.io(
        AppConfig.socketBaseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token})
            .enableAutoConnect()
            .build(),
      );

      _socket!.onConnect((_) {
        _isConnected = true;
        print('Socket connected');
      });

      _socket!.onDisconnect((_) {
        _isConnected = false;
        print('Socket disconnected');
      });

      _socket!.on('message:delivered', (data) {
        // Handle message delivery confirmation
        print('Message delivered: $data');
      });

      _socket!.on('message:received', (data) {
        // Handle incoming message
        try {
          final message = MessageModel.fromJson(data);
          _messageController.add(message);
        } catch (e) {
          print('Error parsing received message: $e');
        }
      });

      _socket!.onError((error) {
        print('Socket error: $error');
        _isConnected = false;
      });

      _socket!.connect();
    } catch (e) {
      throw Exception('Failed to connect to socket: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    _socket?.disconnect();
    _socket?.dispose();
    _isConnected = false;
  }

  @override
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
  }

  @override
  Stream<MessageModel> get messageStream => _messageController.stream;

  void dispose() {
    _messageController.close();
    _socket?.dispose();
  }
}
