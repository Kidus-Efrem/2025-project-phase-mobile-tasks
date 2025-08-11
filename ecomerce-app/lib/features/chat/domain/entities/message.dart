import 'package:equatable/equatable.dart';
import '../../../authentication/domain/entities/user.dart';
import 'chat.dart';

class Message extends Equatable {
  final String id;
  final User sender;
  final Chat chat;
  final String content;
  final String type;
  final DateTime? createdAt;

  const Message({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, sender, chat, content, type, createdAt];
}
