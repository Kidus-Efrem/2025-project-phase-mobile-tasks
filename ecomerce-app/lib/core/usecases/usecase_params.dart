import '../../features/product/domain/entities/product.dart';

abstract class UseCaseParams {
  const UseCaseParams();
}

class NoParams extends UseCaseParams {
  const NoParams();
}

class IdParams extends UseCaseParams {
  final String id;
  const IdParams(this.id);
}

class ProductParams extends UseCaseParams {
  final Product product;
  const ProductParams(this.product);
}
