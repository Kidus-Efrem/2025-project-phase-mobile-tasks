import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/base_usecase_helper.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewAllProductsUseCase extends UseCase<List<Product>, NoParams> {
  final ProductRepository _repository;

  ViewAllProductsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    return BaseUseCaseHelper.handleRepositoryCall(
      () => _repository.getAllProducts(),
    );
  }
}
