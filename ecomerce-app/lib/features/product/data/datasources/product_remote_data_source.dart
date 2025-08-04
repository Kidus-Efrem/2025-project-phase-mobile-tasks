import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/http_client_helper.dart';
import '../../../../core/util/json_helper.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final HttpClientHelper _httpHelper;

  ProductRemoteDataSourceImpl({required http.Client client})
      : _httpHelper = HttpClientHelper(client: client);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await _httpHelper.get(Uri.parse(AppConstants.baseUrl));
    final jsonList = HttpClientHelper.parseJsonListFromResponse(
      response,
      AppConstants.dataKey,
    );

    return jsonList.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await _httpHelper.get(
      Uri.parse('${AppConstants.baseUrl}/$id'),
    );
    final decoded = HttpClientHelper.parseJsonResponse(response);
    return ProductModel.fromJson(decoded[AppConstants.dataKey]);
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    final fields = {
      AppConstants.nameFieldName: product.name,
      AppConstants.descriptionFieldName: product.description,
      AppConstants.priceFieldName: product.price.toString(),
    };

    await _httpHelper.postMultipart(
      Uri.parse(AppConstants.baseUrl),
      fields,
      product.imageUrl,
      AppConstants.imageFieldName,
    );
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final body = {
      AppConstants.nameFieldName: product.name,
      AppConstants.descriptionFieldName: product.description,
      AppConstants.priceFieldName: product.price,
    };

    await _httpHelper.put(
      Uri.parse('${AppConstants.baseUrl}/${product.id}'),
      body,
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _httpHelper.delete(Uri.parse('${AppConstants.baseUrl}/$id'));
  }
}
