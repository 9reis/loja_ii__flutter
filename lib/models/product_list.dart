import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/data/dummy_data.dart';
import 'package:loja_ii__flutter/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;
  bool _showFavoriteOnly = false;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  void addProductFromData(Map<String, Object> data) {
    final newProduct = Product(
      id: Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    addProduct(newProduct);
  }

  void addProduct(Product product) {
    _items.add(product);

    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }
}
