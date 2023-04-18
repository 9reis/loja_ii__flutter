import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loja_ii__flutter/data/dummy_data.dart';
import 'package:loja_ii__flutter/models/product.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = 'https://shop-9reis-default-rtdb.firebaseio.com';

  List<Product> _items = dummyProducts;
  bool _showFavoriteOnly = false;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  void saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );
    if (hasId) {
      updateProduct(product);
    } else {
      addProduct(product);
    }
  }

  void addProduct(Product product) {
    // Recebe a URI
    final future = http.post(
      // Recebe a coleção que deseja armazenar os dados
      Uri.parse('$_baseUrl/products.json'),
      body: jsonEncode(
        {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        },
      ),
      // Espera a resposta da requisição
      // para poder executar o bloco de cod
    );
    future.then((res) {
      // Pega o corpo do obj salvo no banco
      // Retorna a chave 'name' e o id do obj como valor
      // print(jsonDecode(res.body));
      // PEGA o obj pelo id
      final id = jsonDecode(res.body)['name'];
      _items.add(
        Product(
          id: id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite,
        ),
      );
      notifyListeners();
    });
  }

  void updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    // Pega o indice para saber se o produto pertence a lista
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }

  int get itemsCount {
    return _items.length;
  }
}
