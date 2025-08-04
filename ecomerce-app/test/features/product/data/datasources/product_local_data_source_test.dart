import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce_ui_replication/core/constants/app_constants.dart';
import 'package:ecommerce_ui_replication/core/error/exception.dart';
import 'package:ecommerce_ui_replication/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_ui_replication/features/product/data/models/product_model.dart';

import 'product_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late ProductLocalDataSourceImpl localDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = ProductLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastProductList', () {
    final tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    final tProductList = [tProductModel];

    test('should return ProductList from SharedPreferences when there is one in the cache', () async {
      // arrange
      when(mockSharedPreferences.getString(AppConstants.cachedProductListKey))
          .thenReturn(json.encode(tProductList.map((p) => p.toJson()).toList()));

      // act
      final result = await localDataSource.getLastProductList();

      // assert
      verify(mockSharedPreferences.getString(AppConstants.cachedProductListKey));
      expect(result, equals(tProductList));
    });

    test('should throw CacheException when there is not a cached ProductList', () async {
      // arrange
      when(mockSharedPreferences.getString(AppConstants.cachedProductListKey))
          .thenReturn(null);

      // act
      final call = localDataSource.getLastProductList;

      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });

    test('should throw CacheException when there is an invalid cached ProductList', () async {
      // arrange
      when(mockSharedPreferences.getString(AppConstants.cachedProductListKey))
          .thenReturn('invalid json');

      // act
      final call = localDataSource.getLastProductList;

      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
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

    final tProductList = [tProductModel];

    test('should return ProductModel when there is a cached ProductList with the given id', () async {
      // arrange
      when(mockSharedPreferences.getString(AppConstants.cachedProductListKey))
          .thenReturn(json.encode(tProductList.map((p) => p.toJson()).toList()));

      // act
      final result = await localDataSource.getProductById('1');

      // assert
      verify(mockSharedPreferences.getString(AppConstants.cachedProductListKey));
      expect(result, equals(tProductModel));
    });

    test('should throw CacheException when there is not a cached ProductList', () async {
      // arrange
      when(mockSharedPreferences.getString(AppConstants.cachedProductListKey))
          .thenReturn(null);

      // act
      final call = localDataSource.getProductById;

      // assert
      expect(() => call('1'), throwsA(isA<CacheException>()));
    });

    test('should throw CacheException when there is a cached ProductList but the given id is not found', () async {
      // arrange
      when(mockSharedPreferences.getString(AppConstants.cachedProductListKey))
          .thenReturn(json.encode(tProductList.map((p) => p.toJson()).toList()));

      // act
      final call = localDataSource.getProductById;

      // assert
      expect(() => call('2'), throwsA(isA<CacheException>()));
    });
  });

  group('cacheProductList', () {
    final tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    final tProductList = [tProductModel];

    test('should call SharedPreferences to cache the data', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      final expectedJsonString = json.encode(tProductList.map((p) => p.toJson()).toList());

      // act
      await localDataSource.cacheProductList(tProductList);

      // assert
      verify(mockSharedPreferences.setString(AppConstants.cachedProductListKey, expectedJsonString));
    });
  });

  group('cacheProduct', () {
    final tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    test('should call SharedPreferences to cache the product when there is no cached list', () async {
      // arrange
      when(mockSharedPreferences.getString(AppConstants.cachedProductListKey))
          .thenReturn(null);
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      final expectedJsonString = json.encode([tProductModel].map((p) => p.toJson()).toList());

      // act
      await localDataSource.cacheProduct(tProductModel);

      // assert
      verify(mockSharedPreferences.setString(AppConstants.cachedProductListKey, expectedJsonString));
    });

    test('should call SharedPreferences to cache the product when there is a cached list', () async {
      // arrange
      final existingProduct = ProductModel(
        id: '2',
        name: 'Existing Product',
        imageUrl: 'existing_image.jpg',
        price: 50.0,
        description: 'Existing description',
      );
      when(mockSharedPreferences.getString(AppConstants.cachedProductListKey))
          .thenReturn(json.encode([existingProduct].map((p) => p.toJson()).toList()));
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      final expectedJsonString = json.encode([existingProduct, tProductModel].map((p) => p.toJson()).toList());

      // act
      await localDataSource.cacheProduct(tProductModel);

      // assert
      verify(mockSharedPreferences.setString(AppConstants.cachedProductListKey, expectedJsonString));
    });

    test('should call SharedPreferences to update the product when there is a cached list with same id', () async {
      // arrange
      final existingProduct = ProductModel(
        id: '1',
        name: 'Old Product',
        imageUrl: 'old_image.jpg',
        price: 50.0,
        description: 'Old description',
      );
      when(mockSharedPreferences.getString(AppConstants.cachedProductListKey))
          .thenReturn(json.encode([existingProduct].map((p) => p.toJson()).toList()));
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      final expectedJsonString = json.encode([tProductModel].map((p) => p.toJson()).toList());

      // act
      await localDataSource.cacheProduct(tProductModel);

      // assert
      verify(mockSharedPreferences.setString(AppConstants.cachedProductListKey, expectedJsonString));
    });
  });

  group('deleteProduct', () {
    final tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    final tProductList = [tProductModel];

    test('should call SharedPreferences to remove the product from cache', () async {
      // arrange
      when(mockSharedPreferences.getString(AppConstants.cachedProductListKey))
          .thenReturn(json.encode(tProductList.map((p) => p.toJson()).toList()));
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      final expectedJsonString = json.encode(<ProductModel>[].map((p) => p.toJson()).toList());

      // act
      await localDataSource.deleteProduct('1');

      // assert
      verify(mockSharedPreferences.setString(AppConstants.cachedProductListKey, expectedJsonString));
    });

    test('should throw CacheException when there is not a cached ProductList', () async {
      // arrange
      when(mockSharedPreferences.getString(AppConstants.cachedProductListKey))
          .thenReturn(null);

      // act
      final call = localDataSource.deleteProduct;

      // assert
      expect(() => call('1'), throwsA(isA<CacheException>()));
    });
  });
}