import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'core/router/app_router.dart';
import 'core/network/network_info.dart';
import 'core/config/app_config.dart';
import 'features/authentication/data/datasources/auth_local_data_source.dart';
import 'features/authentication/data/datasources/auth_remote_data_source.dart';
import 'features/authentication/data/datasources/auth_mock_data_source.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'features/authentication/domain/usecases/is_authenticated_usecase.dart';
import 'features/authentication/domain/usecases/sign_in_usecase.dart';
import 'features/authentication/domain/usecases/sign_out_usecase.dart';
import 'features/authentication/domain/usecases/sign_up_usecase.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/datasources/chat_mock_data_source.dart';
import 'features/chat/data/datasources/users_remote_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/data/services/chat_service.dart';
import 'features/chat/domain/usecases/get_chats_usecase.dart';
import 'features/chat/domain/usecases/get_messages_usecase.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/domain/usecases/get_users_usecase.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/data/services/chat_integration_service.dart';
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  final connectionChecker = InternetConnectionChecker.createInstance();
  final networkInfo = NetworkInfoImpl(connectionChecker);
  final httpClient = http.Client();
  final sharedPreferences = await SharedPreferences.getInstance();

  // Authentication dependencies
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);
  final authMockDataSource = AuthMockDataSourceImpl();
  final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);

  // Use mock API if configured, otherwise use real API
  final authRepository = AuthRepositoryImpl(
    // remoteDataSource: AppConfig.useMockApi ? authMockDataSource : authRemoteDataSource,
    remoteDataSource:  authRemoteDataSource,
    localDataSource: authLocalDataSource,
    networkInfo: networkInfo,
  );

  // Authentication Use Cases
  final signUpUseCase = SignUpUseCase(authRepository);
  final signInUseCase = SignInUseCase(authRepository);
  final signOutUseCase = SignOutUseCase(authRepository);
  final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
  final isAuthenticatedUseCase = IsAuthenticatedUseCase(authRepository);

  // Authentication BLoC
  final authBloc = AuthBloc(
    signUpUseCase: signUpUseCase,
    signInUseCase: signInUseCase,
    signOutUseCase: signOutUseCase,
    getCurrentUserUseCase: getCurrentUserUseCase,
    isAuthenticatedUseCase: isAuthenticatedUseCase,
  );

  // Chat dependencies
  final chatRemoteDataSource = ChatRemoteDataSourceImpl(client: httpClient);
  final usersRemoteDataSource = UsersRemoteDataSourceImpl(client: httpClient);
  final chatMockDataSource = ChatMockDataSourceImpl();
  final chatService = ChatService.instance;
  final chatRepository = ChatRepositoryImpl(
    remoteDataSource: chatRemoteDataSource,
    usersRemoteDataSource: usersRemoteDataSource,
    mockDataSource: chatMockDataSource, // Keep for fallback if needed
    chatService: chatService,
    networkInfo: networkInfo,
    authBloc: authBloc,
  );

  // Chat Use Cases
  final getChatsUseCase = GetChatsUseCase(chatRepository);
  final getMessagesUseCase = GetMessagesUseCase(chatRepository);
  final sendMessageUseCase = SendMessageUseCase(chatRepository);
  final getUsersUseCase = GetUsersUseCase(chatRepository);

  // Chat BLoC
  final chatBloc = ChatBloc(
    getChatsUseCase: getChatsUseCase,
    getMessagesUseCase: getMessagesUseCase,
    sendMessageUseCase: sendMessageUseCase,
    getUsersUseCase: getUsersUseCase,
    chatRepository: chatRepository,
  );

  // Initialize chat integration service
  final chatIntegrationService = ChatIntegrationService.instance;
  chatIntegrationService.initializeWithAuthBloc(authBloc);

  runApp(MyApp(
    authBloc: authBloc,
    chatBloc: chatBloc,
  ));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final ChatBloc chatBloc;

  const MyApp({
    super.key,
    required this.authBloc,
    required this.chatBloc,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => authBloc),
        BlocProvider(create: (context) => chatBloc),
      ],
      child: MaterialApp(
        navigatorObservers:[routeObserver],
        debugShowCheckedModeBanner: false,
        title: AppConfig.appName,
        initialRoute: '/chats',
        onGenerateRoute: AppRouter.generateRoute,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}