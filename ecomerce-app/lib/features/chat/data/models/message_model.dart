import 'package:equatable/equatable.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import 'chat_model.dart';
import 'user_model.dart';

class MessageModel implements Message {
  @override
  final String id;
  @override
  final User sender;
  @override
  final Chat chat;
  @override
  final String content;
  @override
  final String type;
  @override
  final DateTime? createdAt;

  const MessageModel({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
    this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      sender: UserModel.fromJson(json['sender'] ?? {}),
      chat: ChatModel.fromJson(json['chat'] ?? {}),
      content: json['content'] ?? '',
      type: json['type'] ?? 'text',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  static List<MessageModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MessageModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': (sender as UserModel).toJson(),
      'chat': (chat as ChatModel).toJson(),
      'content': content,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, sender, chat, content, type, createdAt];

  @override
  bool? get stringify => true;
}