import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../../domain/usecases/get_chats_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/message.dart';
import '../../../authentication/domain/entities/user.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatsUseCase getChatsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final GetUsersUseCase getUsersUseCase;
  final ChatRepository chatRepository;
  StreamSubscription<dynamic>? _messageSubscription;

  ChatBloc({
    required this.getChatsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.getUsersUseCase,
    required this.chatRepository,
  }) : super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
    on<LoadUsers>(_onLoadUsers);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ConnectToSocket>(_onConnectToSocket);
    on<DisconnectFromSocket>(_onDisconnectFromSocket);
    on<MessageReceived>(_onMessageReceived);

    // Listen to incoming messages
    print('🚀 ChatBloc - Setting up message stream listener...');
    _messageSubscription = chatRepository.messageStream.listen((message) {
      print('🚀 ChatBloc - Message received from stream: ${message.content}');
      print('🚀 ChatBloc - Message ID: ${message.id}');
      print('🚀 ChatBloc - Message sender: ${message.sender.name}');
      add(MessageReceived(message));
    });
    print('✅ ChatBloc - Message stream listener setup completed');
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await getChatsUseCase(NoParams());
    result.fold(
      (failure) => emit(ChatError('Failed to load chats')),
      (chats) => emit(ChatsLoaded(chats)),
    );
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await getUsersUseCase(NoParams());
    result.fold(
      (failure) => emit(ChatError('Failed to load users')),
      (users) => emit(UsersLoaded(users)),
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
    print('🚀 ChatBloc - _onSendMessage called');
    print('🚀 ChatBloc - Chat ID: "${event.chatId}"');
    print('🚀 ChatBloc - Content: "${event.content}"');
    print('🚀 ChatBloc - Type: "${event.type}"');
    
    try {
      print('🚀 ChatBloc - Calling sendMessageUseCase...');
      final result = await sendMessageUseCase(SendMessageParams(
        chatId: event.chatId,
        content: event.content,
        type: event.type,
      ));
      
      print('🚀 ChatBloc - sendMessageUseCase completed');
      
      result.fold(
        (failure) {
          print('❌ ChatBloc - Send message failed: ${failure.runtimeType}');
          print('❌ ChatBloc - Failure details: $failure');
          emit(ChatError('Failed to send message: ${failure.toString()}'));
        },
        (message) {
          print('✅ ChatBloc - Message sent successfully');
          print('✅ ChatBloc - Sent message ID: ${message.id}');
          print('✅ ChatBloc - Sent message content: "${message.content}"');
          emit(MessageSent(message));
        },
      );
    } catch (e) {
      print('❌ ChatBloc - Exception in _onSendMessage: $e');
      emit(ChatError('Exception sending message: $e'));
    }
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
    // Handle incoming message from socket
    print('🔍 ChatBloc - Message received from socket: ${event.messageData}');
    
    // Convert the message data to a Message entity and emit MessageReceivedState
    if (event.messageData is Message) {
      emit(MessageReceivedState(event.messageData as Message));
    } else {
      print('🔍 ChatBloc - Message data is not a Message entity: ${event.messageData.runtimeType}');
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
