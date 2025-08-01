import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProductUsecase extends UseCase<Product, IdParams> {
  final ProductRepository repository;

  ViewProductUsecase(this.repository);

  @override
  Future<Either<Failure, Product>> call(IdParams params) async {
    return await repository.getProductById(params.id);
  }
}
