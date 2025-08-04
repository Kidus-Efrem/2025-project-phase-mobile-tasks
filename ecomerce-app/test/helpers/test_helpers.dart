import 'package:ecommerce_ui_replication/core/constants/app_constants.dart';
import 'package:ecommerce_ui_replication/features/product/data/models/product_model.dart';
import 'package:ecommerce_ui_replication/features/product/domain/entities/product.dart';

/// Test helpers to reduce code duplication in tests
/// Provides common test data and utilities
class TestHelpers {
  /// Creates a test ProductModel
  static ProductModel createTestProductModel({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    String? description,
  }) {
    return ProductModel(
      id: id ?? AppConstants.testProductId,
      name: name ?? AppConstants.testProductName,
      imageUrl: imageUrl ?? AppConstants.testProductImageUrl,
      price: price ?? AppConstants.testProductPrice,
      description: description ?? AppConstants.testProductDescription,
    );
  }

  /// Creates a test Product entity
  static Product createTestProduct({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    String? description,
  }) {
    return Product(
      id: id ?? AppConstants.testProductId,
      name: name ?? AppConstants.testProductName,
      imageUrl: imageUrl ?? AppConstants.testProductImageUrl,
      price: price ?? AppConstants.testProductPrice,
      description: description ?? AppConstants.testProductDescription,
    );
  }

  /// Creates a list of test ProductModels
  static List<ProductModel> createTestProductModelList({int count = 1}) {
    return List.generate(
      count,
      (index) => createTestProductModel(
        id: '${index + 1}',
        name: 'Test Product ${index + 1}',
      ),
    );
  }

  /// Creates a list of test Product entities
  static List<Product> createTestProductList({int count = 1}) {
    return List.generate(
      count,
      (index) => createTestProduct(
        id: '${index + 1}',
        name: 'Test Product ${index + 1}',
      ),
    );
  }

  /// Creates test JSON response for products
  static Map<String, dynamic> createTestProductsJsonResponse(List<ProductModel> products) {
    return {
      AppConstants.dataKey: products.map((p) => p.toJson()).toList(),
    };
  }

  /// Creates test JSON response for single product
  static Map<String, dynamic> createTestProductJsonResponse(ProductModel product) {
    return {
      AppConstants.dataKey: product.toJson(),
    };
  }
}