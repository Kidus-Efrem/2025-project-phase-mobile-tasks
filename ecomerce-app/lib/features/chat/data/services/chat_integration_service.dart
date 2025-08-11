import '../../../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../features/authentication/presentation/bloc/auth_state.dart';
import 'chat_service.dart';

class ChatIntegrationService {
  static ChatIntegrationService? _instance;
  final ChatService _chatService = ChatService.instance;

  ChatIntegrationService._();

  static ChatIntegrationService get instance {
    _instance ??= ChatIntegrationService._();
    return _instance!;
  }

  void initializeWithAuthBloc(AuthBloc authBloc) {
    authBloc.stream.listen((state) {
      if (state is Authenticated && state.user.token != null) {
        // Connect to chat when user is authenticated
        _chatService.connect(state.user.token!);
      } else if (state is Unauthenticated) {
        // Disconnect from chat when user signs out
        _chatService.disconnect();
      }
    });
  }

  void connectWithToken(String token) {
    _chatService.connect(token);
  }

  void disconnect() {
    _chatService.disconnect();
  }

  bool get isConnected => _chatService.isConnected;
}
