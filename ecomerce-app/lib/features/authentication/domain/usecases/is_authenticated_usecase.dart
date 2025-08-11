import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../repositories/auth_repository.dart';

class IsAuthenticatedUseCase extends UseCase<bool, NoParams> {
  final AuthRepository _repository;

  IsAuthenticatedUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return _repository.isAuthenticated();
  }
}
