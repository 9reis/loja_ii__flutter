import 'package:flutter/material.dart';
import 'package:loja_ii__flutter/data/dummy_data.dart';
import 'package:loja_ii__flutter/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;
  bool _showFavoriteOnly = false;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  void addProduct(Product product) {
    _items.add(product);
    // Notifica os interessados para que haja uma mudança na UI
    notifyListeners();
  }
}

// bool _showFavoriteOnly = false;

//   List<Product> get items {
//     // Verificação para retornar os itens que tem o favorite == true
//     if (_showFavoriteOnly) {
//       return _items.where((prod) => prod.isFavorite).toList();
//     }
//     // Se não, retorna todos os itens
//     return [..._items];
//   }

//   void showFavoriteOnly() {
//     _showFavoriteOnly = true;
//     notifyListeners();
//   }

//   void showAll() {
//     _showFavoriteOnly = false;
//     notifyListeners();
//   }