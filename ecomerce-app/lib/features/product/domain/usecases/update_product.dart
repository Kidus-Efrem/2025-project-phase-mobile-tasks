import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/base_usecase_helper.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../repositories/product_repository.dart';

class UpdateProductUseCase extends UseCase<Unit, ProductParams> {
  final ProductRepository _repository;

  UpdateProductUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ProductParams params) async {
    return _repository.updateProduct(params.product);
  }
}
