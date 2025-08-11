import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ecommerce_ui_replication/core/error/exception.dart';
import 'package:ecommerce_ui_replication/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_ui_replication/features/product/data/models/product_model.dart';

import 'product_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductRemoteDataSourceImpl remoteDataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    remoteDataSource = ProductRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getAllProducts', () {
    final tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    final tProductList = [tProductModel];

    test('should return ProductList when the call to remote server is successful', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({
                  'data': tProductList.map((p) => p.toJson()).toList(),
                }),
                200,
              ));

      // act
      final result = await remoteDataSource.getAllProducts();

      // assert
      verify(mockHttpClient.get(
        Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/products'),
        headers: {'Content-Type': 'application/json'},
      ));
      expect(result, equals(tProductList));
    });

    test('should throw ServerException when the call to remote server is unsuccessful', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      // act
      final call = remoteDataSource.getAllProducts;

      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when the response status code is not 200', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final call = remoteDataSource.getAllProducts;

      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
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

    const tId = '1';

    test('should return ProductModel when the call to remote server is successful', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({
                  'data': tProductModel.toJson(),
                }),
                200,
              ));

      // act
      final result = await remoteDataSource.getProductById(tId);

      // assert
      verify(mockHttpClient.get(
        Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/products/$tId'),
        headers: {'Content-Type': 'application/json'},
      ));
      expect(result, equals(tProductModel));
    });

    test('should throw ServerException when the call to remote server is unsuccessful', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      // act
      final call = remoteDataSource.getProductById;

      // assert
      expect(() => call(tId), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when the response status code is not 200', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final call = remoteDataSource.getProductById;

      // assert
      expect(() => call(tId), throwsA(isA<ServerException>()));
    });
  });

  group('createProduct', () {
    final tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    test('should throw Exception when image file does not exist', () async {
      // arrange
      final productWithNonExistentImage = ProductModel(
        id: '1',
        name: 'Test Product',
        imageUrl: 'non_existent_image.jpg',
        price: 99.99,
        description: 'Test description',
      );

      // act
      final call = remoteDataSource.createProduct;

      // assert
      expect(() => call(productWithNonExistentImage), throwsA(isA<Exception>()));
    });

    test('should throw Exception when image file does not exist for valid product', () async {
      // arrange
      final productWithNonExistentImage = ProductModel(
        id: '1',
        name: 'Test Product',
        imageUrl: 'test_image.jpg',
        price: 99.99,
        description: 'Test description',
      );

      // act
      final call = remoteDataSource.createProduct;

      // assert
      expect(() => call(productWithNonExistentImage), throwsA(isA<Exception>()));
    });
  });

  group('updateProduct', () {
    final tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      imageUrl: 'test_image.jpg',
      price: 99.99,
      description: 'Test description',
    );

    test('should complete successfully when the call to remote server is successful', () async {
      // arrange
      when(mockHttpClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('OK', 200));

      // act
      await remoteDataSource.updateProduct(tProductModel);

      // assert
      verify(mockHttpClient.put(
        Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/products/${tProductModel.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': tProductModel.name,
          'description': tProductModel.description,
          'price': tProductModel.price,
        }),
      ));
    });

    test('should throw ServerException when the call to remote server is unsuccessful', () async {
      // arrange
      when(mockHttpClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      // act
      final call = remoteDataSource.updateProduct;

      // assert
      expect(() => call(tProductModel), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when the response status code is not 200', () async {
      // arrange
      when(mockHttpClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final call = remoteDataSource.updateProduct;

      // assert
      expect(() => call(tProductModel), throwsA(isA<ServerException>()));
    });
  });

  group('deleteProduct', () {
    const tId = '1';

    test('should complete successfully when the call to remote server is successful', () async {
      // arrange
      when(mockHttpClient.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('OK', 200));

      // act
      await remoteDataSource.deleteProduct(tId);

      // assert
      verify(mockHttpClient.delete(
        Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/products/$tId'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should throw ServerException when the call to remote server is unsuccessful', () async {
      // arrange
      when(mockHttpClient.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      // act
      final call = remoteDataSource.deleteProduct;

      // assert
      expect(() => call(tId), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when the response status code is not 200', () async {
      // arrange
      when(mockHttpClient.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final call = remoteDataSource.deleteProduct;

      // assert
      expect(() => call(tId), throwsA(isA<ServerException>()));
    });
  });
}






