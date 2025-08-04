import 'package:flutter_test/flutter_test.dart';

import '../../../../../lib/features/product/domain/entities/product.dart';
import '../../../../../lib/features/product/presentation/bloc/product_bloc.dart';

void main() {
  group('ProductState', () {
    group('InitialState', () {
      test('should be a subclass of ProductState', () {
        const state = InitialState();
        expect(state, isA<ProductState>());
      });

      test('props should be empty', () {
        const state = InitialState();
        expect(state.props, isEmpty);
      });

      test('should be equatable', () {
        const state1 = InitialState();
        const state2 = InitialState();
        expect(state1, equals(state2));
      });
    });

    group('LoadingState', () {
      test('should be a subclass of ProductState', () {
        const state = LoadingState();
        expect(state, isA<ProductState>());
      });

      test('props should be empty', () {
        const state = LoadingState();
        expect(state.props, isEmpty);
      });

      test('should be equatable', () {
        const state1 = LoadingState();
        const state2 = LoadingState();
        expect(state1, equals(state2));
      });
    });

    group('LoadedAllProductState', () {
      const tProducts = [
        Product(
          id: '1',
          imageUrl: 'test_image.jpg',
          name: 'Test Product',
          price: 99.99,
          description: 'Test description',
        ),
        Product(
          id: '2',
          imageUrl: 'test_image2.jpg',
          name: 'Test Product 2',
          price: 199.99,
          description: 'Test description 2',
        ),
      ];

      test('should be a subclass of ProductState', () {
        const state = LoadedAllProductState(products: tProducts);
        expect(state, isA<ProductState>());
      });

      test('props should contain products', () {
        const state = LoadedAllProductState(products: tProducts);
        expect(state.props, contains(tProducts));
      });

      test('should be equatable', () {
        const state1 = LoadedAllProductState(products: tProducts);
        const state2 = LoadedAllProductState(products: tProducts);
        expect(state1, equals(state2));
      });

      test('should not be equal when products are different', () {
        const products1 = [
          Product(
            id: '1',
            imageUrl: 'test_image.jpg',
            name: 'Test Product',
            price: 99.99,
            description: 'Test description',
          ),
        ];
        const products2 = [
          Product(
            id: '2',
            imageUrl: 'test_image2.jpg',
            name: 'Test Product 2',
            price: 199.99,
            description: 'Test description 2',
          ),
        ];
        const state1 = LoadedAllProductState(products: products1);
        const state2 = LoadedAllProductState(products: products2);
        expect(state1, isNot(equals(state2)));
      });
    });

    group('LoadedSingleProductState', () {
      const tProduct = Product(
        id: '1',
        imageUrl: 'test_image.jpg',
        name: 'Test Product',
        price: 99.99,
        description: 'Test description',
      );

      test('should be a subclass of ProductState', () {
        const state = LoadedSingleProductState(product: tProduct);
        expect(state, isA<ProductState>());
      });

      test('props should contain product', () {
        const state = LoadedSingleProductState(product: tProduct);
        expect(state.props, contains(tProduct));
      });

      test('should be equatable', () {
        const state1 = LoadedSingleProductState(product: tProduct);
        const state2 = LoadedSingleProductState(product: tProduct);
        expect(state1, equals(state2));
      });

      test('should not be equal when products are different', () {
        const product1 = Product(
          id: '1',
          imageUrl: 'test_image.jpg',
          name: 'Test Product',
          price: 99.99,
          description: 'Test description',
        );
        const product2 = Product(
          id: '2',
          imageUrl: 'test_image2.jpg',
          name: 'Test Product 2',
          price: 199.99,
          description: 'Test description 2',
        );
        const state1 = LoadedSingleProductState(product: product1);
        const state2 = LoadedSingleProductState(product: product2);
        expect(state1, isNot(equals(state2)));
      });
    });

    group('ErrorState', () {
      const tMessage = 'Test error message';

      test('should be a subclass of ProductState', () {
        const state = ErrorState(message: tMessage);
        expect(state, isA<ProductState>());
      });

      test('props should contain message', () {
        const state = ErrorState(message: tMessage);
        expect(state.props, contains(tMessage));
      });

      test('should be equatable', () {
        const state1 = ErrorState(message: tMessage);
        const state2 = ErrorState(message: tMessage);
        expect(state1, equals(state2));
      });

      test('should not be equal when messages are different', () {
        const state1 = ErrorState(message: 'Error 1');
        const state2 = ErrorState(message: 'Error 2');
        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
