import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/usecases/base_usecase_helper.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    return BaseUseCaseHelper.handleRepositoryCall(() async {
      final userModel = await remoteDataSource.signUp(
        email: email,
        password: password,
        name: name,
      );

      // Cache the user after successful sign up
      await localDataSource.cacheUser(userModel);

      return userModel;
    });
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    return BaseUseCaseHelper.handleRepositoryCall(() async {
      final userModel = await remoteDataSource.signIn(
        email: email,
        password: password,
      );

      // Cache the user after successful sign in
      await localDataSource.cacheUser(userModel);

      return userModel;
    });
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    return BaseUseCaseHelper.handleRepositoryCallUnit(() async {
      await localDataSource.clearCachedUser();
    });
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    return BaseUseCaseHelper.handleRepositoryCall(() async {
      return localDataSource.getCachedUser();
    });
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    return BaseUseCaseHelper.handleRepositoryCall(() async {
      return localDataSource.hasCachedUser();
    });
  }
}
