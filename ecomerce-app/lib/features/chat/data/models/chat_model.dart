import 'package:equatable/equatable.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import 'user_model.dart';

class ChatModel implements Chat {
  @override
  final String id;
  @override
  final User user1;
  @override
  final User user2;

  const ChatModel({
    required this.id,
    required this.user1,
    required this.user2,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'id' and '_id' fields, and ensure we get a valid ID
    final String chatId = (json['id'] ?? json['_id'] ?? '').toString();
    
    // Debug print to see what we're getting
    print('🔍 ChatModel.fromJson - Raw JSON: $json');
    print('🔍 ChatModel.fromJson - Parsed ID: "$chatId"');
    
    return ChatModel(
      id: chatId,
      user1: UserModel.fromJson(json['user1'] ?? {}),
      user2: UserModel.fromJson(json['user2'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1': (user1 as UserModel).toJson(),
      'user2': (user2 as UserModel).toJson(),
    };
  }

  @override
  List<Object?> get props => [id, user1, user2];

  @override
  bool? get stringify => true;
}
