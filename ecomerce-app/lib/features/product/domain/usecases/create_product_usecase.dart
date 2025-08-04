import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/base_usecase_helper.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../repositories/product_repository.dart';

class CreateProductUseCase extends UseCase<Unit, ProductParams> {
  final ProductRepository _repository;

  CreateProductUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ProductParams params) async {
    return BaseUseCaseHelper.handleRepositoryCallUnit(
      () => _repository.createProduct(params.product),
    );
  }
}
