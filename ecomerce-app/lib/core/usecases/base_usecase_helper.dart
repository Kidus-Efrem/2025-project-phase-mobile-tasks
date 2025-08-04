import 'package:dartz/dartz.dart';

import '../error/failure.dart';
import 'usecase.dart';

/// Base helper for common use case operations
/// Reduces code duplication and improves consistency
abstract class BaseUseCaseHelper {
  /// Generic method to handle repository calls with error handling
  static Future<Either<Failure, T>> handleRepositoryCall<T>(
    Future<T> Function() repositoryCall,
  ) async {
    try {
      final result = await repositoryCall();
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  /// Generic method to handle repository calls that return Unit
  static Future<Either<Failure, Unit>> handleRepositoryCallUnit(
    Future<void> Function() repositoryCall,
  ) async {
    try {
      await repositoryCall();
      return const Right(unit);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  /// Maps exceptions to appropriate failure types
  static Failure _mapExceptionToFailure(dynamic exception) {
    // This can be extended based on your specific exception types
    if (exception.toString().contains('ServerException')) {
      return ServerFailure();
    } else if (exception.toString().contains('CacheException')) {
      return CacheFailure();
    } else {
      return NetworkFailure();
    }
  }
}