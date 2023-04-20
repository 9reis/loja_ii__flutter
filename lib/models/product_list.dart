import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loja_ii__flutter/exceptions/http_exception.dart';
import 'package:loja_ii__flutter/models/product.dart';
import 'package:loja_ii__flutter/utils/constants.dart';

class ProductList with ChangeNotifier {
  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  final String _token;
  final String _userId;
  List<Product> _items = [];
  bool _showFavoriteOnly = false;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  Future<void> loadProducts() async {
    // limpa a lista , para não duplicar os itens
    _items.clear();

    final res = await http.get(
      // Informando para o FB que o user está logado
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
    );
    // Só é possivel pegar a resposta pois está em um met async

    if (res.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse(
        '${Constants.USER_FAVORITES_URL}/$_userId.json?auth=$_token',
      ),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(res.body);

    data.forEach((productId, productData) {
      final isFavorie = favData[productId] ?? false;
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorie,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );
    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    // Recebe a URI
    final res = await http.post(
      // Recebe a coleção que deseja armazenar os dados
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        },
      ),
    );
    final id = jsonDecode(res.body)['name'];
    _items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    // Pega o indice para saber se o produto pertence a lista
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      // Exclui localmente
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      // Manda para o servidor
      // O servidor manda uma resposta, mesmo que tenha dado erro
      final res = await http.delete(Uri.parse(
          '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'));

      // Se deu erro, restaura os itens e notifica os listeners
      if (res.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        // Lança a excecao
        throw HttpException(
          msg: 'Não foi possivel excluir o produto',
          statusCode: res.statusCode,
        );
      }
    }
  }

  int get itemsCount {
    return _items.length;
  }
}
