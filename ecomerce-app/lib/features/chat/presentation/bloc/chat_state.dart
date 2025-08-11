import 'package:equatable/equatable.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../../authentication/domain/entities/user.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<Chat> chats;

  const ChatsLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class UsersLoaded extends ChatState {
  final List<User> users;

  const UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class ChatCreated extends ChatState {
  final Chat chat;

  const ChatCreated(this.chat);

  @override
  List<Object?> get props => [chat];
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  final String chatId;

  const MessagesLoaded({
    required this.messages,
    required this.chatId,
  });

  @override
  List<Object?> get props => [messages, chatId];
}

class MessageSent extends ChatState {
  final Message message;

  const MessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageReceivedState extends ChatState {
  final Message message;

  const MessageReceivedState(this.message);

  @override
  List<Object?> get props => [message];
}

class SocketConnected extends ChatState {}

class SocketDisconnected extends ChatState {}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
