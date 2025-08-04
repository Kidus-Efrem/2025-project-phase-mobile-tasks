import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/base_usecase_helper.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProductUseCase extends UseCase<Product, IdParams> {
  final ProductRepository _repository;

  ViewProductUseCase(this._repository);

  @override
  Future<Either<Failure, Product>> call(IdParams params) async {
    return _repository.getProductById(params.id);
  }
}
