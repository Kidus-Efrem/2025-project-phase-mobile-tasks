import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ecommerce_ui_replication/core/error/exception.dart';
import 'package:ecommerce_ui_replication/core/error/failure.dart';
import 'package:ecommerce_ui_replication/core/network/network_info.dart';
import 'package:ecommerce_ui_replication/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_ui_replication/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_ui_replication/features/product/data/models/product_model.dart';
import 'package:ecommerce_ui_replication/features/product/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_ui_replication/features/product/domain/entities/product.dart';

import 'product_repository_impl_test.mocks.dart';

@GenerateMocks([
  ProductRemoteDataSource,
  ProductLocalDataSource,
  NetworkInfo,
])
void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getAllProducts', () {
    final tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    final tProduct = Product(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    final tProductList = [tProductModel];

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProducts())
          .thenAnswer((_) async => tProductList);
      when(mockLocalDataSource.cacheProductList(tProductList))
          .thenAnswer((_) async => {});

      // act
      await repository.getAllProducts();

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.getAllProducts())
            .thenAnswer((_) async => tProductList);
        when(mockLocalDataSource.cacheProductList(tProductList))
            .thenAnswer((_) async => {});

        // act
        final result = await repository.getAllProducts();

        // assert
        verify(mockRemoteDataSource.getAllProducts());
        verify(mockLocalDataSource.cacheProductList(tProductList));
        expect(result, equals(Right(tProductList)));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.getAllProducts())
            .thenAnswer((_) async => tProductList);
        when(mockLocalDataSource.cacheProductList(tProductList))
            .thenAnswer((_) async => {});

        // act
        await repository.getAllProducts();

        // assert
        verify(mockRemoteDataSource.getAllProducts());
        verify(mockLocalDataSource.cacheProductList(tProductList));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(mockRemoteDataSource.getAllProducts()).thenThrow(ServerException());

        // act
        final result = await repository.getAllProducts();

        // assert
        verify(mockRemoteDataSource.getAllProducts());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached data when the cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getLastProductList())
            .thenAnswer((_) async => tProductList);

        // act
        final result = await repository.getAllProducts();

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastProductList());
        expect(result, equals(Right(tProductList)));
      });

      test('should return CacheFailure when the call to local data source is unsuccessful', () async {
        // arrange
        when(mockLocalDataSource.getLastProductList()).thenThrow(CacheException());

        // act
        final result = await repository.getAllProducts();

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastProductList());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getProductById', () {
    final tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    final tProduct = Product(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    const tId = '1';

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getProductById(tId))
          .thenAnswer((_) async => tProductModel);
      when(mockLocalDataSource.cacheProduct(tProductModel))
          .thenAnswer((_) async => {});

      // act
      await repository.getProductById(tId);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.getProductById(tId))
            .thenAnswer((_) async => tProductModel);
        when(mockLocalDataSource.cacheProduct(tProductModel))
            .thenAnswer((_) async => {});

        // act
        final result = await repository.getProductById(tId);

        // assert
        verify(mockRemoteDataSource.getProductById(tId));
        verify(mockLocalDataSource.cacheProduct(tProductModel));
        expect(result, equals(Right(tProductModel)));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.getProductById(tId))
            .thenAnswer((_) async => tProductModel);
        when(mockLocalDataSource.cacheProduct(tProductModel))
            .thenAnswer((_) async => {});

        // act
        await repository.getProductById(tId);

        // assert
        verify(mockRemoteDataSource.getProductById(tId));
        verify(mockLocalDataSource.cacheProduct(tProductModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(mockRemoteDataSource.getProductById(tId)).thenThrow(ServerException());

        // act
        final result = await repository.getProductById(tId);

        // assert
        verify(mockRemoteDataSource.getProductById(tId));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return last locally cached data when the cached data is present', () async {
        // arrange
        when(mockLocalDataSource.getProductById(tId))
            .thenAnswer((_) async => tProductModel);

        // act
        final result = await repository.getProductById(tId);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getProductById(tId));
        expect(result, equals(Right(tProductModel)));
      });

      test('should return CacheFailure when the call to local data source is unsuccessful', () async {
        // arrange
        when(mockLocalDataSource.getProductById(tId)).thenThrow(CacheException());

        // act
        final result = await repository.getProductById(tId);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getProductById(tId));
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('createProduct', () {
    final tProduct = Product(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    final tProductModel = ProductModel.fromEntity(tProduct);

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.createProduct(tProductModel))
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.cacheProduct(tProductModel))
          .thenAnswer((_) async => {});

      // act
      await repository.createProduct(tProduct);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return unit when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.createProduct(tProductModel))
            .thenAnswer((_) async => {});
        when(mockLocalDataSource.cacheProduct(tProductModel))
            .thenAnswer((_) async => {});

        // act
        final result = await repository.createProduct(tProduct);

        // assert
        verify(mockRemoteDataSource.createProduct(tProductModel));
        verify(mockLocalDataSource.cacheProduct(tProductModel));
        expect(result, equals(const Right(unit)));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.createProduct(tProductModel))
            .thenAnswer((_) async => {});
        when(mockLocalDataSource.cacheProduct(tProductModel))
            .thenAnswer((_) async => {});

        // act
        await repository.createProduct(tProduct);

        // assert
        verify(mockRemoteDataSource.createProduct(tProductModel));
        verify(mockLocalDataSource.cacheProduct(tProductModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(mockRemoteDataSource.createProduct(tProductModel))
            .thenThrow(ServerException());

        // act
        final result = await repository.createProduct(tProduct);

        // assert
        verify(mockRemoteDataSource.createProduct(tProductModel));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return NetworkFailure when device is offline', () async {
        // act
        final result = await repository.createProduct(tProduct);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(NetworkFailure())));
      });
    });
  });

  group('updateProduct', () {
    final tProduct = Product(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    final tProductModel = ProductModel.fromEntity(tProduct);

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.updateProduct(tProductModel))
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.cacheProduct(tProductModel))
          .thenAnswer((_) async => {});

      // act
      await repository.updateProduct(tProduct);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return unit when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.updateProduct(tProductModel))
            .thenAnswer((_) async => {});
        when(mockLocalDataSource.cacheProduct(tProductModel))
            .thenAnswer((_) async => {});

        // act
        final result = await repository.updateProduct(tProduct);

        // assert
        verify(mockRemoteDataSource.updateProduct(tProductModel));
        verify(mockLocalDataSource.cacheProduct(tProductModel));
        expect(result, equals(const Right(unit)));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.updateProduct(tProductModel))
            .thenAnswer((_) async => {});
        when(mockLocalDataSource.cacheProduct(tProductModel))
            .thenAnswer((_) async => {});

        // act
        await repository.updateProduct(tProduct);

        // assert
        verify(mockRemoteDataSource.updateProduct(tProductModel));
        verify(mockLocalDataSource.cacheProduct(tProductModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(mockRemoteDataSource.updateProduct(tProductModel))
            .thenThrow(ServerException());

        // act
        final result = await repository.updateProduct(tProduct);

        // assert
        verify(mockRemoteDataSource.updateProduct(tProductModel));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return NetworkFailure when device is offline', () async {
        // act
        final result = await repository.updateProduct(tProduct);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(NetworkFailure())));
      });
    });
  });

  group('deleteProduct', () {
    const tId = '1';

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.deleteProduct(tId))
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.deleteProduct(tId))
          .thenAnswer((_) async => {});

      // act
      await repository.deleteProduct(tId);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return unit when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.deleteProduct(tId))
            .thenAnswer((_) async => {});
        when(mockLocalDataSource.deleteProduct(tId))
            .thenAnswer((_) async => {});

        // act
        final result = await repository.deleteProduct(tId);

        // assert
        verify(mockRemoteDataSource.deleteProduct(tId));
        verify(mockLocalDataSource.deleteProduct(tId));
        expect(result, equals(const Right(unit)));
      });

      test('should delete from local cache when the call to remote data source is successful', () async {
        // arrange
        when(mockRemoteDataSource.deleteProduct(tId))
            .thenAnswer((_) async => {});
        when(mockLocalDataSource.deleteProduct(tId))
            .thenAnswer((_) async => {});

        // act
        await repository.deleteProduct(tId);

        // assert
        verify(mockRemoteDataSource.deleteProduct(tId));
        verify(mockLocalDataSource.deleteProduct(tId));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(mockRemoteDataSource.deleteProduct(tId)).thenThrow(ServerException());

        // act
        final result = await repository.deleteProduct(tId);

        // assert
        verify(mockRemoteDataSource.deleteProduct(tId));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return NetworkFailure when device is offline', () async {
        // act
        final result = await repository.deleteProduct(tId);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(NetworkFailure())));
      });
    });
  });
}


