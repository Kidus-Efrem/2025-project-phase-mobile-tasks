import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_mock_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../datasources/users_remote_data_source.dart';
import '../services/chat_service.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../models/message_model.dart';
import '../models/chat_model.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../../authentication/domain/entities/user.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final UsersRemoteDataSource usersRemoteDataSource;
  final ChatMockDataSource mockDataSource;
  final ChatService chatService;
  final NetworkInfo networkInfo;
  final AuthBloc authBloc;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.usersRemoteDataSource,
    required this.mockDataSource,
    required this.chatService,
    required this.networkInfo,
    required this.authBloc,
  });

  String? _getCurrentUserToken() {
    final state = authBloc.state;
    if (state is Authenticated && state.user.token != null) {
      print(
        '🔑 Repository: Using token from authenticated user: ${state.user.token!.substring(0, 10)}...',
      );
      return state.user.token;
    } else if (state is Authenticated && state.user.token == null) {
      print('❌ Repository: User is authenticated but has no token');
      return null;
    } else if (state is Unauthenticated) {
      print('❌ Repository: User is not authenticated');
      return null;
    } else if (state is AuthLoading) {
      print('⏳ Repository: Authentication is in progress');
      return null;
    } else {
      print('❌ Repository: Unexpected auth state: ${state.runtimeType}');
      return null;
    }
  }

  User? _getCurrentUser() {
    final state = authBloc.state;
    if (state is Authenticated) {
      return state.user;
    }
    return null;
  }

  @override
  Future<Either<Failure, List<Chat>>> getChats() async {
    if (await networkInfo.isConnected) {
      try {
        final token = _getCurrentUserToken();
        if (token == null) {
          return Left(AuthFailure());
        }

        print('🔄 Repository: Attempting to load chats from remote API...');
        final chatModels = await remoteDataSource.getChats(token);
        final chats = chatModels.cast<Chat>();
        print(
          '✅ Repository: Successfully loaded ${chats.length} chats from API',
        );
        return Right(chats);
      } on ServerException {
        print(
          '❌ Repository: Server exception occurred, falling back to mock data',
        );
        // Fallback to mock data if remote API fails
        try {
          final mockChats = await mockDataSource.getChats();
          final chats = mockChats.cast<Chat>();
          print(
            '🔄 Repository: Using mock data as fallback - ${chats.length} chats',
          );
          return Right(chats);
        } catch (mockError) {
          print('❌ Repository: Mock data also failed: $mockError');
          return Left(ServerFailure());
        }
      } catch (e) {
        print('❌ Repository: Unexpected error: $e, falling back to mock data');
        // Fallback to mock data if unexpected error occurs
        try {
          final mockChats = await mockDataSource.getChats();
          final chats = mockChats.cast<Chat>();
          print(
            '🔄 Repository: Using mock data as fallback - ${chats.length} chats',
          );
          return Right(chats);
        } catch (mockError) {
          print('❌ Repository: Mock data also failed: $mockError');
          return Left(ServerFailure());
        }
      }
    } else {
      print('❌ Repository: No internet connection, using mock data');
      try {
        final mockChats = await mockDataSource.getChats();
        final chats = mockChats.cast<Chat>();
        print(
          '🔄 Repository: Using mock data due to no internet - ${chats.length} chats',
        );
        return Right(chats);
      } catch (mockError) {
        print('❌ Repository: Mock data failed: $mockError');
        return Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final token = _getCurrentUserToken();
        if (token == null) {
          return Left(AuthFailure());
        }

        print('🔄 Repository: Attempting to load users from remote API...');
        final userModels = await usersRemoteDataSource.getUsers(token);
        final users = userModels.cast<User>();
        print(
          '✅ Repository: Successfully loaded ${users.length} users from API',
        );
        return Right(users);
      } on ServerException {
        print(
          '❌ Repository: Server exception occurred while loading users',
        );
        return Left(ServerFailure());
      } catch (e) {
        print('❌ Repository: Unexpected error loading users: $e');
        return Left(ServerFailure());
      }
    } else {
      print('❌ Repository: No internet connection, cannot load users');
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        final token = _getCurrentUserToken();
        if (token == null) {
          return Left(AuthFailure());
        }
        print(
          '🔄 Repository: Attempting to load messages for chat $chatId from remote API...',
        );
        final messageModels = await remoteDataSource.getMessages(chatId, token);
        final messages = messageModels.cast<Message>();
        print(
          '✅ Repository: Successfully loaded ${messages.length} messages from API',
        );
        return Right(messages);
      } on ServerException {
        print(
          '❌ Repository: Server exception occurred, falling back to mock data',
        );
        // Fallback to mock data if remote API fails
        try {
          final mockMessages = await mockDataSource.getMessages(chatId);
          final messages = mockMessages.cast<Message>();
          print(
            '🔄 Repository: Using mock data as fallback - ${messages.length} messages',
          );
          return Right(messages);
        } catch (mockError) {
          print('❌ Repository: Mock data also failed: $mockError');
          return Left(ServerFailure());
        }
      } catch (e) {
        print('❌ Repository: Unexpected error: $e, falling back to mock data');
        // Fallback to mock data if unexpected error occurs
        try {
          final mockMessages = await mockDataSource.getMessages(chatId);
          final messages = mockMessages.cast<Message>();
          print(
            '🔄 Repository: Using mock data as fallback - ${messages.length} messages',
          );
          return Right(messages);
        } catch (mockError) {
          print('❌ Repository: Mock data also failed: $mockError');
          return Left(ServerFailure());
        }
      }
    } else {
      print('❌ Repository: No internet connection, using mock data');
      try {
        final mockMessages = await mockDataSource.getMessages(chatId);
        final messages = mockMessages.cast<Message>();
        print(
          '🔄 Repository: Using mock data due to no internet - ${messages.length} messages',
        );
        return Right(messages);
      } catch (mockError) {
        print('❌ Repository: Mock data failed: $mockError');
        return Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(
    String chatId,
    String content,
    String type,
  ) async {
    print('🚀 Repository - sendMessage called');
    print('🚀 Repository - Chat ID: "$chatId"');
    print('🚀 Repository - Content: "$content"');
    print('🚀 Repository - Type: "$type"');
    
    if (await networkInfo.isConnected) {
      print('✅ Repository - Network is connected');
      
      try {
        final token = _getCurrentUserToken();
        print('🚀 Repository - Token retrieved: ${token != null ? "Present" : "Null"}');
        
        if (token == null) {
          print('❌ Repository - Token is null, returning AuthFailure');
          return Left(AuthFailure());
        }

        print('🔄 Repository: Sending message to chat $chatId via socket only...');

        // Send message via socket service only
        print('🚀 Repository - Calling chatService.sendMessage...');
        await chatService.sendMessage(chatId, content, type);
        print('✅ Repository: Message sent successfully via socket');

        // Create a temporary message object for UI feedback
        // The real message will come back through the socket stream
        final currentUser = _getCurrentUser();
        print('🚀 Repository - Current user: ${currentUser?.name} (ID: ${currentUser?.id})');
        
        final tempMessage = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
          sender: currentUser ?? UserModel(id: '', name: 'You', email: ''),
          chat: ChatModel(
            id: chatId,
            user1: UserModel(id: '', name: '', email: ''),
            user2: UserModel(id: '', name: '', email: ''),
          ),
          content: content,
          type: type,
          createdAt: DateTime.now(),
        );

        print('✅ Repository - Created temp message with ID: ${tempMessage.id}');
        print('✅ Repository - Returning success with temp message');
        return Right(tempMessage);
      } catch (e) {
        print('❌ Repository: Socket send error: $e');
        print('❌ Repository: Error type: ${e.runtimeType}');
        return Left(ServerFailure());
      }
    } else {
      print('❌ Repository: No internet connection');
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> connectToSocket(String token) async {
    if (await networkInfo.isConnected) {
      try {
        await chatService.connect(token);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> disconnectFromSocket() async {
    try {
      await chatService.disconnect();
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Message> get messageStream =>
      chatService.messageStream.cast<Message>();
}
