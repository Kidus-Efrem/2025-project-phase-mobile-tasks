import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../../domain/usecases/get_chats_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatsUseCase getChatsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final ChatRepository chatRepository;
  StreamSubscription<dynamic>? _messageSubscription;

  ChatBloc({
    required this.getChatsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.chatRepository,
  }) : super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ConnectToSocket>(_onConnectToSocket);
    on<DisconnectFromSocket>(_onDisconnectFromSocket);
    on<MessageReceived>(_onMessageReceived);

    // Listen to incoming messages
    _messageSubscription = chatRepository.messageStream.listen((message) {
      add(MessageReceived(message));
    });
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await getChatsUseCase(NoParams());
    result.fold(
      (failure) => emit(ChatError('Failed to load chats')),
      (chats) => emit(ChatsLoaded(chats)),
    );
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    print('🔍 ChatBloc - Loading messages for chat ID: "${event.chatId}"');
    emit(ChatLoading());
    final result = await getMessagesUseCase(event.chatId);
    result.fold(
      (failure) => emit(ChatError('Failed to load messages')),
      (messages) => emit(MessagesLoaded(messages: messages, chatId: event.chatId)),
    );
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    final result = await sendMessageUseCase(SendMessageParams(
      chatId: event.chatId,
      content: event.content,
      type: event.type,
    ));
    result.fold(
      (failure) => emit(ChatError('Failed to send message')),
      (message) => emit(MessageSent(message)),
    );
  }

  Future<void> _onConnectToSocket(ConnectToSocket event, Emitter<ChatState> emit) async {
    final result = await chatRepository.connectToSocket(event.token);
    result.fold(
      (failure) => emit(ChatError('Failed to connect to socket')),
      (_) => emit(SocketConnected()),
    );
  }

  Future<void> _onDisconnectFromSocket(DisconnectFromSocket event, Emitter<ChatState> emit) async {
    final result = await chatRepository.disconnectFromSocket();
    result.fold(
      (failure) => emit(ChatError('Failed to disconnect from socket')),
      (_) => emit(SocketDisconnected()),
    );
  }

  void _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
    // Handle incoming message - you might want to update the current chat
    // or show a notification
    print('Message received: ${event.messageData}');
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
