import 'package:flutter_test/flutter_test.dart';

import '../../../../../lib/features/product/domain/entities/product.dart';
import '../../../../../lib/features/product/presentation/bloc/product_bloc.dart';

void main() {
  group('ProductEvent', () {
    group('LoadAllProductEvent', () {
      test('should be a subclass of ProductEvent', () {
        const event = LoadAllProductEvent();
        expect(event, isA<ProductEvent>());
      });

      test('props should be empty', () {
        const event = LoadAllProductEvent();
        expect(event.props, isEmpty);
      });

      test('should be equatable', () {
        const event1 = LoadAllProductEvent();
        const event2 = LoadAllProductEvent();
        expect(event1, equals(event2));
      });
    });

    group('GetSingleProductEvent', () {
      const tId = '1';

      test('should be a subclass of ProductEvent', () {
        const event = GetSingleProductEvent(tId);
        expect(event, isA<ProductEvent>());
      });

      test('props should contain id', () {
        const event = GetSingleProductEvent(tId);
        expect(event.props, contains(tId));
      });

      test('should be equatable', () {
        const event1 = GetSingleProductEvent(tId);
        const event2 = GetSingleProductEvent(tId);
        expect(event1, equals(event2));
      });

      test('should not be equal when ids are different', () {
        const event1 = GetSingleProductEvent('1');
        const event2 = GetSingleProductEvent('2');
        expect(event1, isNot(equals(event2)));
      });
    });

    group('CreateProductEvent', () {
      const tProduct = Product(
        id: '1',
        imageUrl: 'test_image.jpg',
        name: 'Test Product',
        price: 99.99,
        description: 'Test description',
      );

      test('should be a subclass of ProductEvent', () {
        const event = CreateProductEvent(tProduct);
        expect(event, isA<ProductEvent>());
      });

      test('props should contain product', () {
        const event = CreateProductEvent(tProduct);
        expect(event.props, contains(tProduct));
      });

      test('should be equatable', () {
        const event1 = CreateProductEvent(tProduct);
        const event2 = CreateProductEvent(tProduct);
        expect(event1, equals(event2));
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
        const event1 = CreateProductEvent(product1);
        const event2 = CreateProductEvent(product2);
        expect(event1, isNot(equals(event2)));
      });
    });

    group('UpdateProductEvent', () {
      const tProduct = Product(
        id: '1',
        imageUrl: 'test_image.jpg',
        name: 'Test Product',
        price: 99.99,
        description: 'Test description',
      );

      test('should be a subclass of ProductEvent', () {
        const event = UpdateProductEvent(tProduct);
        expect(event, isA<ProductEvent>());
      });

      test('props should contain product', () {
        const event = UpdateProductEvent(tProduct);
        expect(event.props, contains(tProduct));
      });

      test('should be equatable', () {
        const event1 = UpdateProductEvent(tProduct);
        const event2 = UpdateProductEvent(tProduct);
        expect(event1, equals(event2));
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
        const event1 = UpdateProductEvent(product1);
        const event2 = UpdateProductEvent(product2);
        expect(event1, isNot(equals(event2)));
      });
    });

    group('DeleteProductEvent', () {
      const tId = '1';

      test('should be a subclass of ProductEvent', () {
        const event = DeleteProductEvent(tId);
        expect(event, isA<ProductEvent>());
      });

      test('props should contain id', () {
        const event = DeleteProductEvent(tId);
        expect(event.props, contains(tId));
      });

      test('should be equatable', () {
        const event1 = DeleteProductEvent(tId);
        const event2 = DeleteProductEvent(tId);
        expect(event1, equals(event2));
      });

      test('should not be equal when ids are different', () {
        const event1 = DeleteProductEvent('1');
        const event2 = DeleteProductEvent('2');
        expect(event1, isNot(equals(event2)));
      });
    });
  });
}
