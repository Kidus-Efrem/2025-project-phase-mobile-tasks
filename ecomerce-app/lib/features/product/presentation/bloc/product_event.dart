import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
// part of 'product_bloc.dart';
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllProducts extends ProductEvent {
  const LoadAllProducts();
}

class LoadProductById extends ProductEvent {
  final String id;
  const LoadProductById(this.id);

  @override
  List<Object?> get props => [id];
}

class AddProduct extends ProductEvent {
  final Product product;
  const AddProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProduct extends ProductEvent {
  final Product product;
  const UpdateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final String id;
  const DeleteProduct(this.id);

  @override
  List<Object?> get props => [id];
}
