// part of 'product_bloc.dart';
part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

// Initial state before anything happens
final class InitialState extends ProductState {
  const InitialState();
}

// Loading state shown while fetching data
final class LoadingState extends ProductState {
  const LoadingState();
}

// Loaded state with the list of products
final class LoadedAllProductState extends ProductState {
  final List<Product> products;

  const LoadedAllProductState({required this.products});

  @override
  List<Object> get props => [products];
}

// Loaded state with a single product
final class LoadedSingleProductState extends ProductState {
  final Product product;

  const LoadedSingleProductState({required this.product});

  @override
  List<Object> get props => [product];
}

// Error state shown when something goes wrong
final class ErrorState extends ProductState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
