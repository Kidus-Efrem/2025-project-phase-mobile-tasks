import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInParams extends UseCaseParams {
  final String email;
  final String password;

  SignInParams({
    required this.email,
    required this.password,
  });
}

class SignInUseCase extends UseCase<User, SignInParams> {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return _repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
