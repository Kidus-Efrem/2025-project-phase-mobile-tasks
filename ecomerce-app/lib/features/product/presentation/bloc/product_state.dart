// part of 'product_bloc.dart';
part of 'product_bloc.dart';
sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

// Initial state before anything happens
final class ProductInitial extends ProductState {}

// Loading state shown while fetching products
final class ProductLoading extends ProductState {}

// Loaded state with the list of products
final class ProductLoaded extends ProductState {
  final List<Product> products;

  const ProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

// Error state shown when something goes wrong
final class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}
