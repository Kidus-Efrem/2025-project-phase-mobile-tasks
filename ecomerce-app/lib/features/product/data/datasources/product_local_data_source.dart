import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/util/json_helper.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getLastProductList();
  Future<ProductModel> getProductById(String id);
  Future<void> cacheProductList(List<ProductModel> products);
  Future<void> cacheProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences _sharedPreferences;

  ProductLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<List<ProductModel>> getLastProductList() async {
    final productList = await _readCachedProductList();
    if (productList != null) {
      return productList;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final productList = await _readCachedProductList();

    if (productList != null) {
      try {
        return productList.firstWhere((product) => product.id == id);
      } catch (_) {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProductList(List<ProductModel> products) async {
    await _writeProductListToCache(products);
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    final currentList = await _readCachedProductList() ?? [];
    currentList.removeWhere((p) => p.id == product.id);
    currentList.add(product);
    await _writeProductListToCache(currentList);
  }

  @override
  Future<void> deleteProduct(String id) async {
    final currentList = await _readCachedProductList();

    if (currentList != null) {
      final updatedList = currentList
          .where((product) => product.id != id)
          .toList();
      await _writeProductListToCache(updatedList);
    } else {
      throw CacheException();
    }
  }

  /// Reusable helper: Read list from cache using JsonHelper
  Future<List<ProductModel>?> _readCachedProductList() async {
    final jsonString = _sharedPreferences.getString(AppConstants.cachedProductListKey);
    final decodedJson = JsonHelper.safeDecodeList(jsonString);

    if (decodedJson != null) {
      return decodedJson.map((item) => ProductModel.fromJson(item)).toList();
    }
    return null;
  }

  /// Reusable helper: Write list to cache using JsonHelper
  Future<void> _writeProductListToCache(List<ProductModel> products) async {
    final jsonString = JsonHelper.encodeList(products.map((p) => p.toJson()).toList());
    await _sharedPreferences.setString(AppConstants.cachedProductListKey, jsonString);
  }
}
