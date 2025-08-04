import '../../features/product/domain/entities/product.dart';

class NoParams {
  const NoParams();
}

class IdParams {
  final String id;
  const IdParams(this.id);
}

class ProductParams {
  final Product product;
  const ProductParams(this.product);
}
