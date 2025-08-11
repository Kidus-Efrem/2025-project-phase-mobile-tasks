import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase extends UseCase<Unit, NoParams> {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return _repository.signOut();
  }
}
