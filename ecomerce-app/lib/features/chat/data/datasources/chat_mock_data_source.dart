import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

abstract class ChatMockDataSource {
  Future<List<ChatModel>> getChats();
  Future<List<MessageModel>> getMessages(String chatId);
}

class ChatMockDataSourceImpl implements ChatMockDataSource {
  @override
  Future<List<ChatModel>> getChats() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      ChatModel(
        id: '1',
        user1: UserModel(
          id: 'user1',
          email: 'john@example.com',
          name: 'John Doe',
        ),
        user2: UserModel(
          id: 'user2',
          email: 'jane@example.com',
          name: 'Jane Smith',
        ),
      ),
      ChatModel(
        id: '2',
        user1: UserModel(
          id: 'user1',
          email: 'john@example.com',
          name: 'John Doe',
        ),
        user2: UserModel(
          id: 'user3',
          email: 'bob@example.com',
          name: 'Bob Johnson',
        ),
      ),
    ];
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      MessageModel(
        id: '1',
        sender: UserModel(
          id: 'user1',
          email: 'john@example.com',
          name: 'John Doe',
        ),
        chat: ChatModel(
          id: chatId,
          user1: UserModel(
            id: 'user1',
            email: 'john@example.com',
            name: 'John Doe',
          ),
          user2: UserModel(
            id: 'user2',
            email: 'jane@example.com',
            name: 'Jane Smith',
          ),
        ),
        content: 'Hello! How are you?',
        type: 'text',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        id: '2',
        sender: UserModel(
          id: 'user2',
          email: 'jane@example.com',
          name: 'Jane Smith',
        ),
        chat: ChatModel(
          id: chatId,
          user1: UserModel(
            id: 'user1',
            email: 'john@example.com',
            name: 'John Doe',
          ),
          user2: UserModel(
            id: 'user2',
            email: 'jane@example.com',
            name: 'Jane Smith',
          ),
        ),
        content: 'Hi John! I\'m doing great, thanks for asking.',
        type: 'text',
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      MessageModel(
        id: '3',
        sender: UserModel(
          id: 'user1',
          email: 'john@example.com',
          name: 'John Doe',
        ),
        chat: ChatModel(
          id: chatId,
          user1: UserModel(
            id: 'user1',
            email: 'john@example.com',
            name: 'John Doe',
          ),
          user2: UserModel(
            id: 'user2',
            email: 'jane@example.com',
            name: 'Jane Smith',
          ),
        ),
        content: 'That\'s wonderful! Would you like to grab coffee sometime?',
        type: 'text',
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];
  }
}
