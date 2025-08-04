import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../lib/core/error/failure.dart';
import '../../../../../lib/core/usecases/usecase_params.dart';
import '../../../../../lib/features/product/domain/entities/product.dart';
import '../../../../../lib/features/product/domain/usecases/create_product_usecase.dart';
import '../../../../../lib/features/product/domain/usecases/delete_product.dart';
import '../../../../../lib/features/product/domain/usecases/update_product.dart';
import '../../../../../lib/features/product/domain/usecases/view_all_product.dart';
import '../../../../../lib/features/product/domain/usecases/view_product.dart';
import '../../../../../lib/features/product/presentation/bloc/product_bloc.dart';

import 'product_bloc_test.mocks.dart';

@GenerateMocks([
  ViewAllProductsUseCase,
  ViewProductUseCase,
  CreateProductUseCase,
  UpdateProductUseCase,
  DeleteProductUseCase,
])
void main() {
  late ProductBloc bloc;
  late MockViewAllProductsUseCase mockViewAllProductsUseCase;
  late MockViewProductUseCase mockViewProductUseCase;
  late MockCreateProductUseCase mockCreateProductUseCase;
  late MockUpdateProductUseCase mockUpdateProductUseCase;
  late MockDeleteProductUseCase mockDeleteProductUseCase;

  setUp(() {
    mockViewAllProductsUseCase = MockViewAllProductsUseCase();
    mockViewProductUseCase = MockViewProductUseCase();
    mockCreateProductUseCase = MockCreateProductUseCase();
    mockUpdateProductUseCase = MockUpdateProductUseCase();
    mockDeleteProductUseCase = MockDeleteProductUseCase();

    bloc = ProductBloc(
      viewAllProductsUseCase: mockViewAllProductsUseCase,
      viewProductUseCase: mockViewProductUseCase,
      createProductUseCase: mockCreateProductUseCase,
      updateProductUseCase: mockUpdateProductUseCase,
      deleteProductUseCase: mockDeleteProductUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const tProduct = Product(
    id: '1',
    imageUrl: 'test_image.jpg',
    name: 'Test Product',
    price: 99.99,
    description: 'Test description',
  );

  const tProducts = [tProduct];

  group('ProductBloc', () {
    test('initial state should be InitialState', () {
      expect(bloc.state, equals(InitialState()));
    });

    group('LoadAllProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'emits [LoadingState, LoadedAllProductState] when LoadAllProductEvent is added and use case returns success',
        build: () {
          when(mockViewAllProductsUseCase(any))
              .thenAnswer((_) async => const Right(tProducts));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAllProductEvent()),
        expect: () => [
          LoadingState(),
          const LoadedAllProductState(products: tProducts),
        ],
        verify: (_) {
          verify(mockViewAllProductsUseCase(const NoParams())).called(1);
        },
      );

      blocTest<ProductBloc, ProductState>(
        'emits [LoadingState, ErrorState] when LoadAllProductEvent is added and use case returns failure',
        build: () {
          when(mockViewAllProductsUseCase(any))
              .thenAnswer((_) async => const Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAllProductEvent()),
        expect: () => [
          LoadingState(),
          const ErrorState(message: 'Server error occurred'),
        ],
        verify: (_) {
          verify(mockViewAllProductsUseCase(const NoParams())).called(1);
        },
      );
    });

    group('GetSingleProductEvent', () {
      const tId = '1';

      blocTest<ProductBloc, ProductState>(
        'emits [LoadingState, LoadedSingleProductState] when GetSingleProductEvent is added and use case returns success',
        build: () {
          when(mockViewProductUseCase(any))
              .thenAnswer((_) async => const Right(tProduct));
          return bloc;
        },
        act: (bloc) => bloc.add(const GetSingleProductEvent(tId)),
        expect: () => [
          LoadingState(),
          const LoadedSingleProductState(product: tProduct),
        ],
        verify: (_) {
          verify(mockViewProductUseCase(const IdParams(tId))).called(1);
        },
      );

      blocTest<ProductBloc, ProductState>(
        'emits [LoadingState, ErrorState] when GetSingleProductEvent is added and use case returns failure',
        build: () {
          when(mockViewProductUseCase(any))
              .thenAnswer((_) async => const Left(CacheFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const GetSingleProductEvent(tId)),
        expect: () => [
          LoadingState(),
          const ErrorState(message: 'Cache error occurred'),
        ],
        verify: (_) {
          verify(mockViewProductUseCase(const IdParams(tId))).called(1);
        },
      );
    });

    group('CreateProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'emits [LoadingState, LoadedAllProductState] when CreateProductEvent is added and use case returns success',
        build: () {
          when(mockCreateProductUseCase(any))
              .thenAnswer((_) async => const Right(unit));
          return bloc;
        },
        act: (bloc) => bloc.add(const CreateProductEvent(tProduct)),
        expect: () => [
          LoadingState(),
          const LoadedAllProductState(products: []),
        ],
        verify: (_) {
          verify(mockCreateProductUseCase(const ProductParams(tProduct))).called(1);
        },
      );

      blocTest<ProductBloc, ProductState>(
        'emits [LoadingState, ErrorState] when CreateProductEvent is added and use case returns failure',
        build: () {
          when(mockCreateProductUseCase(any))
              .thenAnswer((_) async => const Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const CreateProductEvent(tProduct)),
        expect: () => [
          LoadingState(),
          const ErrorState(message: 'Server error occurred'),
        ],
        verify: (_) {
          verify(mockCreateProductUseCase(const ProductParams(tProduct))).called(1);
        },
      );
    });

    group('UpdateProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'emits [LoadingState, LoadedAllProductState] when UpdateProductEvent is added and use case returns success',
        build: () {
          when(mockUpdateProductUseCase(any))
              .thenAnswer((_) async => const Right(unit));
          return bloc;
        },
        act: (bloc) => bloc.add(const UpdateProductEvent(tProduct)),
        expect: () => [
          LoadingState(),
          const LoadedAllProductState(products: []),
        ],
        verify: (_) {
          verify(mockUpdateProductUseCase(const ProductParams(tProduct))).called(1);
        },
      );

      blocTest<ProductBloc, ProductState>(
        'emits [LoadingState, ErrorState] when UpdateProductEvent is added and use case returns failure',
        build: () {
          when(mockUpdateProductUseCase(any))
              .thenAnswer((_) async => const Left(NetworkFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const UpdateProductEvent(tProduct)),
        expect: () => [
          LoadingState(),
          const ErrorState(message: 'Unexpected error occurred'),
        ],
        verify: (_) {
          verify(mockUpdateProductUseCase(const ProductParams(tProduct))).called(1);
        },
      );
    });

    group('DeleteProductEvent', () {
      const tId = '1';

      blocTest<ProductBloc, ProductState>(
        'emits [LoadingState, LoadedAllProductState] when DeleteProductEvent is added and use case returns success',
        build: () {
          when(mockDeleteProductUseCase(any))
              .thenAnswer((_) async => const Right(unit));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteProductEvent(tId)),
        expect: () => [
          LoadingState(),
          const LoadedAllProductState(products: []),
        ],
        verify: (_) {
          verify(mockDeleteProductUseCase(const IdParams(tId))).called(1);
        },
      );

      blocTest<ProductBloc, ProductState>(
        'emits [LoadingState, ErrorState] when DeleteProductEvent is added and use case returns failure',
        build: () {
          when(mockDeleteProductUseCase(any))
              .thenAnswer((_) async => const Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteProductEvent(tId)),
        expect: () => [
          LoadingState(),
          const ErrorState(message: 'Server error occurred'),
        ],
        verify: (_) {
          verify(mockDeleteProductUseCase(const IdParams(tId))).called(1);
        },
      );
    });
  });
}
