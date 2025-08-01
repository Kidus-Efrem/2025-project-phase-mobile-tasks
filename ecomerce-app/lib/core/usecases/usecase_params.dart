import '../../features/product/domain/entities/product.dart';

class NoParams {}

class IdParams {
  final String id;
  IdParams(this.id);
}

class ProductParams {
  final Product product;
  ProductParams(this.product);
}
