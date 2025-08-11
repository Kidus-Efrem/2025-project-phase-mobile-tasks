import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class CreateChatParams extends UseCaseParams {
  final String userId;
  const CreateChatParams(this.userId);
}

class CreateChatUseCase implements UseCase<Chat, CreateChatParams> {
  final ChatRepository repository;

  CreateChatUseCase(this.repository);

  @override
  Future<Either<Failure, Chat>> call(CreateChatParams params) async {
    return await repository.createChat(params.userId);
  }
}
