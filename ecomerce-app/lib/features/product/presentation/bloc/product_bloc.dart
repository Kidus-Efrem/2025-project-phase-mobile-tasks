import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase_params.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/view_all_product.dart';
import '../../domain/usecases/view_product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ViewAllProductsUseCase _viewAllProductsUseCase;
  final ViewProductUseCase _viewProductUseCase;
  final CreateProductUseCase _createProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;

  ProductBloc({
    required ViewAllProductsUseCase viewAllProductsUseCase,
    required ViewProductUseCase viewProductUseCase,
    required CreateProductUseCase createProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
  })  : _viewAllProductsUseCase = viewAllProductsUseCase,
        _viewProductUseCase = viewProductUseCase,
        _createProductUseCase = createProductUseCase,
        _updateProductUseCase = updateProductUseCase,
        _deleteProductUseCase = deleteProductUseCase,
        super(InitialState()) {
    on<LoadAllProductEvent>(_onLoadAllProductEvent);
    on<GetSingleProductEvent>(_onGetSingleProductEvent);
    on<CreateProductEvent>(_onCreateProductEvent);
    on<UpdateProductEvent>(_onUpdateProductEvent);
    on<DeleteProductEvent>(_onDeleteProductEvent);
  }

  Future<void> _onLoadAllProductEvent(
    LoadAllProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await _viewAllProductsUseCase(NoParams());

    result.fold(
      (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
      (products) => emit(LoadedAllProductState(products: products)),
    );
  }

  Future<void> _onGetSingleProductEvent(
    GetSingleProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await _viewProductUseCase(IdParams(event.id));

    result.fold(
      (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
      (product) => emit(LoadedSingleProductState(product: product)),
    );
  }

  Future<void> _onCreateProductEvent(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await _createProductUseCase(ProductParams(event.product));

    result.fold(
      (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
      (_) => emit(LoadedAllProductState(products: [])), // Refresh products list
    );
  }

  Future<void> _onUpdateProductEvent(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await _updateProductUseCase(ProductParams(event.product));

    result.fold(
      (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
      (_) => emit(LoadedAllProductState(products: [])), // Refresh products list
    );
  }

  Future<void> _onDeleteProductEvent(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());

    final result = await _deleteProductUseCase(IdParams(event.id));

    result.fold(
      (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
      (_) => emit(LoadedAllProductState(products: [])), // Refresh products list
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case CacheFailure:
        return 'Cache error occurred';
      default:
        return 'Unexpected error occurred';
    }
  }
}
