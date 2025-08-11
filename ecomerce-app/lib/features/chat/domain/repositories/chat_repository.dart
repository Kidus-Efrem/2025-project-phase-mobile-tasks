import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/chat.dart';
import '../entities/message.dart';
import '../../../authentication/domain/entities/user.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Chat>>> getChats();
  Future<Either<Failure, List<Message>>> getMessages(String chatId);
  Future<Either<Failure, Message>> sendMessage(String chatId, String content, String type);
  Future<Either<Failure, Chat>> createChat(String userId);
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, void>> connectToSocket(String token);
  Future<Either<Failure, void>> disconnectFromSocket();
  Stream<Message> get messageStream;
}
