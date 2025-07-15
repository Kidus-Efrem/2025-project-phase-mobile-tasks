class Product {
  final int id;
  late String _name;
  late String _description;
  late double _price;

  Product({
    required this.id,
    required String name,
    required String description,
    required double price,
  }) {
    this.name = name;
    this.description = description;
    this.price = price;
  }

  String get name => _name;
  set name(String value) {
    if (value.isEmpty) throw ArgumentError('Name cannot be empty');
    _name = value;
  }

  String get description => _description;
  set description(String value) {
    if (value.isEmpty) throw ArgumentError('Description cannot be empty');
    _description = value;
  }

  double get price => _price;
  set price(double value) {
    if (value < 0) throw ArgumentError('Price cannot be negative');
    _price = value;
  }
}

class ProductManager {
  final List<Product> _products = [];
  int _nextId = 1;

  void addProduct({
    required String name,
    required String description,
    required double price,
  }) {
    final product = Product(
      id: _nextId++,
      name: name,
      description: description,
      price: price,
    );
    _products.add(product);
  }

  void viewAllProducts() {
    if (_products.isEmpty) {
      print('No products available');
      return;
    }

    print('\n===== ALL PRODUCTS =====');
    for (final product in _products) {
      print(product.name);
      print(product.description);
    }
  }

  void viewProduct(int id) {
    try {
      final product = _products.firstWhere((p) => p.id == id);
      print('\n===== PRODUCT DETAILS =====');
      print(product.name);
    } catch (e) {
      print('roduct with ID $id not found');
    }
  }

  void editProduct({
    required int id,
    String? name,
    String? description,
    double? price,
  }) {
    try {
      final product = _products.firstWhere((p) => p.id == id);
      bool updated = false;

      if (name != null) {
        product.name = name;
        updated = true;
      }
      if (description != null) {
        product.description = description;
        updated = true;
      }
      if (price != null) {
        product.price = price;
        updated = true;
      }
    } catch (e) {
      print('Product with ID $id not found');
    }
  }

  // Delete a product
  void deleteProduct(int id) {
    final initialLength = _products.length;
    _products.removeWhere((product) => product.id == id);

    if (_products.length < initialLength) {
      print(' Deleted product ID: $id');
    } else {
      print('Product with ID $id not found');
    }
  }
}

void main() {
  final manager = ProductManager();

  manager.addProduct(
    name: "iPhone 15",
    description: "Latest Apple",
    price: 999,
  );

  manager.addProduct(
    name: "Samsung Galaxy S23",
    description: "Android",
    price: 899,
  );

  manager.viewAllProducts();

  manager.viewProduct(1);

  manager.editProduct(id: 2, name: "Samsung Galaxy S23 Ultra", price: 1199.99);

  manager.viewProduct(2);

  manager.deleteProduct(1);

  manager.viewAllProducts();
}
