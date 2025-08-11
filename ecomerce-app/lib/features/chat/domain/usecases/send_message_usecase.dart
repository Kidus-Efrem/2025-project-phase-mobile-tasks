import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SendMessageParams {
  final String chatId;
  final String content;
  final String type;

  SendMessageParams({
    required this.chatId,
    required this.content,
    required this.type,
  });
}

class SendMessageUseCase implements UseCase<Message, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    print('🚀 SendMessageUseCase - call method called');
    print('🚀 SendMessageUseCase - Chat ID: "${params.chatId}"');
    print('🚀 SendMessageUseCase - Content: "${params.content}"');
    print('🚀 SendMessageUseCase - Type: "${params.type}"');
    
    try {
      print('🚀 SendMessageUseCase - Calling repository.sendMessage...');
      final result = await repository.sendMessage(params.chatId, params.content, params.type);
      
      print('🚀 SendMessageUseCase - Repository call completed');
      
      result.fold(
        (failure) {
          print('❌ SendMessageUseCase - Repository returned failure: ${failure.runtimeType}');
          print('❌ SendMessageUseCase - Failure details: $failure');
        },
        (message) {
          print('✅ SendMessageUseCase - Repository returned success');
          print('✅ SendMessageUseCase - Message ID: ${message.id}');
          print('✅ SendMessageUseCase - Message content: "${message.content}"');
        },
      );
      
      return result;
    } catch (e) {
      print('❌ SendMessageUseCase - Exception in call method: $e');
      rethrow;
    }
  }
}
