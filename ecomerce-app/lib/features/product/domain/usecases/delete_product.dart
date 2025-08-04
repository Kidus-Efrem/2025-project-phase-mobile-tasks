import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/base_usecase_helper.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../repositories/product_repository.dart';

class DeleteProductUseCase extends UseCase<Unit, IdParams> {
  final ProductRepository _repository;

  DeleteProductUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(IdParams params) async {
    return _repository.deleteProduct(params.id);
  }
}
