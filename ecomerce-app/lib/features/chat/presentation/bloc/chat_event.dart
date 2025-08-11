import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChats extends ChatEvent {}

class LoadMessages extends ChatEvent {
  final String chatId;

  const LoadMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessage extends ChatEvent {
  final String chatId;
  final String content;
  final String type;

  const SendMessage({
    required this.chatId,
    required this.content,
    required this.type,
  });

  @override
  List<Object?> get props => [chatId, content, type];
}

class ConnectToSocket extends ChatEvent {
  final String token;

  const ConnectToSocket(this.token);

  @override
  List<Object?> get props => [token];
}

class DisconnectFromSocket extends ChatEvent {}

class MessageReceived extends ChatEvent {
  final dynamic messageData;

  const MessageReceived(this.messageData);

  @override
  List<Object?> get props => [messageData];
}
