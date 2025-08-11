import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpParams extends UseCaseParams {
  final String email;
  final String password;
  final String name;

  SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}

class SignUpUseCase extends UseCase<User, SignUpParams> {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return _repository.signUp(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}
